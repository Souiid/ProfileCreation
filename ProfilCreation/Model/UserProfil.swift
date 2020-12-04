//
//  UserProfile.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 23/11/2020.
//

import Foundation
import UIKit

class UserProfil {
    let name: String
    let surname: String
    let birthDate: Date
    let gender: Int
    let profilImage: UIImage
    
    init(name: String, surname: String, birthdate: Date, gender: Int, profilImage: UIImage) {
        self.name = name
        self.surname = surname
        self.birthDate = birthdate
        self.gender = gender
        self.profilImage = profilImage
    }
}
