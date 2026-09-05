import MetalKit;

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice;
    let commandQueue: MTLCommandQueue;
    let pipeline: Pipeline;
    let triangleMesh: Mesh;
    
    let camera = Camera();
    var objectRotation: Float = 0.0;
    var aspect: Float = 1.0;
    
    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!;
        guard let queue = device.makeCommandQueue() else { return nil; }
        self.commandQueue = queue;
        
        do {
            self.pipeline = try Pipeline(device: device);
        } catch {
            print("Pipeline compilation error: \(error)");
            return nil;
        }
        
        let vertices = [
            Vertex(position: [0.0, 0.5, 0.0], color: [1, 0, 0, 1]),
            Vertex(position: [-0.5, -0.5, 0.0], color: [0, 1, 0, 1]),
            Vertex(position: [0.5, -0.5, 0.0], color: [0, 0, 1, 1])
        ];
        guard let mesh = Mesh(device: device, vertices: vertices) else { return nil; }
        self.triangleMesh = mesh;
        
        super.init();
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        if size.height > 0 {
            aspect = Float(size.width / size.height);
        }
    }
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return };
        
        // 1. Logic and camera update
        camera.update();
        objectRotation += 0.01;
        
        // 2. Matrices
        var uniforms = Uniforms(
            modelMatrix: matrix_float4x4.rotationY(objectRotation),
            viewMatrix: camera.viewMatrix,
            projectionMatrix: matrix_float4x4.perspective(
                fov: Float(70.0 * .pi / 180.0),
                aspect: aspect,
                near: 0.1,
                far: 1000.0
            )
        );
        
        // 3. GPU configuration
        renderEncoder.setRenderPipelineState(pipeline.renderPipelineState);
        
        // Buffer 0: Vertices
        renderEncoder.setVertexBuffer(triangleMesh.vertexBuffer, offset: 0, index: 0);
        // Buffer 1: Matrices (uniforms)
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1);
        
        // Drawing
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: triangleMesh.vertexCount);
        
        renderEncoder.endEncoding();
        commandBuffer.present(drawable);
        commandBuffer.commit();
    }
}
