module app;

import std.stdio;
import std.algorithm;
import std.array;
import std.conv : parse;
import curl = std.net.curl;
import std.array : array;
import std.parallelism;
import std.path;
import std.range;

import util;
import registry;
import parser;
import emitter;


enum urlPrefix = "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Docs/refs/heads/main/xml/";


int main(string[] args) {
    auto app = App(args[1..$]);
    return app.run();
}


/** 
 * App instance struct.
 */
struct App {
    Input input;

    Logger logger;

    VkRegistry vulkan;

    VkRegistry video;


    /** 
     * Construct our app instance.
     * 
     * Params:
     *   args = Command-line arguments, should be `args[1..$]` when taken from main.
     */
    this(string[] args) {
        input = Input(args);
        logger = new Logger(input.verbose);
    }

    /** 
     * App entry point.
     * 
     * Returns: An error code, or 0 on success.
     */
    int run() {
        auto registries = new VkRegistry[2];
        foreach (i, url; parallel(input.sources)) {
            if (input.verbose) {
                auto name = url.baseName(".xml");
                logger.dbg(1, "fetching <yellow>%s</yellow> from <orange>%s</orange>", name, url);
            }

            try {
                auto spec = cast(string) curl.get(url);
                auto parser = new VkRegistryParser(spec, logger);
                registries[i] = parser.parseDocument();
            } catch (Exception ex) {
                logger.err("%s", ex.msg);
            }
        }

        vulkan = registries[0];
        video = registries[1];

        if (!input.list.empty) {
            foreach (ls; input.list) {
                switch (ls) {
                    case "platforms":
                        listPlatforms(vulkan);
                        break;

                    case "vendors":
                        listVendors(vulkan);
                        break;

                    case "defines":
                        listDefines(vulkan);
                        break;

                    case "basetypes":
                        listBasetypes(vulkan);
                        break;

                    case "bitmasks":
                        listBitmasks(vulkan);
                        break;

                    case "handles":
                        listHandles(vulkan);
                        break;

                    case "enums":
                        listEnums(vulkan);
                        break;

                    case "funcptrs":
                        listFuncPtrs(vulkan);
                        break;

                    case "structs":
                        listStructs(vulkan);
                        break;

                    case "unions":
                        listUnions(vulkan);
                        break;

                    case "commands":
                        listCommands(vulkan);
                        break;

                    case "features":
                        listFeatures(vulkan);
                        break;

                    case "extensions":
                        listExtensions(vulkan);
                        break;

                    default:
                        logger.warn("<u>%s</u> is not listable", ls);
                        break;
                }
            }
        }

        if (!input.dryrun) {
            foreach (name; input.names) {
                switch (name) {
                    case "core":
                        emitCore(vulkan, stdout, logger);
                        break;

                    default:
                        emitExt(vulkan, name, stdout, logger);
                        break;
                }
            }
        }

        return 0;
    }

    private void listPlatforms(ref VkRegistry registry) {
        const namepad = registry.platforms.map!(p => p.name.length).maxElement(0);
        const protpad = registry.platforms.map!(p => p.protect.length).maxElement(0);
        foreach (ref platform; registry.platforms) {
            logger.info(
                "<yellow>%-*s</yellow>   <blue>%-*s</blue>   <grey>%s</grey>",
                namepad, platform.name, protpad, platform.protect, platform.comment,
            );
        }

        if (registry.platforms.length == 0) {
            logger.info("<grey>%s</grey>", "(no platforms)");
        }
    }

    private void listVendors(ref VkRegistry registry) {
        const namepad = registry.vendors[].map!(v => v.ext.length).maxElement(0);
        const authpad = registry.vendors[].map!(v => v.author.length).maxElement(0);
        foreach (ref vendor; registry.vendors) {
            logger.info(
                "<yellow>%-*s</yellow>   <grey>%-*s</grey>   <grey>%s</grey>",
                namepad, vendor.ext, authpad, vendor.author, vendor.contact,
            );
        }

        if (registry.vendors.length == 0) {
            logger.info("<grey>%s</grey>", "(no vendors)");
        }
    }

    private void listDefines(ref VkRegistry registry) {
        foreach (ref define; registry.defines) {
            if (define.funclike) {
                logger.info("<lblue>%s</lblue>(...)", define.name);
            } else {
                logger.info("<lblue>%s</lblue>", define.name);
            }
        }

        if (registry.defines.length == 0) {
            logger.info("<grey>%s</grey>", "(no defines)");
        }
    }

    private void listBasetypes(ref VkRegistry registry) {
        foreach (ref basetype; registry.basetypes) {
            if (basetype.type.empty) {
                logger.info("<lgreen>%s</lgreen>", basetype.name);
            } else {
                logger.info("<lgreen>%s</lgreen> : <lgreen>%s</lgreen>", basetype.name, basetype.type);
            }
        }

        if (registry.basetypes.length == 0) {
            logger.info("<grey>%s</grey>", "(no basetypes)");
        }
    }

    private void listBitmasks(ref VkRegistry registry) {
        foreach (ref bitmask; registry.bitmasks) {
            if (bitmask.requires.empty) {
                logger.info("<lgreen>%s</lgreen> : <lblue>%s</lblue>", bitmask.name, bitmask.backing);
            } else {
                logger.info("<lgreen>%s</lgreen> : <lgreen>%s</lgreen>", bitmask.name, bitmask.requires);
            }
        }

        if (registry.basetypes.length == 0) {
            logger.info("<grey>%s</grey>", "(no bitmasks)");
        }
    }

    private void listHandles(ref VkRegistry registry) {
        foreach (ref handle; registry.handles) {
            if (handle.alias_.empty) {
                logger.info("<lgreen>%s</lgreen>", handle.name);
            } else {
                logger.info("<lblue>%s</lblue> = <yellow>%s</yellow>", handle.name, handle.alias_);
            }
        }

        if (registry.handles.length == 0) {
            logger.info("<grey>%s</grey>", "(no handles)");
        }
    }

    private void listEnums(ref VkRegistry registry) {
        foreach (ref enum_; registry.enums) {
            const pipe = enum_.members.length > 0 ? "┏╸" : "╺╸";

            logger.info("%s<lgreen>%s</lgreen>", pipe, enum_.name);

            const namepad = enum_.members[].map!(m => m.name.length).maxElement(0);
            const valuepad = enum_.members[].map!(m => m.value.length).maxElement(0);
            foreach (mi, ref member; enum_.members[]) {
                const mpipe = mi + 1 == enum_.members.length ? "┗━━╸" : "┣━━╸";
                logger.info(
                    "%s<lgrey>%-*s</lgrey>   <lgreen>%-*s</lgreen>   <grey>%s</grey>",
                    mpipe, namepad, member.name, valuepad, member.value, member.comment,
                );
            }
        }

        if (registry.enums.length == 0) {
            logger.info("<grey>%s</grey>", "(no enums)");
        }
    }

    private void listFuncPtrs(ref VkRegistry registry) {
        foreach (ref funcptr; registry.funcptrs) {
            const pipe = funcptr.params.length > 0 ? "┏╸" : "╺╸";
            logger.info("%s<lgreen>%s</lgreen> -&gt; <lgreen>%s</lgreen>", pipe, funcptr.name, funcptr.type);

            const namepad = funcptr.params.map!(p => p.name.length).maxElement(0);
            foreach (pi, ref param; funcptr.params) {
                const ppipe = pi + 1 == funcptr.params.length ? "┗━━╸" : "┣━━╸";
                logger.info(
                    "%s<lgrey>%-*s</lgrey>   <lgreen>%s</lgreen>",
                    ppipe, namepad, param.name, param.type,
                );
            }
        }
    }

    private void listStructs(ref VkRegistry registry) {
        foreach (ref struct_; registry.structs) {
            const pipe = struct_.members.length > 0 ? "┏╸" : "╺╸";

            if (struct_.extends.empty) {
                logger.info("%s<lgreen>%s</lgreen>", pipe, struct_.name);
            } else {
                logger.info("%s<lgreen>%s</lgreen> : <lgreen>%s</lgreen>", pipe, struct_.name, struct_.extends);
            }

            const namepad = struct_.members.map!(m => m.name.length).maxElement(0);
            const typepad = struct_.members.map!(m => m.type.length).maxElement(0);
            foreach (mi, ref member; struct_.members) {
                const mpipe = mi + 1 == struct_.members.length ? "┗━━╸" : "┣━━╸";
                if (member.optional) {
                    logger.info(
                        "%s<grey>%-*s</grey>   <lgreen>%-*s</lgreen>   <grey>%s</grey>",
                        mpipe, namepad, member.name, typepad, member.type, member.comment,
                    );
                } else {
                    logger.info(
                        "%s<lgrey>%-*s</lgrey>   <lgreen>%-*s</lgreen>   <grey>%s</grey>",
                        mpipe, namepad, member.name, typepad, member.type, member.comment,
                    );
                }
            }
        }

        if (registry.structs.length == 0) {
            logger.info("<grey>%s</grey>", "(no structs)");
        }
    }

    private void listUnions(ref VkRegistry registry) {
        foreach (ref union_; registry.unions) {
            const pipe = union_.members.length > 0 ? "┏╸" : "╺╸";

            logger.info("%s<lgreen>%s</lgreen>", pipe, union_.name);

            const namepad = union_.members.map!(m => m.name.length).maxElement(0);
            const typepad = union_.members.map!(m => m.type.length).maxElement(0);
            foreach (mi, ref member; union_.members) {
                const mpipe = mi + 1 == union_.members.length ? "┗━━╸" : "┣━━╸";
                logger.info(
                    "%s<lgrey>%-*s</lgrey>   <lgreen>%-*s</lgreen>   <grey>%s</grey>",
                    mpipe, namepad, member.name, typepad, member.type, member.comment,
                );
            }
        }

        if (registry.unions.length == 0) {
            logger.info("<grey>%s</grey>", "(no unions)");
        }
    }

    private void listCommands(ref VkRegistry registry) {
        foreach (ref command; registry.commands) {
            const pipe = command.params.length > 0 ? "┏╸" : "╺╸";

            if (command.alias_.empty) {
                logger.info("%s<yellow>%s</yellow> -&gt; <lgreen>%s</lgreen>", pipe, command.name, command.type);
            } else {
                logger.info("%s<lblue>%s</lblue> = <yellow>%s</yellow>", pipe, command.name, command.alias_);
            }

            const namepad = command.params.map!(p => p.name.length).maxElement(0);
            const typepad = command.params.map!(p => p.type.length).maxElement(0);
            foreach (pi, ref param; command.params) {
                const ppipe = pi + 1 == command.params.length ? "┗━━╸" : "┣━━╸";
                logger.info(
                    "%s<lgrey>%-*s</lgrey>   <lgreen>%-*s</lgreen>   <grey>%s</grey>",
                    ppipe, namepad, param.name, typepad, param.type, param.comment,
                );
            }
        }

        if (registry.commands.length == 0) {
            logger.info("<grey>%s</grey>", "(no commands)");
        }
    }

    private void listFeatures(ref VkRegistry registry) {
        foreach (ref feature; registry.features) {
            logger.info("<lblue>%s</lblue>", feature.name);
            listSections(registry, feature.sections);
        }

        if (registry.features.length == 0) {
            logger.info("<grey>%s</grey>", "(no features)");
        }
    }

    private void listExtensions(ref VkRegistry registry) {
        bool supportedByVulkan(ref VkExtension ext) => ext.supported.empty || ext.supported.canFind("vulkan");

        foreach (ref extension; registry.extensions[].filter!supportedByVulkan) {
            logger.info("<yellow>%s</yellow> - %d", extension.name, extension.number);
            listSections(registry, extension.sections);
        }

        if (registry.extensions.length == 0) {
            logger.info("<grey>%s</grey>", "(no extensions)");
        }
    }

    private void listSections(ref VkRegistry registry, VkSection[] sections) {
        foreach (ref section; sections) {
            const pipe = section.mconsts.length > 0 ? "┏╸" : "╺╸";
            logger.info("%s<grey>%s</grey>", pipe, section.name);
        }
    }
}


/** 
 * Command-line input.
 */
struct Input {
    string[] list;

    string[] names;

    string vk;

    string video;

    bool dryrun = false;

    int verbose = 0;


    /** 
     * Parse our command-line input from the given arguments.
     * 
     * Params:
     *   args = Command-line arguments, should be `args[1..$]` when taken from main.
     */
    this(string[] args) {
        Expect expect;

        foreach (arg; args) {
            ArgKey key;
            ArgValue value;

            switch (arg.parseArg(key, value)) {
                case ArgType.Long:
                    expect = handleLong(key, value);
                    break;

                case ArgType.Short:
                    expect = handleShort(key, value);
                    break;

                case ArgType.Value:
                    expect = handleValue(expect, value);
                    break;

                default:
                    break;
            }
        }

        if (names.empty) {
            names = ["core"];
        }

        if (vk.empty) {
            vk = toUrl("vk");
        }

        if (video.empty) {
            video = toUrl("video");
        }
    }

    /** 
     * List of source XML files to parse.
     */
    @property string[] sources() const => [vk, video];

    private Expect handleLong(ArgKey key, ArgValue value) {
        switch (key.get) {
            case "vk":
                return handleVkArg(value);

            case "video":
                return handleVideoArg(value);

            case "list":
                return handleListArg(value);

            case "dry-run":
                return handleDryRunArg(value);

            case "verbose":
                return handleVerboseArg(value);

            default:
                return Expect.Arg;
        }
    }

    private Expect handleShort(ArgKey key, ArgValue value) {
        foreach (c; key.get) {
            switch (c) {
                case 'r':
                    handleDryRunArg(value);
                    break;

                case 'v':
                    handleVerboseArg(value);
                    break;

                default:
                    break;
            }
        }

        return Expect.Arg;
    }

    private Expect handleValue(Expect expect, ArgValue value) {
        switch (expect) {
            case Expect.Arg:
                names ~= value.get;
                return expect;

            case Expect.List:
                list ~= value.get.split(",");
                return expect;

            default:
                return Expect.Arg;
        }
    }

    private Expect handleVkArg(ArgValue value) {
        if (value.isNull) {
            return Expect.Vk;
        } else {
            vk = value.get;
            return Expect.Arg;
        }
    }

    private Expect handleVideoArg(ArgValue value) {
        if (value.isNull) {
            return Expect.Video;
        } else {
            video = value.get;
            return Expect.Arg;
        }
    }

    private Expect handleListArg(ArgValue value) {
        dryrun = true;
        if (value.isNull) {
            return Expect.List;
        } else {
            list ~= value.get.split(",");
            return Expect.Arg;
        }
    }

    private Expect handleDryRunArg(ArgValue value) {
        dryrun = value.isNull ? true : value.get.parse!bool;
        return Expect.Arg;
    }

    private Expect handleVerboseArg(ArgValue value) {
        if (value.isNull) {
            verbose += 1;
        } else if (value.get == "true") {
            verbose = 1;
        } else if (value.get == "false") {
            verbose = 0;
        } else {
            verbose = value.get.parse!int;
        }

        return Expect.Arg;
    }

    private enum Expect {
        Arg = 0,

        Vk,
        Video,
        List,
    }
}

/** 
 * Coerces a name to a Vulkan spec URL, if it isn't one already.
 * 
 * Params:
 *   name = Name or URL of a Vulkan spec document.
 * 
 * Returns: URL of a Vulkan spec document.
 */
string toUrl(string name) {
    if (name.startsWith("https://")) {
        return name;
    } else {
        const filename = name.withDefaultExtension("xml").array();
        return buildPath(urlPrefix, filename);
    }
}