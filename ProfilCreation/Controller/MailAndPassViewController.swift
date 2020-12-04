//
//  MailAndPassViewController.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 25/11/2020.
//

import UIKit

class MailAndPassViewController: UIViewController, UITextFieldDelegate {

    private let authService = AuthService()
    private let alertService = AlertService()
    
    @IBOutlet weak private var modifyMailButton: UIButton!
    @IBOutlet weak private var modifyPassButton: UIButton!
    
    @IBOutlet weak private var oldEmailLabel: UILabel!
    @IBOutlet weak private var newEmailTextField: UITextField!
    
    @IBOutlet weak private var passTextfield: UITextField!
    @IBOutlet weak private var passConfirmationTextfield: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let email = authService.currentUser?.email else {return}
        oldEmailLabel.text = "Email actuel : " + email
    }
    

    @IBAction func modifyEmail() {
        guard let email = newEmailTextField.text, !email.isEmpty else {return}
        
        alertService.showAlertWithTextField(title: "Mot de passe", message: "Entrez votre mot de passe", viewController: self, type: "password", validate: { (password) in
            print("OK")
            self.authService.updateUserEmail(email: email, password: password) { (isSuccess) in
                if isSuccess {
                    
                    self.alertService.showAlertWithActions(title: "OK", message: "Email modifié. Vous allez être redirigé vers la page d'acceuil. Un email va vous être envoyé.", positiveTitle: "Ok", negativeTitle: "" ,viewController: self, isMustAddCancelAction: false) {
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignIn")
                        signInVC.modalPresentationStyle = .fullScreen
                        signInVC.isModalInPresentation = true
                        self.present(signInVC, animated: true, completion: nil)
                    } canceled: {
                        return
                    }

                   
                }else {
                    self.alertService.showAlert(title: "Erreur", message: "L'email de passe existe dèja", viewController: self)
                }
            }
        }) {
            return
        }
    }
    
    @IBAction func modifyPassword() {
        guard let newPassword = passTextfield.text, !newPassword.isEmpty else {return}
        guard let passwordConfirmation = passConfirmationTextfield.text, !passwordConfirmation.isEmpty else {return}
        
        if newPassword != passwordConfirmation {
            alertService.showAlert(title: "Erreur", message: "Le mot de passe dans les deux champs ne sont pas les mêmes.", viewController: self)
            return
        }
        
        alertService.showAlertWithTextField(title: "Mot de passe", message: "Entrez votre mot de passe", viewController: self, type: "password", validate: { (password) in
            self.authService.updateUserPassWord(newPassword: newPassword, password: password) { (isSuccess) in
                if isSuccess {
                    self.alertService.showAlertWithActions(title: "OK", message: "Email modifié. Vous allez être redirigé vers la page d'acceuil", positiveTitle: "Ok", negativeTitle: "" ,viewController: self, isMustAddCancelAction: false) {
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignIn")
                        signInVC.modalPresentationStyle = .fullScreen
                        signInVC.isModalInPresentation = true
                        self.present(signInVC, animated: true, completion: nil)
                    } canceled: {
                        return
                    }

                }else {
                    self.alertService.showAlert(title: "Erreur", message: "Le mot de passe n'est pas correcte", viewController: self)
                }
            }
        }) {
            return
        }
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        newEmailTextField.resignFirstResponder()
        passTextfield.resignFirstResponder()
        passConfirmationTextfield.resignFirstResponder()
     }
     
    //Dismiss a keyboard when user tap on its button 'Continue'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .continue
        return true
    }

}
