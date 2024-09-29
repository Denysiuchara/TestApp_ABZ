//
//  CustomTextField.swift
//  TestTaskByDaniaDenisuk
//
//  Created by Danya Denisiuk on 28.09.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let inputExample: String?
    let prompt: String?
    
    init(text: Binding<String>, placeholder: String, inputExample: String? = nil, prompt: String? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.inputExample = inputExample
        self.prompt = prompt
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            TextField(text: $text) {
                Text(placeholder)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 18))
            }
            .padding(20)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(prompt == nil ? .black.opacity(0.6) : .customRed, lineWidth: 1)
            }
            
            if let inputExample, prompt == nil {
                Text(inputExample)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 15))
                    .padding(.horizontal, 20)
                    .foregroundStyle(.black.opacity(0.6))
            }
            
            if let prompt {
                Text(prompt)
                    .font(Font.custom("NunitoSans-ExtraLight", size: 15))
                    .padding(.horizontal, 20)
                    .foregroundStyle(.customRed)
            }
        }
    }
}
