module nuvk.shader.mapper;
import spirv;
import nuvk.shader;

/**
    A system which generates new mapping points for
    each descriptor binding point.
*/
class NuvkDescriptorMapper {
@nogc:
private:
    // The current binding index
    SpirvID currentBinding = 0;

    SpirvID next() {
        return currentBinding++;
    }


public:

    /**
        Resets the mapper
    */
    void reset() {
        currentBinding = 0;
    }

    void remap(NuvkShader shader) {
        auto module_ = shader.getModule();
        foreach(ref SpirvVariable variable; module_.getVariables()) {
            switch(variable.getVarKind()) {
                
                case SpirvVarKind.uniformBuffer:
                case SpirvVarKind.image:
                case SpirvVarKind.sampler:
                case SpirvVarKind.sampledImage:
                case SpirvVarKind.storageBuffer:
                    if (auto set = module_.getDecorationFor(variable.getId(), Decoration.DescriptorSet)) {
                        module_.setDecorationArgFor(variable.getId(), Decoration.DescriptorSet, 0);
                    }
                    module_.setDecorationArgFor(variable.getId(), Decoration.Binding, this.next());
                    break;

                default:
                    break;
            }
        }
    }

}