import simd;
import AppKit;

class Camera {
    var position: SIMD3<Float> = [0, 0, -3]; // Default camera position;
    var moveSpeed: Float = 0.05;
    
    // Key event
    private var keysPressed: Set<UInt16> = [];
    
    func handleKeyDown(keyCode: UInt16) {
        keysPressed.insert(keyCode);
    }
    
    func handleKeyUp(keyCode: UInt16) {
        keysPressed.remove(keyCode);
    }
    
    // Update camera position in every frame
    func update() {
        let keyW: UInt16 = 13;
        let keyS: UInt16 = 1;
        let keyA: UInt16 = 0;
        let keyD: UInt16 = 2;
        let keyQ: UInt16 = 12;
        let keyE: UInt16 = 14;
        
        if keysPressed.contains(keyW) { position.z += moveSpeed; } // Forward
        if keysPressed.contains(keyS) { position.z -= moveSpeed; } // Back
        if keysPressed.contains(keyA) { position.x += moveSpeed; } // Left
        if keysPressed.contains(keyD) { position.x -= moveSpeed; } // Right
        if keysPressed.contains(keyQ) { position.y -= moveSpeed; } // Up
        if keysPressed.contains(keyE) { position.y += moveSpeed; } // Down
    }
    
    var viewMatrix: matrix_float4x4 {
        return matrix_float4x4.translation(position);
    }
}
