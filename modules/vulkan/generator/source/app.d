module app;

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
import parser;
import registry;


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
                registries[i] = parser.parse();
            } catch (Exception ex) {
                logger.err(ex.msg);
            }
        }

        foreach (ls; input.list) {
            switch (ls) {
                case "platforms":
                    listPlatforms();
                    break;

                case "vendors":
                    listVendors();
                    break;

                default:
                    break;
            }
        }

        return 0;
    }

    private void listPlatforms() {
        foreach (i, registry; registries) {
            logger.info("Registry <yellow>%s</yellow>", registry.name.baseName(".xml"));

            const namepad = registry.platforms.map!(p => p.name.length).maxElement(0);
            const protpad = registry.platforms.map!(p => p.protect.length).maxElement(0);
            foreach (platform; registry.platforms) {
                logger.info(
                    "<yellow>%-*s</yellow>   <blue>%-*s</blue>   <grey>%s</grey>",
                    namepad, platform.name, protpad, platform.protect, platform.comment,
                );
            }

            if (registry.platforms.length == 0) {
                logger.info("<grey>%s</grey>", "(no platforms)");
            }

            if (i + 1 < registries.length) {
                logger.line();
            }
        }
    }

    private void listVendors() {
        foreach (i, registry; registries) {
            logger.info("Registry <yellow>%s</yellow>", registry.name.baseName(".xml"));

            const namepad = registry.vendors.map!(v => v.ext.length).maxElement(0);
            const authpad = registry.vendors.map!(v => v.author.length).maxElement(0);
            foreach (vendor; registry.vendors) {
                logger.info(
                    "<yellow>%-*s</yellow>   <grey>%-*s</grey>   <grey>%s</grey>",
                    namepad, vendor.ext, authpad, vendor.author, vendor.contact,
                );
            }

            if (registry.vendors.length == 0) {
                logger.info("<grey>%s</grey>", "(no vendors)");
            }

            if (i + 1 < registries.length) {
                logger.line();
            }
        }
    }
}


/** 
 * Command-line input.
 */
struct Input {
    string[] names;

    string[] list;

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
            verbose = parse!int(value.get);
        }

        return Expect.Name;
    }

    private Expect handleList(ArgValue value) {
        if (value.isNull) {
            return Expect.List;
        } else {
            list ~= value.get.split(",");
            return Expect.Name;
        }
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