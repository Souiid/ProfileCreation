//
//  ModifyNameViewController.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 25/11/2020.
//

import UIKit

class ModifyNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var surnameTextField: UITextField!
    @IBOutlet weak private var validateButton: UIButton!
    private let alertService = AlertService()
    private let firestoreService = FirestoreService()
    private let authService = AuthService()
    
    var name = String()
    var surname = String()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.placeholder = name
        surnameTextField.placeholder = surname
      
    }
    
    @IBAction func validate() {
        
        
        if nameTextField.text == "" && surnameTextField.text == "" {
            presentAlert(message: "Il faut remplir au moins l'un des deux champs de texte", title: "Erreur")
            return
        }
        
              
        guard let surnamePlaceHolder = surnameTextField.placeholder else {return}
        guard let namePlaceHolder = nameTextField.placeholder else {return}
        
        var surname = ""
        var name = ""
              
        name = nameTextField.text == "" ? namePlaceHolder : nameTextField.text ?? ""
        surname = surnameTextField.text == "" ? surnamePlaceHolder : surnameTextField.text ?? ""
        
        let correctName = name.trimmingCharacters(in: .whitespaces).removeExtraSpaces()
        let correctSurname = surname.trimmingCharacters(in: .whitespaces).removeExtraSpaces()
       
        if correctName.count < 2 {
            alertService.showAlert(title: "Erreur", message: "Le nom doit contenir au moins 2 caractères", viewController: self)
            return
        }
        
        if correctSurname.count < 2 {
             alertService.showAlert(title: "Erreur", message: "Le prénom doit contenir au moins 2 caractères", viewController: self)
            return
        }
        
        guard let currentUID = authService.currentUID else {return}
        self.name = name
        self.surname = surname
        
        firestoreService.updateUsersData(userID: currentUID, fields: ["name": name, "surname": surname])
        alertService.showAlert(title: "OK", message: "Votre nom est modifié", viewController: self)
    }
    
    func presentAlert(message: String, title: String) {
        alertService.showAlert(title: title, message: message, viewController: self)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
    }
         
    //Dismiss a keyboard when user tap on its button 'Continue'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .continue
        return true
    }
    
    
    



}
