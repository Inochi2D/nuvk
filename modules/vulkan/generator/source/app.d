module app;

import std.stdio;
import std.algorithm;
import std.array;
import std.conv : parse;
import std.net.curl;
import std.array : array;
import std.parallelism;
import std.path;
import std.range;

import cli;
import logger;
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

    VkRegistry[] registries;


    /** 
     * Construct our app instance.
     * 
     * Params:
     *   args = Command-line arguments, should be `args[1..$]` when taken from main.
     */
    this(string[] args) {
        input = Input(args);
        logger = new Logger(input.verbose);
        registries = new VkRegistry[input.names.length];
    }

    /** 
     * App entry point.
     * 
     * Returns: An error code, or 0 on success.
     */
    int run() {
        foreach (i, url; parallel(input.names.map!toUrl)) {
            if (input.verbose) {
                logger.dbg(1, "Fetching <orange>%s</orange>...", url);
            }

            try {
                auto name = url.baseName(".xml");
                auto spec = cast(string) get(url);
                auto parser = new VkRegistryParser(name, spec, logger);
                registries[i] = parser.parseDocument();
            } catch (Exception ex) {
                logger.err("%s", ex.msg);
            }
        }

        if (!input.list.empty) {
            foreach (i, ref registry; registries) {
                logger.info("Registry <yellow>%s</yellow>", registry.name);

                foreach (ls; input.list) {
                    switch (ls) {
                        case "platforms":
                            listPlatforms(registry);
                            break;

                        case "vendors":
                            listVendors(registry);
                            break;

                        case "defines":
                            listDefines(registry);
                            break;

                        case "basetypes":
                            listBasetypes(registry);
                            break;

                        case "handles":
                            listHandles(registry);
                            break;

                        case "structs":
                            listStructs(registry);
                            break;

                        case "enums":
                            listEnums(registry);
                            break;

                        case "commands":
                            listCommands(registry);
                            break;

                        case "features":
                            listFeatures(registry);
                            break;

                        case "extensions":
                            listExtensions(registry);
                            break;

                        default:
                            logger.warn("<u>%s</u> is not listable", ls);
                            break;
                    }
                }

                if (i + 1 < registries.length) {
                    logger.line();
                }
            }
        }

        if (!input.dryrun) {
            foreach (i, ref registry; registries) {
                string preamble = registry.name == "vk" ? import("vk_preamble.txt") : "";
                auto emitter = new VkRegistryEmitter(registry, stdout, logger);
                emitter.emit(preamble);
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

    private void listCommands(ref VkRegistry registry) {
        foreach (ref command; registry.commands) {
            const pipe = command.params.length > 0 ? "┏╸" : "╺╸";

            if (command.alias_.empty) {
                logger.info("%s<yellow>%s</yellow>", pipe, command.name);
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
            const pipe = section.enums.length > 0 ? "┏╸" : "╺╸";
            logger.info("%s<grey>%s</grey>", pipe, section.name);
        }
    }
}


/** 
 * Command-line input.
 */
struct Input {
    string[] names;

    string[] list;

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
            names ~= ["vk", "video"];
        }
    }

    private Expect handleLong(ArgKey key, ArgValue value) {
        switch (key.get) {
            case "verbose":
                return handleVerbose(value);

            case "list":
                return handleList(value);

            case "dry-run":
                return handleDryRun(value);

            default:
                return Expect.Name;
        }
    }

    private Expect handleShort(ArgKey key, ArgValue value) {
        foreach (c; key.get) {
            switch (c) {
                case 'v':
                    handleVerbose(value);
                    break;

                default:
                    break;
            }
        }

        return Expect.Name;
    }

    private Expect handleValue(Expect expect, ArgValue value) {
        switch (expect) {
            case Expect.Name:
                names ~= value.get;
                return expect;

            case Expect.List:
                list ~= value.get.split(",");
                return expect;

            default:
                return Expect.Name;
        }
    }

    private Expect handleVerbose(ArgValue value) {
        if (value.isNull) {
            verbose += 1;
        } else if (value.get == "true") {
            verbose = 1;
        } else if (value.get == "false") {
            verbose = 0;
        } else {
            verbose = value.get.parse!int;
        }

        return Expect.Name;
    }

    private Expect handleList(ArgValue value) {
        dryrun = true;
        if (value.isNull) {
            return Expect.List;
        } else {
            list ~= value.get.split(",");
            return Expect.Name;
        }
    }

    private Expect handleDryRun(ArgValue value) {
        dryrun = value.isNull ? true : value.get.parse!bool;
        return Expect.Name;
    }

    private enum Expect {
        Name,
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