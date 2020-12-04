//
//  AuthService.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 14/11/2020.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    let auth = Auth.auth()

    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var currentUID: String? {
        return currentUser?.uid
    }
    
    
    func signIn(email: String, password: String, callback: @escaping(Bool)-> Void) {
        let db = Firestore.firestore()
        auth.signIn(withEmail: email, password: password) {  (authResult, error) in
            if error != nil {
                callback(false)
                return
            }else {
                guard let userID = self.currentUID else {return}
                let docRef = db.collection("users").document(userID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        callback(true)
                    }else {
                        callback(false)
                    }
                }
            }
        }
    }
    
    func createUser(email: String, password: String, name:String, surname:String, birthDate: Date, gender: Int, userImage: String, callback: @escaping(Bool)-> Void) {
        
        let db = Firestore.firestore()
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                callback(false)
                return
            }
            
            guard let userID = self.currentUID else {return}
            let docRef = db.collection("users").document(userID)
            docRef.setData(["name" : name, "surname": surname, "birthDate": birthDate, "gender": gender, "userImage": userImage])
            self.sendVerificationMail()
            callback(true)
            
        }
    }
    
    public func sendVerificationMail() {
        if self.currentUser != nil && !self.currentUser!.isEmailVerified {
         
            self.currentUser!.sendEmailVerification { (error) in
                //
            }
        }
    }
    
    func isUserConnected(callback: @escaping (Bool) -> Void) {
         _ = Auth.auth().addStateDidChangeListener { _, user in
             guard (user != nil) else {
                 callback(false)
                   return
             }
               callback(true)
         }
     }
    
    func signOut() {
        do {
          try auth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
       
    }
    
    func updateUserEmail(email: String, password: String, callback: @escaping (Bool) -> Void) {
       
        guard let currentEmail = currentUser?.email else {return}
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
        self.currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if error != nil {
           
                return
            }
             self.currentUser?.updateEmail(to: email, completion: { (error) in
                if error != nil {
                    callback(false)
                }else {
                    self.sendVerificationMail()
                    callback(true)
                }
            })
        })
    }
    
    func updateUserPassWord(newPassword: String, password: String, callback: @escaping (Bool) -> Void) {
        guard let currentEmail = currentUser?.email else {return}
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
      
        
        self.currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if error != nil {
               
                return
            }
            self.currentUser?.updatePassword(to: newPassword, completion: { (error) in
                 if error != nil {
           
                  callback(false)
                }else {
                    callback(true)
                }
            })
        })
    }
    
    func resetPassWord(email: String, callback: @escaping (Bool) -> Void) {
        Auth.auth().languageCode = "fr"
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
               
                callback(false)
                return
            }
            
            callback(true)
        }
    }
    
}
