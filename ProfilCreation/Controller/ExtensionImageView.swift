//
//  ExtensionImageView.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 23/11/2020.
//

import Foundation
import UIKit

extension UIImageView {
   
    func makeRounded() {
       
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
