module parser;

import std.algorithm;
import std.array;
import std.conv : to, text, parse;
import std.exception : enforce;
import std.format : format;
import std.traits;
import std.range;
import std.regex;
import std.string;

import yxml;

import util;
import parsers;
import registry;


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
     *   xml = The XML text to parse into our contents.
     *   logger = The logger to use for informing users of progress/problems.
     */
    this(string xml, Logger logger) {
        // Initialize our Vulkan registry.
        registry = new VkRegistry;

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
                return logger.dbg(2, "skipped comment <grey>%s</grey>", element.textContent);

            default:
                return logger.dbg(1, "skipped root tag <lblue>%s</lblue>", element.tagName);
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
            auto name = child.getAttribute("name").idup;
            auto author = child.getAttribute("author").idup;
            auto contact = child.getAttribute("contact").idup;
            registry.vendors[name] = VkVendor(name, author, contact);
        }
    }

    /** 
     * Parse type "forward-declarations" grouped under the <types> root tag.
     */
    private void parseTypes(XmlElement element)
        in (element.tagName == "types")
    {
        foreach (child; element.childElements) {
            if (child.tagName != "type") {
                if (child.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                } else {
                    logger.dbg(1, "skipped non-type tag <lblue>%s</lblue>", child.tagName);
                }
                continue;
            }

            const base = parseTypeBase(child);
            registry.types[base.name] = base;

            switch (base.category) {
                case VkTypeCategory.Include:
                    // TODO: parse <type category="include">
                    logger.dbg(1, "skipped include <yellow>%s</yellow>", base.name);
                    break;

                case VkTypeCategory.Define:
                    registry.defines[base.name] = parseDefineType(child, base);
                    break;

                case VkTypeCategory.Basetype:
                    registry.basetypes[base.name] = parseBasetypeType(child, base);
                    break;

                case VkTypeCategory.Bitmask:
                    registry.bitmasks[base.name] = parseBitmaskType(child, base);
                    break;

                case VkTypeCategory.Handle:
                    registry.handles[base.name] = parseHandleType(child, base);
                    break;

                case VkTypeCategory.Enum:
                    registry.enums[base.name] = parseEnumType(child, base);
                    break;

                case VkTypeCategory.FuncPtr:
                    registry.funcptrs[base.name] = parseFuncPtrType(child, base);
                    break;

                case VkTypeCategory.Struct:
                    registry.structs[base.name] = parseStructType(child, base);
                    break;

                case VkTypeCategory.Union:
                    registry.unions[base.name] = parseUnionType(child, base);
                    break;

                default:
                    parseSkippedType(child, base);
                    break;
            }
        }
    }

    /** 
     * Parse attributes common to all <type> tag variants.
     */
    private VkType parseTypeBase(XmlElement element) {
        VkType result;

        if (auto name = element.getAttribute("name")) {
            result.name = name.idup;
        } else if (auto name = element.firstChildByTagName("name")) {
            result.name = name.textContent.idup;
        }

        result.category = element.getAttribute("category").toVkTypeCategory;

        return result;
    }

    /** 
     * Parse <type category="basetype"> tags.
     */
    private VkDefineType parseDefineType(XmlElement element, ref const(VkType) base) {
        VkDefineType result;
        result.base = base;

        if (auto name = element.firstChildByTagName("name")) {
            auto line = element.firstChild.textContent.splitLines.back;
            if (line.startsWith("//")) {
                result.value = line.idup;
            } else {
                if (auto type = element.firstChildByTagName("type")) {
                    const content = type.textContent ~ type.nextSibling.textContent;
                    result.value = parseDefineString(content);
                } else if (auto next = name.nextSibling()) {
                    result.value = next.textContent.strip.idup;
                }
            }
        }

        if (auto api = element.getAttribute("api")) {
            result.api = api.idup.split(",");
        }

        return result;
    }

    /** 
     * Parse <type category="basetype"> tags.
     */
    private VkBasetypeType parseBasetypeType(XmlElement element, ref const(VkType) base) {
        VkBasetypeType result;
        result.base = base;

        if (auto type = element.firstChildByTagName("type")) {
            auto whole = type.textContent ~ type.nextSibling.textContent;
            result.type = parseTypeString(type.textContent, whole);
        }

        return result;
    }

    /** 
     * Parse <type category="bitmask"> tags.
     */
    private VkBitmaskType parseBitmaskType(XmlElement element, ref const(VkType) base) {
        VkBitmaskType result;
        result.base = base;

        if (auto requires = element.getAttribute("requires")) {
            result.requires = requires.idup;
        }

        if (auto type = element.firstChildByTagName("type")) {
            result.backing = type.textContent.idup;
        }

        return result;
    }

    /** 
     * Parse <type category="handle"> tags.
     */
    private VkHandleType parseHandleType(XmlElement element, ref const(VkType) base) {
        VkHandleType result;
        result.base = base;

        if (auto alias_ = element.getAttribute("alias")) {
            result.alias_ = alias_.idup;
        }

        return result;
    }

    /**
     * Parse <type category="enum"> tags.
     */ 
    private VkEnumType parseEnumType(XmlElement element, ref const(VkType) base) {
        VkEnumType result;
        result.base = base;

        if (auto name = element.getAttribute("name")) {
            result.name = name.idup;
        }

        return result;
    }

    /** 
     * Parse <type category="funcpointer"> tags.
     */
    private VkFuncPtrType parseFuncPtrType(XmlElement element, ref const(VkType) base) {
        import std.ascii : isAlphaNum;

        VkFuncPtrType result;
        result.base = base;

        if (auto name = element.firstChildByTagName("name")) {
            result.name = name.textContent.idup;
        }

        auto text = element.textContent;
        text = text.replaceFirst("typedef ", "");
        text = text.replaceFirst(regex(` \(VKAPI_PTR\s*\*\s*\w+\)`), "");
        text = text.replaceFirst("(void)", "()");

        auto paropenIndex = text.indexOf("(");
        assert(paropenIndex != -1, "did not find opening parenthesis");
        result.type = parseTypeString(text[0 .. paropenIndex]);
        text = text[paropenIndex + 1 .. $ - ");".length];

        auto types = element.getChildrenByTagName("type");
        auto lines = text.split(",").map!(t => t.strip);

        foreach (line, type; zip(lines, types)) {
            VkParam param;

            size_t nameLength = 0;
            while (line[$ - nameLength - 1].isAlphaNum) {
                nameLength += 1;
            }
            param.name = line[$ - nameLength .. $].idup;

            auto whole = line[0 .. $ - nameLength].strip;
            param.type = parseTypeString(type.textContent, whole);

            result.params ~= __rvalue(param);
        }

        return result;
    }

    /** 
     * Parse <type category="struct"> tags.
     */
    private VkStructType parseStructType(XmlElement element, ref const(VkType) base) {
        VkStructType result;
        result.base = base;

        if (auto extends_ = element.getAttribute("structextends")) {
            result.extends = extends_.idup;
        }

        foreach (XmlElement child; element.childElements) {
            if (child.tagName != "member" || child.getAttribute("api") == "vulkansc") {
                if (child.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                } else {
                    logger.dbg(1, "skipping non-member tag <lblue>%s</lblue> in struct <yellow>%s</yellow>", child.tagName, result.name);
                }
                continue;
            }

            VkStructMember member;

            if (auto name = child.firstChildByTagName("name")) {
                member.name = name.textContent.idup;

                size_t postNameLength = 0;
                for (XmlNode tag = name; tag; tag = tag.nextSibling) {
                    postNameLength += tag.textContent.length;
                }

                if (auto type = child.firstChildByTagName("type")) {
                    auto whole = child.textContent[0 .. $ - postNameLength];
                    member.type = parseTypeString(type.textContent, whole);

                    if (auto length = child.firstChildByTagName("enum")) {
                        member.type = format!"%s[%s]"(member.type, length.textContent);
                    }
                }
            }

            if (auto comment = child.getAttribute("comment")) {
                member.comment = comment.idup;
            } else if (auto comment = child.firstChildByTagName("comment")) {
                member.comment = comment.textContent.idup;
            }

            if (auto values = child.getAttribute("values")) {
                member.values = values.idup.split(",");
            }

            if (auto optional = child.getAttribute("optional")) {
                member.optional = parse!bool(optional);
            }

            result.members ~= member;
        }

        return result;
    }

    /** 
     * Parse <type category="union"> tags.
     */
    private VkUnionType parseUnionType(XmlElement element, ref const(VkType) base) {
        VkUnionType result;
        result.base = base;

        foreach (XmlElement child; element.childElements) {
            if (child.tagName != "member") {
                if (child.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                } else {
                    logger.dbg(1, "skipping non-member tag <lblue>%s</lblue> in union <yellow>%s</yellow>", child.tagName, result.name);
                }
                continue;
            }

            VkUnionMember member;

            if (auto name = child.firstChildByTagName("name")) {
                member.name = name.textContent.idup;

                if (auto type = child.firstChildByTagName("type")) {
                    member.type = parseTypeString(type.textContent);

                    if (auto next = name.nextSibling) {
                        member.type ~= next.textContent;
                    }
                }
            }

            result.members ~= __rvalue(member);
        }

        return result;
    }

    /** 
     * Parse <type> tags that were skipped by our implementation.
     */
    private void parseSkippedType(XmlElement element, ref const(VkType) base) {
        if (auto category = element.getAttribute("category")) {
            logger.dbg(1, "skipped %s type <yellow>%s</yellow>", category, base.name);
        } else {
            logger.dbg(1, "skipped uncategorized type <yellow>%s</yellow>", base.name);
        }
    }

    /** 
     * Parse <enums> root tags.
     * 
     * Unlike every other type in these documents, enums are not grouped using
     *   any kind of parent tag unique to them and are instead listed directly
     *   as children of the <registry> tag. Why this was done boggles my mind.
     */
    private void parseEnums(XmlElement element) {
        final switch (element.getAttribute("type")) {
            case "enum":
                parseEnumEnums(element);
                break;

            case "bitmask":
                parseBitmaskEnums(element);
                break;

            case "constants":
                parseConstantsEnums(element);
                break;
        }
    }

    /** 
     * Parse <enums type="enum"> root tags.
     */
    private void parseEnumEnums(XmlElement element)
        in (element.tagName == "enums")
    {
        VkEnumType result;

        if (auto name = element.getAttribute("name")) {
            result.name = name.idup;
        }

        if (auto category = element.getAttribute("category")) {
            result.category = toVkTypeCategory(category.idup);
        }

        if (auto comment = element.getAttribute("comment")) {
            result.comment = comment.idup;
        }

        if (auto bitmask = element.getAttribute("bitmask")) {
            result.bitmask = parse!bool(bitmask);
        }

        foreach (child; element.childElements) {
            if (child.tagName != "enum") {
                if (child.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                } else {
                    logger.dbg(1, "skipping non-enum tag <lblue>%s</lblue> in enum <yellow>%s</yellow>", child.tagName, result.name);
                }
                continue;
            }

            VkEnumMember member;

            if (auto cname = child.getAttribute("name")) {
                member.name = cname.idup;
            }

            if (auto comment = child.getAttribute("comment")) {
                member.comment = comment.idup;
            }

            if (auto value = child.getAttribute("value")) {
                member.value = value.idup;
            } else if (auto bitpos_ = child.getAttribute("bitpos")) {
                member.value = (1 << bitpos_.to!ulong).text;
            }

            registry.globals[member.name] = result.name;
            result.members[member.name] = member;
        }

        registry.enums[result.name] = __rvalue(result);
    }

    /**
     * Parse <enums type="bitmask"> root tags. 
     */
    private void parseBitmaskEnums(XmlElement element) {
        VkEnumType result;
        result.bitmask = true;

        if (auto name = element.getAttribute("name")) {
            result.name = name.idup;
        }

        final switch (element.getAttribute("bitwidth")) {
            case "32":
                result.width = VkBitWidth.U32;
                break;

            case "64":
                result.width = VkBitWidth.U64;
                break;

            case "":
                break;
        }

        foreach (child; element.childElements) {
            if (child.tagName != "enum") {
                if (child.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                } else {
                    logger.dbg(1, "skipping non-enum tag <lblue>%s</lblue> in enum <yellow>%s</yellow>", child.tagName, result.name);
                }
                continue;
            }

            VkEnumMember member;

            if (auto cname = child.getAttribute("name")) {
                member.name = cname.idup;
            }

            if (auto alias_ = child.getAttribute("alias")) {
                member.alias_ = alias_.idup;
            }

            if (auto comment = child.getAttribute("comment")) {
                member.comment = comment.idup;
            }

            if (auto value = child.getAttribute("value")) {
                member.value = value.idup;
            } else if (auto bitpos_ = child.getAttribute("bitpos")) {
                member.value = (1 << bitpos_.to!ulong).text;
            }

            registry.globals[member.name] = result.name;
            result.members[member.name] = member;
        }

        registry.enums[result.name] = __rvalue(result);
    }

    /**
     * Parse <enums type="constants"> root tags.
     */
    private void parseConstantsEnums(XmlElement element) {
        VkEnumType result;

        if (auto name = element.getAttribute("name")) {
            result.name = name.idup;
        }

        foreach (child; element.childElements) {
            VkEnumMember member;

            if (auto name = child.getAttribute("name")) {
                member.name = name.idup;
            }

            if (auto value = child.getAttribute("value")) {
                member.value = parseLiteralString(value);
            }

            if (auto type = child.getAttribute("type")) {
                member.type = parseTypeString(type, type);
            }

            registry.globals[member.name] = result.name;
            result.members[member.name] = __rvalue(member);
        }

        registry.enums[result.name] = __rvalue(result);
    }

    /** 
     * Parse <command> information grouped under the <commands> root tag.
     */
    private void parseCommands(XmlElement element)
        in (element.tagName == "commands")
    {
        foreach (child; element.childElements) {
            auto command = parseCommand(child);
            registry.commands[command.name] = command;
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

                size_t postNameLength = 0;
                for (XmlNode tag = name; tag; tag = tag.nextSibling) {
                    postNameLength += tag.textContent.length;
                }

                if (auto type = proto.firstChildByTagName("type")) {
                    auto whole = proto.textContent[0 .. $ - postNameLength];
                    result.type = parseTypeString(type.textContent, whole);
                }
            }
        }

        if (auto comment = element.getAttribute("comment")) {
            result.comment = comment.idup;
        }

        foreach (child; element.childElements) {
            if (child.tagName != "param") {
                if (child.tagName != "proto" && child.tagName != "implicitexternsyncparams") {
                    logger.dbg(1, "skipping non-param tag <lblue>%s</lblue> in command <yellow>%s</yellow>", child.tagName, result.name);
                }
                continue;
            }

            VkParam param;

            if (auto name = child.firstChildByTagName("name")) {
                param.name = name.textContent.idup;

                size_t postNameLength = 0;
                for (XmlNode tag = name; tag; tag = tag.nextSibling) {
                    postNameLength += tag.textContent.length;
                }

                if (auto type = child.firstChildByTagName("type")) {
                    auto whole = child.textContent[0 .. $ - postNameLength];
                    param.type = parseTypeString(type.textContent, whole);
                }
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
        VkFeature result;

        result.name = element.getAttribute("name").idup;

        if (auto api = element.getAttribute("api")) {
            result.api = api.idup.split(",");
        }

        if (auto depends = element.getAttribute("depends")) {
            result.depends = depends.idup;
        }

        foreach (sectiontag; element.childElements) {
            if (sectiontag.tagName != "require") {
                if (sectiontag.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", sectiontag.textContent);
                } else {
                    logger.dbg(1, "skipping non-require tag <lblue>%s</lblue> in feature <yellow>%s</yellow>", sectiontag.tagName, result.name);
                }
                continue;
            }

            VkSection section;

            section.name = sectiontag.getAttribute("comment").idup;

            foreach (child; sectiontag.childElements) {
                switch (child.tagName) {
                    case "enum":
                        parseSectionEnum(section, child);
                        break;

                    case "type":
                        parseSectionType(section, child);
                        break;

                    case "command":
                        parseSectionCommand(section, child);
                        break;

                    case "feature":
                        logger.dbg(2, "feature <yellow>%s</yellow>", child.getAttribute("name"));
                        break;

                    case "comment":
                        logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                        break;

                    default:
                        logger.dbg(1, "skipped tag <lblue>%s</lblue> in feature <yellow>%s</yellow>", child.tagName, result.name);
                        break;
                }
            }

            result.sections ~= section;
        }

        registry.features ~= result;
    }

    /** 
     * Parse <extension> information grouped under the <extensions> root tag.
     */
    private void parseExtensions(XmlElement element)
        in (element.tagName == "extensions")
    {
        foreach (child; element.childElements) {
            auto extension = parseExtension(child);
            registry.extensions[extension.name] = __rvalue(extension);
        }
    }

    /** 
     * Parse an individual <extension> tag and return its value.
     */
    private VkExtension parseExtension(XmlElement element) {
        VkExtension result;

        if (auto name = element.getAttribute("name")) {
            result.name = name.idup;
        }

        if (auto number = element.getAttribute("number")) {
            result.number = number.parse!int;
        }

        if (auto type = element.getAttribute("type")) {
            result.type = type.toVkExtensionType;
        }

        if (auto depends = element.getAttribute("depends")) {
            result.depends = parseDependsString(depends);
        }

        if (auto author = element.getAttribute("author")) {
            result.author = author.idup;
        }

        if (auto supported = element.getAttribute("supported")) {
            result.supported = supported.idup.split(",");
        }

        if (auto promoted = element.getAttribute("promotedto")) {
            result.promoted = promoted.idup;
        }

        foreach (sectiontag; element.childElements) {
            if (sectiontag.tagName != "require") {
                if (sectiontag.tagName == "comment") {
                    logger.dbg(2, "comment <grey>%s</grey>", sectiontag.textContent);
                } else {
                    logger.dbg(1, "skipping non-require tag <lblue>%s</lblue> in extension <yellow>%s</yellow>", sectiontag.tagName, result.name);
                }
                continue;
            }

            VkSection section;

            section.depends = sectiontag.getAttribute("depends").idup;

            foreach (child; sectiontag.childElements) {
                switch (child.tagName) {
                    case "enum":
                        parseSectionEnum(section, child, result.number);
                        break;

                    case "type":
                        parseSectionType(section, child);
                        break;

                    case "command":
                        parseSectionCommand(section, child);
                        break;

                    case "feature":
                        logger.dbg(2, "feature <yellow>%s</yellow>", child.getAttribute("name"));
                        break;

                    case "comment":
                        logger.dbg(2, "comment <grey>%s</grey>", child.textContent);
                        break;

                    default:
                        logger.dbg(1, "skipped tag <lblue>%s</lblue> in extension <yellow>%s</yellow>", child.tagName, result.name);
                        break;
                }
            }

            result.sections ~= section;
        }

        return result;
    }

    /**
     * Parse <enum> tags in sections, which aren't actually enumerants.
     * 
     * <enum name="somename"> is for API constants and nothing else.
     * <enum value="somevalue" ...> is for declaring manifest constants.
     * <enum extends="enumname" ...> is for extending existing enums.
     * <enum alias="somename" ...> is for aliasing some other enum member.
     */
    private void parseSectionEnum(ref VkSection section, XmlElement element, int ext = 0) {
        if (auto name = element.getAttribute("name")) {
            VkEnumMember member;
            member.name = name.idup;

            if (auto extnumber = element.getAttribute("extnumber")) {
                ext = extnumber.parse!int;
            }

            if (auto value = element.getAttribute("value")) {
                member.value = value.idup;
            } else if (auto bitpos = element.getAttribute("bitpos")) {
                member.value = (1 << bitpos.parse!int).to!string;
            } else if (auto offset = element.getAttribute("offset")) {
                if (element.getAttribute("dir") == "-") {
                    member.value = format!"-1%.6d%.3d"(ext - 1, offset.parse!int);
                } else {
                    member.value = format!"1%.6d%.3d"(ext - 1, offset.parse!int);
                }
            } else if (auto alias_ = element.getAttribute("alias")) {
                member.alias_ = alias_.idup;
            }

            if (auto extends = element.getAttribute("extends")) {
                auto ref enum_ = registry.enums[extends];
                enum_.members[member.name] = member;
                registry.globals[member.name] = enum_.name;
            } else {
                if (member.value.empty) {
                    if (member.alias_.empty) {
                        if (auto constant = member.name in registry.constants.members) {
                            section.mconsts ~= *constant;
                        } else {
                            logger.dbg(1, "skipping manifest constant alias <yellow>%s</yellow>", member.name);
                        }
                    } else {
                        section.mconsts ~= member;
                    }
                } else {
                    section.mconsts ~= member;
                }
            }
        }
    }

    private void parseSectionType(ref VkSection section, XmlElement element) {
        section.types ~= element.getAttribute("name").idup;
    }

    private void parseSectionCommand(ref VkSection section, XmlElement element) {
        section.commands ~= element.getAttribute("name").idup;
    }

    /** 
     * Utility for parsing a C literal into D form.
     * 
     * Params:
     *   constant = A literal in string form obtained from an XML document.
     * 
     * Returns: the D equivalent of the given literal.
     */
    private static string parseLiteralString(xmlstring constant) {
        string result = constant.idup;

        if (result.startsWith("(") && result.endsWith(")")) {
            result = result[1 .. $ - 1];
        }

        result = result.replaceFirst("L", "");
        result = result.replace("F", "f");

        return result;
    }

    /** 
     * Utility for parsing a C define string into D form.
     * 
     * Params:
     *   define = A define in string form obtained from an XML document.
     * 
     * Returns: the D equivalent of the given define.
     */
    private static string parseDefineString(xmlstring define) {
        const commentStart = define.indexOf("//");

        if (commentStart != -1) {
            return define[0..commentStart].idup;
        } else {
            return define.idup;
        }
    }

    /** 
     * Utility for parsing a C type string into D form.
     * 
     * Params:
     *   name = A type in string form as obtained from an XML document.
     * 
     * Returns: the D equivalent of the given type.
     */
    private static string parseTypeString(xmlstring name) {
        return parseTypeString(name, name);
    }

    /** 
     * Utility for parsing a C type string into D form.
     * 
     * Params:
     *   name = A type in string form as obtained from an XML document.
     *   whole = The surrounding text of the given type name.
     * 
     * Returns: the D equivalent of the given type.
     */
    private static string parseTypeString(xmlstring name, xmlstring whole) {
        string result = typemap.get(name, name).idup;
        xmlstring pre;
        xmlstring post;

        auto index = whole.indexOf(name);
        assert(index != -1, format!"name not present in whole (name: %s, whole: %s)"(name, whole));

        if (index > 0) {
            pre = whole[0 .. index].strip;
        }

        if (index + name.length < whole.length) {
            post = whole[index + name.length .. $].strip;
        }

        if (pre == "const") {
            result = format!"const(%s)"(result);
        }

        while (!post.empty) {
            if (post.startsWith("const")) {
                result = format!"const(%s)"(result);
                post = post["const".length .. $].strip;
            } else {
                result ~= post[0];
                post = post[1 .. $].strip;
            }
        }

        return result;
    }
}

/** 
 * YXML uses this as a string type for @nogc reasons.
 */
alias xmlstring = const(char)[];

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

/**
 * Type map from their C names to their D names. 
 */
private const xmlstring[xmlstring] typemap = [
    "int8_t":   byte.stringof,
    "uint8_t":  ubyte.stringof,
    "int16_t":  short.stringof,
    "uint16_t": ushort.stringof,
    "int32_t":  int.stringof,
    "uint32_t": uint.stringof,
    "int64_t":  long.stringof,
    "uint64_t": ulong.stringof,
    "float":    float.stringof,
    "double":   double.stringof,
];