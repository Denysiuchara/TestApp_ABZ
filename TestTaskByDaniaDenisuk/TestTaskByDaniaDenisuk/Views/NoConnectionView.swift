
import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(.noneConnection)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("There is no internet connection")
                .font(Font.custom("NunitoSans-ExtraLight", size: 20))
            
            Button {
                
            } label: {
                Text("Try again")
                    .font(Font.custom("NunitoSans-ExtraLight", size: 20))
                    .foregroundStyle(.black)
            }
            .padding()
            .frame(width: 140, height: 48)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.customYellow)
            }
        }
    }
}
