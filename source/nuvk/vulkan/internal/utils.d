/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.internal.vulkan.internal.utils;
import nuvk.context;
static if (NuvkHasVulkan):


import nuvk.core.logging;
import nuvk.internal.vulkan;

import core.stdc.stdio;
import numem.all;
import std.traits : hasMember;


enum hasMemberEx(T, Y, string name, size_t offset) =
    hasMember!(T, name) && 
    is(typeof(__traits(getMember, T, name)) : Y) && 
    __traits(getMember, T, name).offsetof == offset;

enum isVkStruct(T) =
    hasMemberEx!(T, VkStructureType, "sType", 0) &&
    hasMemberEx!(T, const(void)*, "pNext", VkBaseInStructure.pNext.offsetof);

/**
    A helper which simplifies making vulkan structure chains.
*/
class NuvkVkStructChain {
@nogc:
private:
    vector!(VkBaseInStructure*) structList_;

public:

    /**
        Destructor
    */
    ~this() {
        nogc_delete(structList_);
    }

    /**
        Constructor
    */
    this() { }

    /**
        Adds a structure to the list
    */
    void add(T)(T struct_) if (isVkStruct!T) {
        
        // Since we're making a copy we need to make sure we
        // don't end up referring to stale memory.
        struct_.pNext = null;
        structList_ ~= cast(VkBaseInStructure*)nogc_new!T(struct_);

        if (structList_.size() > 1) {
            structList_[$-2].pNext = structList_[$-1];
        }
    }

    /**
        Gets the first structure in the list.
    */
    final
    VkBaseInStructure* getFirst() {
        return structList_.size() > 0 ? structList_[0] : null;
    }

    /**
        Gets the amount of structs in the chain.
    */
    final
    size_t size() {
        return structList_.size();
    }
}

/**
    A list of requests
*/
class NuvkVkRequestList {
@nogc:
private:
    vector!nstring supportedRequests;
    vector!nstring required;
    vector!nstring requestedStore;
    vector!(const(char)*) requestedOut;

    nstring name;

public:
    ~this() {
        nogc_delete(supportedRequests);
        nogc_delete(requestedStore);
        nogc_delete(requestedOut);
        nogc_delete(name);
    }

    this(ref vector!nstring supported, string name) {
        this.supportedRequests = vector!nstring(supported[]);
        this.name = name;
    }

    /**
        Sets which elements are required
    */
    void addRequired(T)(auto ref inout(T[]) requiredReq) if (isSomeString!T) {
        foreach(req; requiredReq) {
            this.required ~= nstring(req);
        }
    }

    /**
        Gets whether string is in the supported list
    */
    bool isSupported(string slice) {
        foreach(ref request; supportedRequests) {
            if (request[] == slice)
                return true;
        }
        return false;
    }

    /**
        Gets whether string is in the supported list
    */
    bool isSupported(const(char)* slice) {
        return isSupported(cast(string)fromStringz(slice));
    }

    /**
        Adds an item
    */
    bool add(string toAdd) {
        if (isSupported(toAdd)) {

            uint i = cast(uint)requestedStore.size();

            // Don't allow duplicates
            foreach(existing; requestedStore) {
                if (existing[] == toAdd)
                    return false;
            }

            requestedStore ~= nstring(toAdd);
            requestedOut ~= requestedStore[$-1].toCString();

            nuvkLogDebug("{0}[{1}] = {2}", name.toCString(), cast(uint)i, requestedStore[$-1].toCString());
            return true;
        }
        return false;
    }

    /**
        Gets whether required elements are there.
    */
    bool hasRequired() {
        weak_set!nstring tmp;
        foreach(req; required) {
            tmp.insert(req);
        }
        
        foreach(request; requestedStore) {
            if (request in tmp) {
                tmp.remove(request);
            }
        }

        return tmp.empty();
    }

    /**
        Gets the list of requests for use.
    */
    const(char)*[] getRequests() {
        return requestedOut[];
    }
}

/**
    Gets all of the extensions available
*/
vector!VkExtensionProperties nuvkVkDeviceGetAllExtensions(VkPhysicalDevice physicalDevice) @nogc {
    vector!VkExtensionProperties extensionProps;
    
    uint extensionCount;
    vkEnumerateDeviceExtensionProperties(physicalDevice, null, &extensionCount, null);

    extensionProps = vector!VkExtensionProperties(extensionCount);
    vkEnumerateDeviceExtensionProperties(physicalDevice, null, &extensionCount, extensionProps.data());
    return extensionProps;
}


/**
    Gets all of the extensions available
*/
vector!VkExtensionProperties nuvkVkContextGetAllExtensions() @nogc {
    vector!VkExtensionProperties extensionProps;
    
    uint extensionCount;
    vkEnumerateInstanceExtensionProperties(null, &extensionCount, null);

    extensionProps = vector!VkExtensionProperties(extensionCount);
    vkEnumerateInstanceExtensionProperties(null, &extensionCount, extensionProps.data());
    return extensionProps;
}

/**
    Gets all of the validation layers available
*/
vector!VkLayerProperties nuvkVkContextGetAllLayers() @nogc {
    vector!VkLayerProperties layerProps;
    
    uint layerCount;
    vkEnumerateInstanceLayerProperties(&layerCount, null);

    layerProps = vector!VkLayerProperties(layerCount);
    vkEnumerateInstanceLayerProperties(&layerCount, layerProps.data());
    return layerProps;
}