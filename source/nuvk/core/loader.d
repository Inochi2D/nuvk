/**
    Nuvk Vulkan Loader
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.core.loader;
import numem.core.traits;
import vulkan.core;

/**
    Attribute applied to functions in the nuvk bindings to tell nuvk
    how to load them.
*/
struct VkProcName { string procName; }

/**
    Loads all procedures that are referenced within a struct.

    Params:
        device = The device to load the procedures for
        target = The target struct to store the procedures within.
*/
void loadProcs(T)(VkDevice device, ref T target) if (is(T == struct)) {
    static foreach(member; __traits(allMembers, T)) {
        static if (hasUDA!(__traits(getMember, T, member), VkProcName)) {
            __traits(getMember, target, member) = 
                device.getProcAddr!(typeof(__traits(getMember, T, member)))(getUDAs!(__traits(getMember, T, member), VkProcName)[0].procName);
        }
    }
}

/**
    Loads all procedures that are referenced within a struct.

    Params:
        instance =  The instance to load the procedures for
        target =    The target struct to store the procedures within.
*/
void loadProcs(T)(VkInstance instance, ref T target) if (is(T == struct)) {
    static foreach(member; __traits(allMembers, T)) {
        static if (hasUDA!(__traits(getMember, T, member), VkProcName)) {
            __traits(getMember, target, member) = 
                instance.getProcAddr!(typeof(__traits(getMember, T, member)))(getUDAs!(__traits(getMember, T, member), VkProcName)[0].procName);
        }
    }
}

/**
    Gets the procedure address for the given procedure name
    from the given instance.

    Params:
        instance =  The instance to get the procedure for.
        procName =  The name of the procedure to get.
    
    Returns:
        A function reference to the procedure,
        or $(D null) on failure.
*/
T getProcAddress(T)(VkInstance instance, string procName) @nogc if (is(T == function)) {
    return cast(T)vkGetInstanceProcAddr(instance, procName.ptr);
}

/**
    Gets the procedure address for the given procedure name
    from the given device.

    Params:
        device =    The device to get the procedure for.
        procName =  The name of the procedure to get.
    
    Returns:
        A function reference to the procedure,
        or $(D null) on failure.
*/
T getProcAddress(T)(VkDevice device, string procName) @nogc if (is(T == function)) {
    return cast(T)vkGetDeviceProcAddr(device, procName.ptr);
}