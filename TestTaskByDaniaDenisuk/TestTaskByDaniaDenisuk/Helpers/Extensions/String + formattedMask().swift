//
//  String + formattedMask().swift
//  TestTaskByDaniaDenisuk
//
//  Created by Danya Denisiuk on 27.09.2024.
//

import Foundation

extension String {
    var onlyDigits: String {
        self.filter { $0.isNumber }
    }
    
    func formattedMask(text: String, mask: String?) -> String {
        let cleanPhoneNumber = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPhoneNumber.startIndex
        if let mask = mask {
            for ch in mask where index < cleanPhoneNumber.endIndex {
                if ch == "X" {
                    result.append(cleanPhoneNumber[index])
                    index = cleanPhoneNumber.index(after: index)
                } else {
                    result.append(ch)
                }
            }
        }
        return result
    }
}
