/**
    Vulkan Struct Chains
    
    Copyright:
        Copyright © 2025, Kitsunebi Games
        Copyright © 2025, Inochi2D Project
    
    License:    $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:
        Luna Nielsen
*/
module nuvk.core.chain;
import vulkan.eh;
import vulkan;
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
    A chain of vulkan structs.
*/
struct VkStructChain {
private:
@nogc:
    void[] data_;
    VkChainedStruct[] chain_;

public:

    // Destructor
    ~this() {
        this.clear();
    }

    /**
        Pointer to the chain.
    */
    @property VkBaseOutStructure* front() => data_.ptr ? cast(VkBaseOutStructure*)data_.ptr : null;

    /**
        Gets the last structure in the chain.
    */
    @property VkBaseOutStructure* back() => data_.ptr ? chain_[$-1].ptr : null;

    /**
        The amount of structs stored in the chain.
    */
    @property uint count() => cast(uint)chain_.length;

    /**
        The chain as a slice.
    */
    @property VkChainedStruct[] chain() => chain_;

    /**
        Tries to find the given structure within the chain.

        Params:
            type = The structure type to look for.
        
        Returns:
            The address of the in structure on success,
            $(D null) otherwise.
    */
    VkChainedStruct* find(VkStructureType type) {
        foreach(ref c; chain_) {
            if (c.ptr && c.ptr.sType == type)
                return &c;
        }
        return null;
    }

    /**
        Adds a struct to the chain.
    */
    void add(T)(T struct_) if (isVkChain!T) {
        this.add(VkChainedStruct(
            size: T.sizeof,
            ptr: cast(VkBaseOutStructure*)&struct_,
        ));
    }

    /**
        Adds a chained struct to this struct.
    */
    void add(VkChainedStruct other) {
        if (!other.ptr)
            return;

        // Replace
        if (auto p = this.find(other.ptr.sType)) {
            nu_memmove(p.ptr, other.ptr, other.size);
            this.readjust();
            return;
        }

        // Add
        size_t offset = data_.length;
        data_ = data_.nu_resize(data_.length+other.size);

        chain_ = chain_.nu_resize(chain_.length+1);
        chain_[$-1].size = other.size;
        chain_[$-1].ptr = cast(VkBaseOutStructure*)(data_.ptr+offset);
        nu_memmove(data_.ptr+offset, other.ptr, other.size);
        this.readjust();
    }

    /**
        Makes a new struct chain that consists of the combined
        elements of this chain and another.

        Params:
            other = The other struct chain to combine with.
        
        Returns:
            A new struct chain containing elements from both.
    */
    VkStructChain combined(ref VkStructChain other) {
        VkStructChain new_ = this.copy();
        new_.readjust();
        foreach(struct_; other.chain) {
            new_.add(struct_);
        }

        return new_;
    }

    /**
        Re-adjusts the chain's members to have correct pNext pointers.

        Returns:
            This object.
    */
    auto ref readjust() {
        ptrdiff_t chainCount = cast(ptrdiff_t)chain_.length-1;
        if (chainCount < 0)
            return this;

        chain_[0].ptr = cast(VkBaseOutStructure*)data_.ptr;
        chain_[0].ptr.pNext = cast(VkBaseOutStructure*)(data_.ptr+chain_[0].size);
        foreach(i; 1..chainCount) {
            void* base = (cast(void*)chain_[i-1].ptr)+chain_[i-1].size;

            chain_[i].ptr = cast(VkBaseOutStructure*)base;
            chain_[i].ptr.pNext = cast(VkBaseOutStructure*)(base+chain_[i].size);
        }

        back.pNext = null;
        return this;
    }

    /**
        Makes a copy of the struct chain.
    */
    VkStructChain copy() {
        return VkStructChain(
            data_.nu_dup(), 
            chain_.nu_dup()
        );
    }

    /**
        Takes ownership of the structure chain's memory,
        this will destroy the offset information related
        to the chain.

        Returns:
            Pointer to the internal struct chain.
    */
    void* take() {

        void* ptr = data_.ptr;
        nu_freea(chain_);
        nogc_zeroinit(data_);
        return ptr;
    }

    /**
        Clears the chain.
    */
    void clear() {
        nu_freea(data_);
        nu_freea(chain_);
    }
}

/**
    A chained structure stored in a VkStructChain
*/
struct VkChainedStruct {
    size_t size;
    VkBaseOutStructure* ptr;
}