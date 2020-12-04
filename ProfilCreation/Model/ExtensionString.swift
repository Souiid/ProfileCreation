//
//  ExtensionString.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 20/11/2020.
//

import Foundation

extension String {
   
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
      }

      mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
      }
}
