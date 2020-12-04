//
//  ViewController.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 13/11/2020.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private let authService = AuthService()
    private let alertService = AlertService()
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction private func signIn() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            alertService.showAlert(title: "Erreur", message: "L'un des champs n'est pas rempli", viewController: self)
            return
        }
        
        authService.signIn(email: email, password: password) { (isSuccess) in
            if isSuccess {
              
                self.dismiss(animated: true, completion: nil)
            }else {
                
                self.alertService.showAlert(title: "Erreur", message: "Le mot de passe ou l'email n'est pas correct", viewController: self)
            }
        }
    
    }
    
    @IBAction private func sendNewPassword() {
        alertService.showAlertWithTextField(title: "Attention", message: "Vous êtes sur le point de ré-initialiser votre mot de passe", viewController: self, type: "email") { (email) in
            self.authService.resetPassWord(email: email) { (isSuccess) in
                if isSuccess {
                    self.alertService.showAlert(title: "OK", message: "Un lien a été envoyé a votre boite mail pour ré-initialiser votre mot de passe, vérifiez la.", viewController: self)
                }else {
                    self.alertService.showAlert(title: "Erreur", message: "L'email entré n'existe pas pour cette app.", viewController: self)
                    return
                }
            }
        } canceled: {
            return
        }

        
    }
    
    @IBAction private func goToLogin() {
        performSegue(withIdentifier: "segueToLogin", sender: self)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
         emailTextField.resignFirstResponder()
         passwordTextField.resignFirstResponder()
    }
      
     //Dismiss a keyboard when user tap on its button 'Continue'
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         textField.returnKeyType = .continue
         return true
     }
    
    @IBAction private func unwindToSignInViewController(_ segue: UIStoryboardSegue) {
        dismiss(animated: false)
    }


}

