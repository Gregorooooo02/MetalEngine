import MetalKit;

class Pipeline {
    let renderPipelineState: MTLRenderPipelineState;
    
    init(device: MTLDevice) throws {
        // 1. Loading default shader library
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Cannot find metal shader file!");
        }
        
        let vertexFunction = library.makeFunction(name: "vertex_main");
        let fragmentFunction = library.makeFunction(name: "fragment_main");
        
        // 2. Configuration description
        let pipelineDescriptor = MTLRenderPipelineDescriptor();
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm;
        
        self.renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor);
    }
}

