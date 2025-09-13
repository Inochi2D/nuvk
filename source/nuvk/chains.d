/**
    Vulkan struct chaining helpers
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.chains;
import vulkan.core;
import numem;
import nulib;

/**
    Gets whether the given type is a chainable vulkan struct.
*/
enum isVkChain(T) = 
    is(T == struct) &&
    is(typeof(T.tupleof[0]) : VkStructureType) && 
    is(typeof(T.tupleof[1]) : const(void)*);


/**
    A class which helps building feature chains.
*/
final
class ChainBuilder : NuObject {
private:
@nogc:
    void[] data_;
    vector!ChainInfo elements;
    
    static
    struct ChainInfo {
        VkStructureType sType;
        size_t offset;
        size_t size;
    }

    static
    struct VkStruct {
        VkStructureType sType;
        const(void)* pNext;
    }
    
    // Allocates space for the given struct.
    T* allocate(T)() {
        this.elements ~= ChainInfo(T.init.sType, data_.length, T.sizeof);
        this.data_ = data_.nu_resize(data_.length+elements[$-1].size);
        return cast(T*)(data_.ptr+elements[$-1].offset);
    }

    // Finds the requested struct.
    T* find(T)() {
        foreach(i; 0..elements.length)
            if (elements[i].sType == T.init.sType)
                return cast(T*)(data_.ptr + elements[i].offset);

        return this.allocate!T;
    }

    // Finalizes all of the chain by pointing the pNext to the next
    // struct.
    void finalize() {
        if (elements.length < 2)
            return;

        import std.stdio : printf;

        foreach(i; 0..cast(ptrdiff_t)elements.length-1) {
            VkStruct* ptr = cast(VkStruct*)(data_.ptr+elements[i].offset);
            ptr.pNext = data_.ptr+elements[i].size;
        }
    }

public:

    /**
        Creates a new chain builder.

        Returns:
            A new $(D ChainBuilder) instance.
    */
    static ChainBuilder create() {
        return nogc_new!ChainBuilder();
    }

    /**
        Whether the chain is empty.
    */
    @property bool empty() => data_.length == 0;

    // Destructor
    ~this() {
        elements.clear();
        nu_freea(data_);
    }

    /**
        Adds a feature struct in the chain,
        if the given struct is already present, sets
        the current instance instead.
    
        Params:
            struct_ = The structure to set in the chain.
        
        Returns:
            The $(D FeaturesChain) instance that the function
            was called on.
    */
    ChainBuilder add(T)(T struct_) if (isVkChain!T) {
        T* toSet = this.find!T;
        *toSet = struct_; 
        return this;
    }

    /**
        Gets whether the given struct is present in the chain.

        Returns:
            $(D true) if the given struct is in the chain,
            $(D false) otherwise.
    */
    bool has(T)() if (isVkChain!T) {
        foreach(i; 0..elements.length)
            if (elements[i].sType == T.init.sType)
                return true;
        
        return false;
    }

    /**
        Gets whether the given struct type id is present 
        in the chain.

        Params:
            type = The structure type ID to query.

        Returns:
            $(D true) if the given struct is in the chain,
            $(D false) otherwise.
    */
    bool has(VkStructureType type) {
        foreach(i; 0..elements.length)
            if (elements[i].sType == type)
                return true;
        
        return false;
    }

    /**
        Finalizes the feature chain and gets the result.

        This result has to be cast to the needed type by yourself.

        Returns:
            A pointer to the first vulkan struct in the chain,
            $(D null) if the chain is empty.
    */
    void* get() {
        this.finalize();
        return data_.length > 0 ? data_.ptr : null;
    }

    /**
        Frees this chain.
    */
    void free() {
        auto self = this;
        nogc_delete(self);
    }
}