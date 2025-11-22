// GameView.swift

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            HStack {
                CompactResourceView() // Replacing ResourceTileView
                    .frame(width: 60, height: 60)
                Spacer()
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 + 4) // Adjusted padding
            .padding(.horizontal)

            // Buttons
            HStack {
                Button(action: { /* Action */ }) {
                    Text("Button 1")
                        .frame(width: 40, height: 40)
                }
                Button(action: { /* Action */ }) {
                    Text("Button 2")
                        .frame(width: 40, height: 40)
                }
            }
            .padding()  // Proper spacing between buttons

            // Other game elements here
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.top) // Ensure top is visually appealing
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}