
import SwiftUI

struct UsersListView: View {
    @ObservedObject var viewModel: UsersViewModel
    
    var body: some View {
        Group {
            if viewModel.users.isEmpty {
                VStack(spacing: 30) {
                    Image(.peopleGroup)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 201, height: 200)
                    
                    Text("There are no users yet")
                        .font(Font.custom("NunitoSans-ExtraLight", size: 20))
                }
            } else {
                VStack(spacing: 0) {
                    List(viewModel.users, id: \.id) { user in
                        ListRow(userModel: user)
                            .listRowSeparator(.hidden)
                            .onAppear {
                                if viewModel.users.isLast(user) {
                                    Task {
                                        do {
                                            try await viewModel.loadMoreUsers()
                                        } catch {
                                            print("Error loading more users: \(error)")
                                        }
                                    }
                                }
                            }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .refreshable {
                        Task {
                            do {
                                try await viewModel.fetchUsers()
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
}

fileprivate struct ListRow: View {
    let userModel: User
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            AsyncImage(url: URL(string: userModel.photo)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .padding(10)
                    .frame(width: 50, height: 50)
                    .background(.customYellow.opacity(0.7))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(userModel.name)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 20))
                
                Text(userModel.position)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 17))
                    .opacity(0.6)
                
                Text(userModel.email)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 15))
                    .lineLimit(1)
                
                Text(userModel.phone)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 15))
            }
        }
    }
}

#Preview {
    UsersListView(viewModel: UsersViewModel(networkManager: NetworkManager()))
}
