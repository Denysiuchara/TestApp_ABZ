
import SwiftUI
import PhotosUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @Namespace private var namespace
    @State private var isZoomed = false
    @State private var isPresented = false
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    
    private var screenSize = UIScreen.main.bounds.size
    private var geometryID: String = "Full_Screen_Preview"
    
    private var frameWidth: Double { isZoomed ? (screenSize.width * 0.98) : 40 }
    private var noneNilPostUserResponse: Bool { viewModel.postUserResponse != nil }
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 35) {
                
                // MARK: - Text fields
                CustomTextField(
                    text: $viewModel.name,
                    placeholder: "Your Name"
                )
                .padding(.top, 30)
                
                CustomTextField(
                    text: $viewModel.email,
                    placeholder: "Email",
                    prompt: viewModel.emailPrompt
                )
                .keyboardType(.emailAddress)
                
                CustomTextField(
                    text: $viewModel.phone,
                    placeholder: "Phone",
                    inputExample: "+38 (XXX) XXX - XX - XX",
                    prompt: viewModel.phonePrompt
                )
                .onChange(of: viewModel.phone) { _ in
                    DispatchQueue.main.async {
                        if !viewModel.phone.hasPrefix("+38") {
                            viewModel.phone = "+38" + viewModel.phone
                        }
                        viewModel.phone = viewModel
                            .phone
                            .formattedMask(
                                text: viewModel.phone,
                                mask: "+XX(XXX)XXX-XX-XX"
                            )
                    }
                }
                .keyboardType(.decimalPad)
                
                Text("Select your position")
                    .font(Font.custom("NunitoSans-ExtraLight", size: 22))
                
                //MARK: - Position List
                ForEach(viewModel.positions, id: \.id) { element in
                    HStack(spacing: 25) {
                        Button {
                            viewModel.selectedPosition = element
                        } label: {
                            Circle()
                                .fill(.clear)
                                .frame(width: 15, height: 15)
                                .if(viewModel.selectedPosition == element) { ifCase in
                                    ifCase
                                        .overlay {
                                            Circle()
                                                .stroke(.customBlue, lineWidth: 5)
                                        }
                                } elseScope: { elseCase in
                                    elseCase
                                        .overlay {
                                            Circle()
                                                .stroke(.black.opacity(0.4), lineWidth: 1)
                                        }
                                }
                        }
                        
                        Text(element.name)
                            .font(Font.custom("NunitoSans-ExtraLight", size: 17))
                    }
                    .padding(.horizontal, 10)
                }
                
                HStack {
                    if let selectedImage = viewModel.selectedImage {
                        HStack {
                            Text("Image:")
                                .font(Font.custom("NunitoSans-ExtraLight", size: 18))
                            
                            if !isZoomed {
                                Image(systemName: "photo.artframe")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.customBlue)
                                    .matchedGeometryEffect(id: geometryID, in: namespace)
                                    .onTapGesture {
                                        withAnimation {
                                            isZoomed.toggle()
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("Upload your photo")
                            .foregroundStyle(.black.opacity(0.4))
                            .font(Font.custom("NunitoSans-ExtraLight", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Text("Upload")
                            .font(Font.custom("NunitoSans-ExtraLight", size: 18))
                            .foregroundStyle(.customBlue)
                    }
                }
                .padding(20)
                .frame(height: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.black.opacity(0.6), lineWidth: 1)
                }
                
                // MARK: - Sign up button
                Button {
                    Task {
                        do {
                            try await viewModel.postUser()
                            isPresented.toggle()
                        } catch {
                            print("SignUp Network Error: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Sign up")
                        .font(Font.custom("NunitoSans-Light", size: 20))
                        .foregroundStyle(.black.opacity(viewModel.canSubmit ? 1.0 : 0.6))
                }
                .disabled(!viewModel.canSubmit)
                .frame(width: 140, height: 48)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(viewModel.canSubmit ? .customYellow : .dirtyWhite)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .overlay {
                if isZoomed, let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(5)
                        .matchedGeometryEffect(id: geometryID, in: namespace)
                        .onTapGesture {
                            withAnimation {
                                isZoomed.toggle()
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresented) {
                if let postUserResponse = viewModel.postUserResponse {
                    StatusRegistrationView(postUserResponse: postUserResponse) {
                        viewModel.postUserResponse = nil
                    }
                }
            }
            .sheet(isPresented: $showCameraPicker) { CameraView(isPresented: $showCameraPicker, image: $viewModel.selectedImage) }
            .photosPicker(isPresented: $showImagePicker, selection: $viewModel.selectedPickerItem, matching: .images)
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Select Photo Source"),
                    buttons: [
                        .default(Text("Library")) {
                            showImagePicker.toggle()
                        },
                        .default(Text("Camera")) {
                            showCameraPicker.toggle()
                        },
                        .cancel(Text("Cancel"))
                    ]
                )
            }
        }
    }
}


#Preview {
    SignUpView(viewModel: SignUpViewModel(networkManager: NetworkManager()))
}





