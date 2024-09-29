
import SwiftUI

struct LaunchSreen: View {
    var body: some View {
        ZStack {
            Color
                .customYellow
                .ignoresSafeArea()
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 106.46)
        }
    }
}
