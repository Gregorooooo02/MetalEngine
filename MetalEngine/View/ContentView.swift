import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            MetalView()
                .edgesIgnoringSafeArea(.all);
            
            VStack {
                HStack {
                    Text("Metal Engine")
                        .font(.headline)
                        .padding(0)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    Spacer()
                }
                .padding()
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
