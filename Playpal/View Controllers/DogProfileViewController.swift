//
//  DogProfileViewController.swift
//  Playpal
//
//  Created by Samantha Lee on 4/19/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import Firebase
import FirebaseAuth
import Foundation
import UIKit

class DogProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pupNameTF: UITextField!
    @IBOutlet weak var breedTF: UITextField!
    var sizePicker = UIPickerView()
    var genderPicker = UIPickerView()
    @IBOutlet weak var sizeTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var bioTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var sizePickerData: [String] = [String]()
    var genderPickerData: [String] = [String]()
    
    var size: String?
    var gender: String?
    
    @IBOutlet weak var dogProfileImageView: UIImageView!
  
    
    // picker functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows : Int = sizePickerData.count
        if pickerView == genderPicker {
            numRows = self.genderPickerData.count
        }
        return numRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("hi")
        if pickerView == sizePicker {
            let titleRow = sizePickerData[row]
            return titleRow
        } else if pickerView == genderPicker {
            let titleRow = genderPickerData[row]
            return titleRow
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sizePicker {
            self.size = self.sizePickerData[row]
            sizeTF.text = self.sizePickerData[row]
        } else if pickerView == genderPicker {
            self.gender = self.genderPickerData[row]
            genderTF.text = self.genderPickerData[row]
        }
    }
    
    // sets up dog profile image picker
    func setUpDogProfile() {
        dogProfileImageView.layer.cornerRadius = 40
        dogProfileImageView.clipsToBounds = true
        dogProfileImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        dogProfileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated:  true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        
        /// fills picker withh options
        sizePickerData = ["Small", "Medium", "Large"]
        genderPickerData = ["Male", "Female"]
        
        self.sizePicker.delegate = self
        self.sizePicker.dataSource = self
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        
        /// sets textfields to show picker when clicked
        sizeTF.inputView = sizePicker
        genderTF.inputView = genderPicker
        
        // hides navigation controller
        self.navigationController?.isNavigationBarHidden = false
        
        setUpDogProfile()
        setUpElements()
    }
    
    // segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let suvc = segue.destination as? SignUpViewController {
            suvc.pupNameText = pupNameTF.text
            suvc.breedText = breedTF.text
            suvc.size = sizeTF.text
            suvc.gender =  genderTF.text
            suvc.bioText = bioTF.text
            
            // extract image data before sending
            guard let imageSelected = dogProfileImageView.image else {
                showError("Please select your dog's profile picture")
                return
            }

            guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                return
            }
            suvc.dogImageData = imageData
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            performSegue(withIdentifier: "segueToSignUp", sender: nil)
        }
    }
    
    func validateFields() -> String?{
        if pupNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            breedTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            sizeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            genderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            bioTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func setUpElements() {
        Utilities.styleTextField(pupNameTF)
        Utilities.styleTextField(breedTF)
        Utilities.styleFilledButton(nextButton)
        Utilities.styleTextField(bioTF)
    }
}

// image picker for dog profile image selection
extension DogProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dogProfileImageView.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dogProfileImageView.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
