//
//  AlertService.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 19/11/2020.
//

import Foundation
import UIKit

struct AlertService {
    
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        myAlert.addAction(okAction)
        viewController.present(myAlert, animated: true, completion: nil)
    }
    
    func showAlertWithActions(title: String, message: String, positiveTitle: String, negativeTitle: String,viewController: UIViewController, isMustAddCancelAction: Bool, validate: @escaping()->Void, canceled: @escaping()-> Void) {
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let positiveAction = UIAlertAction(title: positiveTitle, style: .default) { (UIAlertAction) in
            validate()
        }
        
        let canceledAction = UIAlertAction(title: negativeTitle, style: .default) { (UIAlertAction) in
            canceled()
        }
        
        myAlert.addAction(positiveAction)
      
        
        if isMustAddCancelAction {
            myAlert.addAction(canceledAction)
            myAlert.addAction(canceledAction)
        }
        
        viewController.present(myAlert, animated: true, completion: nil)
        
    }
    
    func showAlertWithTextField(title: String, message: String, viewController: UIViewController, type: String, validate: @escaping(String)-> Void, canceled: @escaping()-> Void) {
        
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlert.addTextField { (textField) in
            switch type {
            case "phoneNumber":
                textField.placeholder = "Numéro de téléphone"
                textField.keyboardType = .numberPad
            case "email":
                textField.placeholder = "Email"
                textField.keyboardType = .emailAddress
            case "password" :
                textField.placeholder = "Mot de passe"
                textField.isSecureTextEntry = true
            default:
                textField.placeholder = "Email"
                textField.keyboardType = .emailAddress
            }
        }
        
        
       let okAction = UIAlertAction(title: "Valider", style: .default) { [unowned myAlert] _ in
               let answer = myAlert.textFields![0]
            guard let text = answer.text, !text.isEmpty else {
                self.showAlert(title: "Erreur", message: "Vous devez entrer votre mot de passe", viewController: viewController)
                return
                
            }
            validate(text)
           }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertAction.Style.default) { (UIAlertAction) in
            NSLog("Canceled pressed")
            canceled()
        }
        
        
        myAlert.addAction(cancelAction)
        myAlert.addAction(okAction)
     
        
        viewController.present(myAlert, animated: true, completion: nil)
    }
    
}
