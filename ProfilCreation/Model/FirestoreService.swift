//
//  FirestoreService.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 19/11/2020.
//

import Foundation
import UIKit
import FirebaseFirestore

class FirestoreService {
    
    func downloadUserProfil(userID: String, callback: @escaping(UserProfil)-> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (snapshot, error) in
            
            if error != nil {
               return
            }
            guard let snapshot = snapshot else {return}
            guard let description = snapshot.data() else {return}
            
            guard let name = description["name"] as? String else {return}
            guard let surname = description["surname"] as? String else {return}
            guard let birthdateTS = description["birthDate"] as? Timestamp else {return}
            let birthdate = birthdateTS.dateValue()
            guard let gender = description["gender"] as? Int else {return}
            guard let imagePath = description["userImage"] as? String else {return}
            
            self.downloadUserImage(imagePath: imagePath) { (image) in
                let userProfil = UserProfil(name: name, surname: surname, birthdate: birthdate, gender: gender, profilImage: image)
                
                callback(userProfil)
            }
        }
    }
    
    private func downloadUserImage(imagePath: String, callback: @escaping(UIImage)-> Void) {
        let storageService = StorageService()
        storageService.downloadUsersImage(imagePath: imagePath) { (image) in
            callback(image)
        }
    }
    
    func updateUsersData(userID: String, fields: [String: Any]) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        docRef.updateData(fields)
    }
    
    
    
}
