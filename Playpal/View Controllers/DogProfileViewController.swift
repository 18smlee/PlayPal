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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var sizePickerData: [String] = [String]()
    var genderPickerData: [String] = [String]()
    
    var size: String?
    var gender: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        
        sizePickerData = ["Small", "Medium", "Large"]
        genderPickerData = ["Male", "Female"]
        
        self.sizePicker.delegate = self
        self.sizePicker.dataSource = self
        
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        
        sizeTF.inputView = sizePicker
        genderTF.inputView = genderPicker
        
        self.navigationController?.isNavigationBarHidden = false
        
        setUpElements()
    }
    
    // segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let suvc = segue.destination as? SignUpViewController {
            suvc.pupNameText = pupNameTF.text
            suvc.breedText = breedTF.text
            suvc.size = sizeTF.text
            suvc.gender =  genderTF.text
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
    
    // Checks to make sure all text fields are valid. If correct return nil, else return error message.
    func validateFields() -> String?{
        if pupNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            breedTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            sizeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            genderTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
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
    }
}
