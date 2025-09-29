module parser;

import std.algorithm;
import std.array;
import std.conv : to, text;
import std.exception : enforce;
import std.format : format;
import std.traits;

import yxml;

import registry;
import logger;


/** 
 * Parses Vulkan registries from XML documents.
 */
class VkRegistryParser {
    private VkRegistry registry;

    private XmlDocument doc;

    private Logger logger;


    /** 
     * Constructs an empty registry from the given text into an XML document.
     * 
     * Params:
     *   name = The name of this registry.
     *   xml = The XML text to parse into our contents.
     *   logger = The logger to use for informing users of progress/problems.
     */
    this(string name, string xml, Logger logger) {
        // Initialize our Vulkan registry.
        registry = new VkRegistry;
        registry.name = name;

        // Parse text into an XML document and assert that this succeeds.
        enforce(doc.parse(xml), doc.errorMessage.dup);

        // Store our logger instance.
        this.logger = logger;
    }

    /** 
     * Parse our XML document into a Vulkan registry.
     * 
     * Returns: The registry containing all the information from our document.
     */
    VkRegistry parse() {
        // Iterate root nodes of our document to interpret its contents.
        foreach (child; doc.root.childNodes.mapToNonNullElements) {
            parseElement(child);
        }

        // Return our resulting registry.
        return registry;
    }

    private void parseElement(XmlElement element) {
        switch (element.tagName) {
            case "platforms":
                return parsePlatforms(element);

            case "tags":
                return parseVendors(element);

            case "types":
                return parseTypes(element);

            case "enums":
                return parseEnums(element);

            case "comment":
                return logger.dbg(1, "<grey>%s</grey>", element.textContent.esc);

            default:
                break;
        }
    }

    private void parsePlatforms(XmlElement element) {
        assert(element.tagName == "platforms");

        foreach (child; element.childNodes.mapToNonNullElements) {
            registry.platforms ~= VkPlatform(
                child.getAttribute("name").idup,
                child.getAttribute("comment").idup,
                child.getAttribute("protect").idup,
            );
        }
    }

    private void parseVendors(XmlElement element) {
        assert(element.tagName == "tags");

        foreach (child; element.childNodes.mapToNonNullElements) {
            registry.vendors ~= VkVendor(
                child.getAttribute("name").idup,
                child.getAttribute("author").idup,
                child.getAttribute("contact").idup,
            );
        }
    }

    private void parseTypes(XmlElement element) {
        assert(element.tagName == "types");

        foreach (child; element.childNodes.mapToNonNullElements) {
            const name = child.getAttribute("name");
            const category = child.getAttribute("category");

            switch (category) {
                case "struct":
                    registry.structs ~= parseStructType(child);
                    break;

                default:
                    logger.dbg(1, "Skipping %s <yellow>%s</yellow>", category, name);
                    logger.dbg(2, "%s", child.innerHTML.esc);
                    break;
            }
        }
    }

    private void parseEnums(XmlElement element) {
        registry.enums ~= parseEnumType(element);
    }

    private VkEnumType parseEnumType(XmlElement root) {
        if (root.tagName != "enums") {
            logger.err("Malformed enum type %s!", root.tagName);
            return VkEnumType.init;
        }

        VkEnumType result;

        if (auto name_ = root.getAttribute("name")) {
            result.name = name_.idup;
        }

        if (auto category_ = root.getAttribute("category")) {
            result.category = category_.idup;
        }

        if (auto comment_ = root.getAttribute("comment")) {
            result.comment = comment_.idup;
        }

        foreach (child; root.childNodes.mapToNonNullElements) {
            if (child.tagName != "enum") {
                continue;
            }

            VkEnumMember member;

            if (auto name_ = child.getAttribute("name")) {
                member.name = result.name.idup;
            }

            if (auto comment_ = child.getAttribute("comment")) {
                member.comment = comment_.idup;
            }

            if (auto value_ = child.getAttribute("value")) {
                member.value = value_.idup;
            }

            if (auto bitpos_ = child.getAttribute("bitpos")) {
                member.value = (1 << bitpos_.to!ulong).text;
                result.members ~= member;
                continue;
            }

            result.members ~= member;
        }

        return result;
    }

    private VkStructType parseStructType(XmlElement root) {
        VkStructType result;

        result.name = root.getAttribute("name").idup;
        result.category = root.getAttribute("category").idup;

        if (root.tagName != "type" && result.category != "struct") {
            logger.err("Malformed struct type %s!", root.tagName);
            return VkStructType.init;
        }

        if (auto extends_ = root.getAttribute("structextends")) {
            result.extends = extends_.idup;
        }

        foreach (child; root.childNodes.mapToNonNullElements) {
            if (child.tagName != "member") {
                continue;
            }

            VkStructMember member;

            if (auto name_ = child.firstChildByTagName("name")) {
                member.name = name_.textContent.idup;
            }

            if (auto type_ = child.textContent) {
                member.type = parseTypeString(cast(string)type_[0..$-member.name.length]);
            }

            if (auto comment_ = child.getAttribute("comment")) {
                member.comment = comment_.idup;
            }

            if (auto values_ = child.getAttribute("values")) {
                member.values = values_.idup;
            }

            result.members ~= member;
        }

        return result;
    }

	private string parseTypeString(string type) {
		import std.algorithm.searching : startsWith;
		import std.ascii : isAlphaNum, isWhite;

		string out_;
		size_t i = 0;

		while (i < type.length) {
			string slice = type[i..$];

			if (slice.startsWith("const")) {
				i += 6;

				out_ ~= "const(";
				size_t si = i;
				while (isAlphaNum(type[i]) || type[i] == '_') {
					if (i > type.length) {
						break;
					}

					i++;
				}

				out_ ~= type[si..i] ~ ")";
				continue;
			}

			if (isWhite(type[i])) {
				i++;
				continue;
			}

			out_ ~= type[i];
			i++;
		}

		return out_;
	}
}


/** 
 * Map/filter an iterable range of XML nodes to its XML element subset.
 * 
 * Params:
 *   nodes = Any range of nodes, but presumably `XmlNode.ChildRange`.
 */
private auto mapToNonNullElements(T)(T nodes) if (isIterable!T) {
	return nodes.map!(e => cast(XmlElement) e).filter!(e => e !is null);
}