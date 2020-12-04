//
//  ProfileViewController.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 23/11/2020.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let authService = AuthService()
    private let firestoreService = FirestoreService()
    private let alertService = AlertService()
    private let storageService = StorageService()
    
    var name = String()
    var surname = String()
    private var birthDate = Date()
    private var userImage = UIImage()
    private var gender = Int()
    private var currentImage = UIImage()
    
    private var isModifyingGender = true
    private var currentUID = String()
    
    @IBOutlet private var profilImageView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var ageLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var modifyGenderButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilImageView.makeRounded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backToLoginIfNotConnected()
    }
    
    func backToLoginIfNotConnected() {
        authService.isUserConnected { (isConnected) in
            if !isConnected {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignIn")
                signInVC.modalPresentationStyle = .fullScreen
                signInVC.isModalInPresentation = true
                self.present(signInVC, animated: true, completion: nil)
            }else {
                self.downloadUserInfos()
            }
        }
    }
    
    
    func downloadUserInfos() {
        guard let currentUID = authService.currentUID else {return}
        self.currentUID = currentUID
        self.firestoreService.downloadUserProfil(userID: currentUID) { (userProfil) in
            self.userNameLabel.text = userProfil.name + " " + userProfil.surname
            self.name = userProfil.name
            self.surname = userProfil.surname
  
            let age = Date().getAgeFromBirthDate(date: userProfil.birthDate)
            self.ageLabel.text = String(age) + " ans"
            
            
           // self.ageLabel.text = userProfil.birthDate
            self.profilImageView.image = userProfil.profilImage
            self.gender = userProfil.gender
            if self.gender == 0 {
                self.genderLabel.text = "Je suis une femme"
            }else {
                self.genderLabel.text = "Je suis un homme"
            }
            
        }
    }
    
    
    @IBAction func mofifyUserPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction private func signOut() {
        authService.signOut()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = mainStoryboard.instantiateViewController(withIdentifier: "SignIn")
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.isModalInPresentation = true
        self.present(signInVC, animated: true, completion: nil)
        
    }
    
    @IBAction private func modifyMailOrPass() {
        performSegue(withIdentifier: "segueToModifyPassMail", sender: self)
    }
    
    @IBAction private func modifyName() {
        performSegue(withIdentifier: "segueToModifyName", sender: self)
    }
    
    @IBAction private func modifyGender() {
        if isModifyingGender {
            modifyGenderButton.setTitle("Valider", for: .normal)
            segmentedControl.isHidden = false
            isModifyingGender = false
            
        }else {
            modifyGenderButton.setTitle("Modifier", for: .normal)
            segmentedControl.isHidden = true
            isModifyingGender = true
            let genderIndex = segmentedControl.selectedSegmentIndex
            firestoreService.updateUsersData(userID: currentUID, fields: ["gender": genderIndex])
            
            switch genderIndex {
            case 0:
                genderLabel.text = "Je suis une femme"
            case 1:
                genderLabel.text = "Je suis un homme"
            default:
                return
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let modifyNameVC = segue.destination as? ModifyNameViewController else {return}
        modifyNameVC.name = name
        modifyNameVC.surname = surname
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
    
        profilImageView.clipsToBounds = true
        dismiss(animated: true)
        currentImage = image
        profilImageView.image = currentImage
        storageService.uploadUsersImage(image: image)
    }
    
    
    

    
    
}
