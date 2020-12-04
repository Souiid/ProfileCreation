//
//  FinalLoginViewController.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 13/11/2020.
//

import UIKit

class FinalLoginViewController: UIViewController {
    
    var name = String()
    var surname = String()
    var gender = Int()
    var birthdate = Date()
    var imagePath = String()
    
    let alertService = AlertService()
    let authService = AuthService()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func validate() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordConfirmation = passwordConfirmationTF.text, !password.isEmpty else {
            alertService.showAlert(title: "Erreur", message: "L'un des champs n'est pas rempli", viewController: self)
        return}
        
        if password != passwordConfirmation {
            alertService.showAlert(title: "Erreur", message: "Le mot de passe n'est pas le même dans les deux champs.", viewController: self)
        }
        
        if gender == 1 {
            imagePath = "ManEmpty.png"
        }else {
            imagePath = "WomanEmpty.png"
        }
        
        authService.createUser(email: email, password: password, name: name, surname: surname, birthDate: birthdate, gender: gender, userImage: imagePath) { (isSuccess) in
            if !isSuccess {
                self.alertService.showAlert(title: "Erreur", message: "L'email ou le mot de passe est incorrect ou déjà utilisé pour cette app. Le mot de passe doit contenir au 6 caractères dont deux chiffres", viewController: self)
                print("Erreur")
            }else {
                self.alertService.showAlertWithActions(title: "OK", message: "Vous avez été inscrit avec succés, un email de confirmation va vous être envoyé.", positiveTitle: "Ok", negativeTitle: "", viewController: self, isMustAddCancelAction: false) {
                    self.performSegue(withIdentifier: "unwindToSignInViewController", sender: nil)
                } canceled: {
                    return
                }
            }
        }
    }
    
    
}
