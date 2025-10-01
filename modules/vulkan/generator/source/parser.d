module parser;

import std.algorithm;
import std.array;
import std.conv : to, text, parse;
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
    VkRegistry parseDocument() {
        // Iterate root nodes of our document to interpret its contents.
        foreach (child; doc.root.childElements) {
            parseElement(child);
        }

        // Return our resulting registry.
        return registry;
    }

    /**
     * Parse elements directly under the main <registry> tag, AKA "root" tags.
     */
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

            case "commands":
                return parseCommands(element);

            case "feature":
                return parseFeature(element);

            case "extensions":
                return parseExtensions(element);

            case "comment":
                return logger.dbg(1, "<grey>%s</grey>", element.textContent);

            default:
                break;
        }
    }

    /** 
     * Parse <platform> information grouped under the <platforms> root tag.
     */
    private void parsePlatforms(XmlElement element)
        in (element.tagName == "platforms")
    {
        foreach (child; element.childElements) {
            registry.platforms ~= VkPlatform(
                child.getAttribute("name").idup,
                child.getAttribute("comment").idup,
                child.getAttribute("protect").idup,
            );
        }
    }

    /** 
     * Parse <vendor> information grouped under the <vendors> root tag.
     */
    private void parseVendors(XmlElement element)
        in (element.tagName == "tags")
    {
        foreach (child; element.childElements) {
            registry.vendors ~= VkVendor(
                child.getAttribute("name").idup,
                child.getAttribute("author").idup,
                child.getAttribute("contact").idup,
            );
        }
    }

    /** 
     * Parse type "forward-declarations" grouped under the <types> root tag.
     */
    private void parseTypes(XmlElement element)
        in (element.tagName == "types")
    {
        foreach (child; element.childElements) {
            const name = child.getAttribute("name");
            const category = child.getAttribute("category");

            switch (category.toVkTypeCategory) {
                case VkTypeCategory.Struct:
                    registry.structs ~= parseStructType(child);
                    break;

                case VkTypeCategory.None:
                    parseNoneType(child);
                    break;

                default:
                    logger.dbg(1, "Skipping %s <yellow>%s</yellow>", category, name);
                    logger.dbg(2, "%s", child.innerHTML);
                    break;
            }
        }
    }

    /** 
     * Parse <type category="struct"> tags.
     */
    private VkStructType parseStructType(XmlElement root) {
        VkStructType result;

        result.name = root.getAttribute("name").idup;

        result.category = toVkTypeCategory(root.getAttribute("category").idup);

        if (auto extends_ = root.getAttribute("structextends")) {
            result.extends = extends_.idup;
        }

        foreach (child; root.childElements) {
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

            if (auto optional = child.getAttribute("optional")) {
                member.optional = parse!bool(optional);
            }

            result.members ~= member;
        }

        return result;
    }

    /** 
     * Parse <type> tags without a category attribute.
     */
    private void parseNoneType(XmlElement element) {
        const(char)[] nameText;
        // string typeText;

        if (auto name = element.getAttribute("name")) {
            nameText = name;
        } else if (auto name = element.firstChildByTagName("name")) {
            nameText = name.textContent;
        }

        // if (auto type = element.firstChildByTagName("type")) {
        //     typeText = type.textContent.idup;
        // }

        logger.dbg(1, "Skipping type <yellow>%s</yellow>", nameText);
    }

    /** 
     * Parse <enums> root tags.
     * 
     * Unlike every other type in these documents, enums are not grouped using
     *   any kind of parent tag unique to them and are instead listed directly
     *   as children of the <registry> tag. Why this was done boggles my mind.
     */
    private void parseEnums(XmlElement element)
        in (element.tagName == "enums")
    {
        VkEnumType result;

        if (auto name_ = element.getAttribute("name")) {
            result.name = name_.idup;
        }

        if (auto category_ = element.getAttribute("category")) {
            result.category = toVkTypeCategory(category_.idup);
        }

        if (auto comment_ = element.getAttribute("comment")) {
            result.comment = comment_.idup;
        }

        if (auto bitmask = element.getAttribute("bitmask")) {
            result.bitmask = parse!bool(bitmask);
        }

        foreach (child; element.childElements) {
            if (child.tagName != "enum") {
                continue;
            }

            VkEnumMember member;

            if (auto name_ = child.getAttribute("name")) {
                member.name = name_.idup;
            }

            if (auto comment_ = child.getAttribute("comment")) {
                member.comment = comment_.idup;
            }

            if (auto value_ = child.getAttribute("value")) {
                member.value = value_.idup;
            } else if (auto bitpos_ = child.getAttribute("bitpos")) {
                member.value = (1 << bitpos_.to!ulong).text;
            }

            result.members ~= member;
        }

        registry.enums ~= result;
    }

    /** 
     * Parse <command> information grouped under the <commands> root tag.
     */
    private void parseCommands(XmlElement element)
        in (element.tagName == "commands")
    {
        foreach (child; element.childElements) {
            registry.commands ~= parseCommand(child);
        }
    }

    /** 
     * Parse an individual <command> tag and return its value.
     */
    private VkCommand parseCommand(XmlElement element) {
        VkCommand result;

        if (auto alias_ = element.getAttribute("alias")) {
            result.name = element.getAttribute("name").idup;
            result.alias_ = alias_.idup;
            return result;
        }

        if (auto successes = element.getAttribute("successcodes")) {
            result.successes = successes.idup.split(",");
        }

        if (auto errors = element.getAttribute("errorcodes")) {
            result.errors = errors.idup.split(",");
        }

        if (auto proto = element.firstChildByTagName("proto")) {
            if (auto name = proto.firstChildByTagName("name")) {
                result.name = name.textContent.idup;
            }
        }

        if (auto comment = element.getAttribute("comment")) {
            result.comment = comment.idup;
        }

        foreach (child; element.childElements.filter!(e => e.tagName == "param")) {
            VkCommandParam param;

            // if (auto optional = child.getAttribute("optional")) {
            //     param.optional = optional.parse!bool;
            // }

            if (auto name = child.firstChildByTagName("name")) {
                param.name = name.textContent.idup;
            }

            if (auto type = child.firstChildByTagName("type")) {
                param.type = type.textContent.idup;
            }

            if (auto comment = child.getAttribute("comment")) {
                param.comment = comment.idup;
            }

            result.params ~= param;
        }

        return result;
    }

    /** 
     * Parse <feature> root tags.
     * 
     * I lied earlier. Enums aren't the only tag that do this, the feature tag
     *   is also used for direct children of the <registry> tag. Who wrote the
     *   schema for this thing???
     */
    private void parseFeature(XmlElement element)
        in (element.tagName == "feature")
    {
        registry.features ~= VkFeature(
            element.getAttribute("name").idup,
        );
    }

    /** 
     * Parse <extension> information grouped under the <extensions> root tag.
     */
    private void parseExtensions(XmlElement element)
        in (element.tagName == "extensions")
    {
        foreach (child; element.childElements) {
            registry.extensions ~= VkExtension(
                child.getAttribute("name").idup,
            );
        }
    }

    /** 
     * Utility for parsing a type string into D form.
     * 
     * Params:
     *   type = A type in string form as obtained from an XML document.
     * 
     * Returns: The D equivalent of the given type.
     */
    private static string parseTypeString(string type) {
        import std.algorithm.searching : startsWith;
        import std.ascii : isAlphaNum, isWhite;

        string result;

        for (size_t i = 0; i < type.length;) {
            string slice = type[i..$];

            if (slice.startsWith("const")) {
                i += 6;

                result ~= "const(";
                size_t si = i;
                while (isAlphaNum(type[i]) || type[i] == '_') {
                    if (i > type.length) {
                        break;
                    }

                    i++;
                }

                result ~= type[si..i] ~ ")";
                continue;
            }

            if (isWhite(type[i])) {
                i++;
                continue;
            }

            result ~= type[i];
            i++;
        }

        return result;
    }
}


/** 
 * Pretend that XmlElement has a property called childElements.
 * 
 * Params:
 *   element = Any XML element instance.
 */
private auto childElements(XmlElement element) {
    return element.childNodes.mapToNonNullElements;
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