import Metal;

class Mesh {
    let vertexBuffer: MTLBuffer;
    let vertexCount: Int;
    
    init?(device: MTLDevice, vertices: [Vertex]) {
        self.vertexCount = vertices.count;
        let size = vertexCount * MemoryLayout<Vertex>.stride;
        
        guard let buffer = device.makeBuffer(bytes: vertices, length: size, options: .storageModeShared) else {
            return nil;
        }
        self.vertexBuffer = buffer;
    }
}
