//
//  ViewModel.swift
//  TestTaskByDaniaDenisuk
//
//  Created by Danya Denisiuk on 27.09.2024.
//

import SwiftUI
import PhotosUI
import Combine

final class SignUpViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var canSubmit = true
    @Published var positions: [Position] = []
    @Published var selectedPosition: Position?
    @Published var selectedPickerItem: PhotosPickerItem? {
        didSet {
            Task { await loadImageData() }
        }
    }
    @Published var selectedImage: UIImage?
    @Published var postUserResponse: PostUserResponse? = nil
    
    @Published private var isValidEmail = false
    @Published private var isValidPhone = false
    @Published private var isValidName = false
    
    private let emailPredicate = NSCompoundPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)
    private let phonePredicate = NSCompoundPredicate(format: "SELF MATCHES %@", Regex.phone.rawValue)
    private var cancellable: Set<AnyCancellable> = []
    var networkManager: NetworkManager
    
    var emailPrompt: String? {
        if email.isEmpty || isValidEmail {
            return nil
        } else {
            return "Enter valid email. Example: test@test.com"
        }
    }
    
    var phonePrompt: String? {
        if phone.isEmpty || isValidPhone {
            return nil
        } else {
            return "Enter valid phone."
        }
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        setReactive()
    }
    
    private func setReactive() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { email in
                self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &cancellable)
        
        $phone
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { phone in
                self.phonePredicate.evaluate(with: phone)
            }
            .assign(to: \.isValidPhone, on: self)
            .store(in: &cancellable)
        
        $name
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { name in
                name.count >= 3
            }
            .assign(to: \.isValidName, on: self)
            .store(in: &cancellable)
        
        Publishers.CombineLatest3($isValidEmail, $isValidPhone, $isValidName)
            .map { email, phone, name in
                email && phone && name
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellable)
    }
    
    @MainActor
    private func loadImageData() async {
        guard let selectedPickerItem = selectedPickerItem else { return }
        
        do {
            if let data = try await selectedPickerItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.selectedImage = image
            } else {
                self.selectedImage = nil
            }
        } catch {
            print("Error loading image: \(error)")
            self.selectedImage = nil
        }
    }
    
    @MainActor
    func postUser() async throws {
        guard let positionId = selectedPosition?.id else { throw Error.emptyPosition }
        guard let imageAsData = selectedImage?.asBackendReadyData else { throw Error.failureConvertImage }
        
        let token = try await networkManager.getToken()
        let response = try await networkManager.postUser(
            token: token,
            user: NewUser(
                name: name,
                email: email,
                phone: phone,
                positionId: positionId,
                photo: imageAsData
            )
        )
        self.postUserResponse = response
    }
    
    @MainActor
    func getPositions() async throws {
        positions = try await networkManager.getPositions()
        
        guard !positions.isEmpty else { return }
        selectedPosition = positions.first
    }
}


extension SignUpViewModel {
    enum Error: Swift.Error {
        case invalidEmail
        case invalidPassword
        case invalidUsername
        case emptyPosition
        case emptyImage
        case failureConvertImage
    }
}


