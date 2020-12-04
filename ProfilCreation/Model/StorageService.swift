//
//  StorageService.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 23/11/2020.
//

import Foundation
import FirebaseStorage

class StorageService {
    //
    
    let firestoreService = FirestoreService()
    
    func downloadUsersImage(imagePath: String, callback: @escaping(UIImage)->Void) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let usersImageRef = storageRef.child(imagePath)
            
        usersImageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("ERROR GET DATA")
                return
            }
                
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            callback(image)
        }
    }
    
    func uploadUsersImage(image: UIImage) {
        
        let firestoreService = FirestoreService()
        let randomUID = UUID.init().uuidString
        
        let authService = AuthService()
        guard let currentUID = authService.currentUID else {return}
        guard let data = image.jpegData(compressionQuality: 1.0) else {return}
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let usersImageRef = storageRef.child("usersImage").child(currentUID).child(randomUID)
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        usersImageRef.putData(data, metadata: uploadMetaData) { (downloadMetaData, error) in
            if error != nil {
                print("ERROR PUTDATA")
                return
            }
            let pathOfImage = "usersImage/\(currentUID)/\(randomUID)"
            firestoreService.updateUsersData(userID: currentUID, fields: ["userImage": pathOfImage])
        }
       
    }
}
