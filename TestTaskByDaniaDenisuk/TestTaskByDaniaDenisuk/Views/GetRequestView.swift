
import SwiftUI

enum Tab {
    case user
    case signUp
}

struct GetRequestView: View {
    @Environment(NetworkMonitor.self) private var networkMonitor
    @State private var selectedTab: Tab = .user
    @StateObject private var rootVM: RootViewModel = RootViewModel()
    
    var body: some View {
        if networkMonitor.isConnected {
            VStack {
                Text("Working with Get request")
                    .font(Font.custom("NunitoSans-ExtraLight", size: 20))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Rectangle().fill(.customYellow))
                
                Group {
                    switch selectedTab {
                    case .user:
                        UsersListView(viewModel: rootVM.usersVM)
                    case .signUp:
                        SignUpView(viewModel: rootVM.signUpVM)
                    }
                }
                .frame(maxHeight: .infinity)
                
                TabView(selectedTab: $selectedTab)
            }
            .task {
                do {
                    try await rootVM.primaryNetCall()
                } catch {
                    print("RootVM Network Error: \(error)")
                }
            }
        } else {
            NoConnectionView()
        }
    }
}

#Preview {
    GetRequestView()
        .environment(NetworkMonitor())
}
