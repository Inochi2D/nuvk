module nuvk.core;

public import nuvk.core.context;
public import nuvk.core.buffer;
public import nuvk.core.device;
public import nuvk.core.shader;
public import nuvk.core.texture;
public import nuvk.core.buffer;
public import nuvk.core.pipeline;
public import nuvk.core.sync;
public import nuvk.core.queue;
public import nuvk.core.cmdbuffer;

/**
    Base type of Nuvk objects.
*/
abstract
class NuvkObject {
@nogc:
private:
    void* handle;

protected:

    /**
        Sets the internal handle
    */
    final
    void setHandle(void* handle) {
        this.handle = handle;
    }

public:

    /**
        Gets the internal handle

        This handle is owned by the object and should NOT be freed
        by the caller.
    */
    final
    ref void* getHandle() {
        return handle;
    }
}