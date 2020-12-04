//
//  LogInViewController.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 13/11/2020.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    let alertService = AlertService()
    
    var name = String()
    var surname = String()
    var birthdate = Date()
    var gender = 1
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendar = Calendar(identifier: .gregorian)

        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar

        components.year = -15
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!

        components.year = -100
        let minDate = calendar.date(byAdding: components, to: currentDate)!

        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate

        // Do any additional setup after loading the view.
    }
    

    @IBAction func continueToNextForm() {
        guard let name = nameTextField.text, !name.isEmpty , let surname = surnameTextField.text, !surname.isEmpty else {
            alertService.showAlert(title: "Erreur", message: "L'un des champs n'est pas rempli ", viewController: self)
            return}
        
        if name.trimmingCharacters(in: .whitespaces).removeExtraSpaces().count < 2 {
            alertService.showAlert(title: "Erreur", message: "Le nom doit contenir au moins 2 caractères", viewController: self)
            return
        }
        
        if surname.trimmingCharacters(in: .whitespaces).removeExtraSpaces().count < 2 {
            alertService.showAlert(title: "Erreur", message: "Le prénom doit contenir au moins 2 caractères", viewController: self)
            return
        }
        
        
        self.name = name
        self.surname = surname
        gender = segmentedControl.selectedSegmentIndex
        birthdate = datePicker.date
        
        performSegue(withIdentifier: "segueToFinalLogin", sender: self)
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let finalLogin = segue.destination as? FinalLoginViewController else {return}
        finalLogin.name = name
        finalLogin.surname = surname
        finalLogin.gender = gender
        finalLogin.birthdate = birthdate
        
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
