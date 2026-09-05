import SwiftUI;
import MetalKit;

class FocusableMTKView: MTKView {
    var camera: Camera?
    
    override var acceptsFirstResponder: Bool { true; }
    
    override func keyDown(with event: NSEvent) {
        camera?.handleKeyDown(keyCode: event.keyCode);
    }
    
    override func keyUp(with event: NSEvent) {
        camera?.handleKeyUp(keyCode: event.keyCode);
    }
}

struct MetalView: NSViewRepresentable {
    func makeNSView(context: Context) -> FocusableMTKView {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported!");
        }
        
        let view = FocusableMTKView(frame: .zero, device: defaultDevice);
        view.clearColor = MTLClearColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0);
        view.colorPixelFormat = .bgra8Unorm;
        
        view.delegate = context.coordinator.renderer;
        view.camera = context.coordinator.renderer?.camera;
        
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view);
        }
        
        return view;
    }
    
    func updateNSView(_ nsView: FocusableMTKView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self);
    }
    
    class Coordinator: NSObject {
        var renderer: Renderer?;
        
        init(_ parent: MetalView) {
            if let defaultDevice = MTLCreateSystemDefaultDevice() {
                let tempView = MTKView(frame: .zero, device: defaultDevice);
                self.renderer = Renderer(metalKitView: tempView);
            }
        }
    }
}
