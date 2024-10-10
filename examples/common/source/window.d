module window;
import bindbc.sdl;
import numem.all;
import inmath;
import nuvk;
import sdl.video;
import sdl.vulkan;

/**
    A window
*/
class Window {
@nogc:
private:
    // Nuvk
    NuvkContext context;
    NuvkDevice device;
    NuvkSurface surface;

    // Window info
    nstring title;
    uint width, height;
    SDL_Window* window;

    // Window state
    bool closeRequested;

    void createWindow(nstring title, uint width, uint height) {
        window = SDL_CreateWindow(title.toCString(), SDL_WINDOWPOS_CENTRED, SDL_WINDOWPOS_CENTRED, width, height, SDL_WINDOW_VULKAN | SDL_WINDOW_RESIZABLE );
    }

    void createNuvk(NuvkPresentMode presentationMode) {
        
        // Create context
        {
            NuvkContextDescriptor descriptor;
            descriptor.type = NuvkContextType.vulkan;

            uint extensionCount;
            SDL_Vulkan_GetInstanceExtensions(window, &extensionCount, null);
            descriptor.vulkan.requiredExtensions = weak_vector!(const(char)*)(extensionCount);
            SDL_Vulkan_GetInstanceExtensions(window, &extensionCount, descriptor.vulkan.requiredExtensions.data());

            context = nuvkCreateContext(descriptor);
        }

        // Create device
        {
            auto selectedDevice = context.getDefaultDevice();
            device = context.createDevice(selectedDevice);
        }

        // Create surface
        {
            void* surfaceAddr;
            nuvkEnforce(
                SDL_Vulkan_CreateSurface(window, context.getHandle(), &surfaceAddr) == SDL_TRUE,
                "Failed to create Vulkan surface"
            );
            surface = device.createSurfaceFromHandle(surfaceAddr, presentationMode, NuvkTextureFormat.bgra8UnormSRGB);
            surface.resize(this.getFramebufferSize());
        }
    }

public:
    this(nstring title, uint width, uint height, NuvkPresentMode presentationMode) {
        this.title = title;
        this.width = width;
        this.height = height;
        this.createWindow(title, width, height);
        this.createNuvk(presentationMode);
        this.closeRequested = false;
    }

    bool isCloseRequested() {
        return closeRequested;
    }

    void updateEvents() {
        SDL_Event event;
        SDL_PumpEvents();

        while(SDL_PollEvent(&event)) {
            switch(event.type) {

                case SDL_QUIT:
                    closeRequested = true;
                    break;

                case SDL_WINDOWEVENT:
                    switch(event.window.event) {
                        default:
                            break;
                        case SDL_WINDOWEVENT_RESIZED:
                        case SDL_WINDOWEVENT_RESTORED:
                            surface.resize(this.getFramebufferSize());
                            break;
                    }
                    break;

                default:
                    break;
            }
        }
    }

    /**
        Gets the device being rendered with.
    */
    ref NuvkDevice getDevice() {
        return device;
    }

    /**
        Gets the surface
    */
    ref NuvkSurface getSurface() {
        return surface;
    }

    /**
        Gets the size of the framebuffer
    */
    vec2u getFramebufferSize() {
        int w, h;
        SDL_Vulkan_GetDrawableSize(window, &w, &h);
        return vec2u(w, h);
    }
}