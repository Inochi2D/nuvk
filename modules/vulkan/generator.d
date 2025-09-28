/+ dub.sdl:
    name "generator"

    dependency "yxml" version="~>0.1.7"
    dependency "console-colors" version="~>1.3.1"
+/
import std.net.curl;
import std.file : exists, rmdirRecurse, mkdir;
import std.exception : enforce;
import std.array : array;
import std.parallelism;
import std.path;
import consolecolors;
import yxml;
import core.sync.mutex : Mutex;

int main(string[] args) {
    enableConsoleUTF8();
    logMutex = new Mutex();

    if (args.length == 1 || args[1] == "%*" || args[1] == "$@")
        args = [args[0], "vk", "video"];

    foreach(arg; parallel(args[1..$])) {
        try {

            // From full path, in case some extensions are in a seperate repo.
            if (arg.length > 5 && arg[0..5] == "https") {
                VkRegistry spec = (new VkRegistry(arg.baseName, downloadSpec(arg))).parse();
                logDebug(spec.toString());
                continue;
            }

            // Download from official registry.
            string dlFile = arg.withDefaultExtension("xml").array();
            string dlPath = buildPath("https://raw.githubusercontent.com/KhronosGroup/Vulkan-Docs/refs/heads/main/xml/", dlFile);
            VkRegistry spec = (new VkRegistry(arg.baseName, downloadSpec(dlPath))).parse();
            logDebug(spec.toString());
            
        } catch(Exception ex) {
            logError(ex.msg);
        }
    }
    return 0;
}

string downloadSpec(string url) {
    logDebug("Fetching <orange>%s</orange>...", url);
    return cast(string)get(url);
}

//
//          PARSING
//
class VkRegistry {
private:
    string name;
    XmlDocument xml;

    void parsePlatforms(ref XmlElement root) {
        if (root.tagName != "platforms")
            return;
        
        foreach(ref node; root.childNodes) {
            if (auto element = cast(XmlElement)node) {
                platforms ~= VkPlatform(
                    element.getAttribute("name").idup,
                    element.getAttribute("comment").idup
                );
            }
        }
    }

    void parseVendors(ref XmlElement root) {
        if (root.tagName != "tags")
            return;

        foreach(ref node; root.childNodes) {
            if (auto element = cast(XmlElement)node) {
                vendors ~= VkVendor(
                    element.getAttribute("name").idup,
                    element.getAttribute("author").idup,
                    element.getAttribute("contact").idup,
                );
            }
        }
    }

public:

    VkStructType[] structs;

    VkEnumType[] enums;

    /**
        The registered platforms
    */
    VkPlatform[] platforms;

    /**
        The registered vendors.
    */
    VkVendor[] vendors;

    /**
        Constructs a new registry from the given XML Document.
    */
    this(string name, string xml) {
        this.name = name;

        this.xml.parse(xml);
        enforce(!this.xml.isError, this.xml.errorMessage.dup);
    }

    /**
        Parses the registry data.
    */
    VkRegistry parse() {
        foreach(ref node; xml.root.childNodes) {
            if (auto element = cast(XmlElement)node) {
                switch(element.tagName) {
                    case "platforms":
                        // this.parsePlatforms(element);
                        break;

                    case "tags":
                        // this.parseVendors(element);
                        break;
                    
                    case "types":
                        foreach(typeNode; element.childNodes) {
                            if (auto typeElement = cast(XmlElement)typeNode) {
                                auto category = typeElement.getAttribute("category");
                                switch(category) {
                                    case "struct":
                                        auto struct_ = new VkStructType();
                                        struct_.parse(typeElement);
                                        structs ~= struct_;
                                        break;
                                    
                                    default:
                                        logDebug("Skipping type %s...", category);
                                        break;
                                }
                            }
                        }
                        break;

                    case "enums":
                        auto enum_ = new VkEnumType();
                        enum_.parse(element);
                        enums ~= enum_;
                        break;

                    default: break;
                }
            }
        }
        return this;
    }

    override
    string toString() {
        import std.format : format;
        debug {
            string out_ = "%s:\n".format(name);
            foreach(enum_; enums) {
                out_ ~= enum_.toString() ~ "\n";
            }
            foreach(struct_; structs) {
                out_ ~= struct_.toString() ~ "\n";
            }
            return out_;
        } else return super.toString();
    }
}

struct VkPlatform {
    string name;
    string comment;
}

struct VkVendor {
    string ext;
    string author;
    string contact;
}

abstract
class VkType {
    string category;
    string name;

    abstract void parse(ref XmlElement root);
}

class VkEnumType : VkType {
public:
    string comment;
    VkEnumMember[] members;

    struct VkEnumMember {
        string name;
        string value;
        string comment;
    }

    override void parse(ref XmlElement root) {
        import std.conv : to, text;

        if (root.tagName != "enums") {
            logError("Malformed enum type %s!", root.tagName);
            return;
        }
        
        if (auto name_ = root.getAttribute("name"))
            this.name = name_.idup;
        if (auto category_ = root.getAttribute("category"))
            this.category = category_.idup;
        if (auto comment_ = root.getAttribute("comment").escapeCCL())
            this.comment = comment_.idup;

        foreach(node; root.childNodes) {
            if (auto element = cast(XmlElement)node) {
                if (element.tagName != "enum")
                    continue;

                VkEnumMember member;
                if (auto name_ = element.getAttribute("name"))
                    member.name = name.idup;
                if (auto comment_ = element.getAttribute("comment").escapeCCL())
                    member.comment = comment_.idup;
                if (auto value_ = element.getAttribute("value"))
                    member.value = value_.idup;

                if (auto bitpos_ = element.getAttribute("bitpos")) {
                    member.value = (1 << bitpos_.to!ulong).text;
                    members ~= member;
                    continue;
                }

                this.members ~= member;
            }
        }
    }

    override
    string toString() {
        import std.format : format;
        debug {

            string out_ = "    %s:\n".format(name);
            foreach(member; members) {
                out_ ~= "      %s = %s (%s)\n".format(member.name, member.value, member.comment);
            }
            return out_;
        } else return super.toString();
    }
}

class VkStructType : VkType {
    string extends;
    VkStructMember[] members;

    struct VkStructMember {
        string type;
        string name;
        string values;
        string comment;
    }

    override void parse(ref XmlElement root) {
        import std.conv : to, text;

        this.name = root.getAttribute("name").idup;
        this.category = root.getAttribute("category").idup;
        if (root.tagName != "type" && category != "struct") {
            logError("Malformed struct type %s!", root.tagName);
            return;
        }

        if (auto extends_ = root.getAttribute("structextends"))
            extends = extends_.idup;

        foreach(node; root.childNodes) {
            if (auto element = cast(XmlElement)node) {
                if (element.tagName != "member")
                    continue;
                
                VkStructMember member;
                if (auto name_ = element.firstChildByTagName("name"))
                    member.name = name_.textContent.idup;
                
                if (auto type_ = element.textContent)
                    member.type = parseVkType(cast(string)type_[0..$-member.name.length]);

                if (auto comment_ = element.getAttribute("comment"))
                    member.comment = comment_.idup;

                if (auto values_ = element.getAttribute("values"))
                    member.values = values_.idup;

                members ~= member;
            }
        }
    }

    override
    string toString() {
        import std.format : format;
        debug {

            string out_ = "    %s:\n".format(name);
            foreach(member; members) {
                if (member.values)
                    out_ ~= "      %s %s = %s\n".format(member.type, member.name, member.values);
                else
                    out_ ~= "      %s %s\n".format(member.type, member.name);
            }
            return out_;
        } else return super.toString();
    }
}

class VkHandleType : VkType {

}

//
//          UTILS
//
string parseVkType(string type) {
    import std.algorithm.searching : startsWith;
    import std.ascii : isAlphaNum, isWhite;

    string out_;
    size_t i = 0;
    while(i < type.length) {
        string slice = type[i..$];

        if (slice.startsWith("const")) {
            i += 6;

            out_ ~= "const(";
            size_t si = i;
            while(isAlphaNum(type[i]) || type[i] == '_') {
                if (i > type.length)
                    break;
                
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


//
//          LOGGING
//
private __gshared Mutex logMutex;

void logDebug(Args...)(string fmt, Args args) {
    debug {
    logMutex.lock();
    cwritefln("(<lgrey>Debug</lgrey>) " ~ fmt, args);
    logMutex.unlock();
    }
}

void logInfo(Args...)(string fmt, Args args) {
    logMutex.lock();
    cwritefln("(<lgrey>Info</lgrey>) " ~ fmt, args);
    logMutex.unlock();
}

void logError(Args...)(string fmt, Args args) {
    logMutex.lock();
    cwritefln("(<red>Error</red>) " ~ fmt, args);
    logMutex.unlock();
}