import simd;

struct Uniforms {
    var modelMatrix: matrix_float4x4;
    var viewMatrix: matrix_float4x4;
    var projectionMatrix: matrix_float4x4;
}

struct Vertex {
    var position: SIMD3<Float>;
    var color: SIMD4<Float>;
}

// MARK: - tranformation matrix extension
extension matrix_float4x4 {
    // Identity matrix
    static var identity: matrix_float4x4 {
        return matrix_identity_float4x4;
    }
    
    // Translation matrix
    static func translation(_ position: SIMD3<Float>) -> matrix_float4x4 {
        var matrix = matrix_identity_float4x4;
        matrix.columns.3 = SIMD4<Float>(position.x, position.y, position.z, 1.0);
        return matrix;
    }
    
    // Rotation matrix in Y
    static func rotationY(_ angle: Float) -> matrix_float4x4 {
        var matrix = matrix_identity_float4x4;
        let cosA = cos(angle);
        let sinA = sin(angle);
        matrix.columns.0 = SIMD4<Float>(cosA, 0, -sinA, 0);
        matrix.columns.2 = SIMD4<Float>(sinA, 0, cosA, 0);
        return matrix;
    }
    
    // Perspective matrix
    static func perspective(fov: Float, aspect: Float, near: Float, far: Float) -> matrix_float4x4 {
        let y = 1 / tan(fov / 2);
        let x = y / aspect;
        let z = far / (far - near);
        
        var matrix = matrix_float4x4();
        matrix.columns.0 = SIMD4<Float>(x, 0, 0, 0);
        matrix.columns.1 = SIMD4<Float>(0, y, 0, 0);
        matrix.columns.2 = SIMD4<Float>(0, 0, -z, -1);
        matrix.columns.3 = SIMD4<Float>(0, 0, -z * near, 0);
        
        return matrix;
    }
}
