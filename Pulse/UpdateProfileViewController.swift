//
//  UpdateProfileViewController.swift
//  Pulse
//
//  Created by Itasari on 11/12/16.
//  Copyright © 2016 ABI. All rights reserved.
//

import UIKit
import Parse

class UpdateProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var user: PFUser! = PFUser.current()
    var person: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile()
        emailTextField.isUserInteractionEnabled = false
    }

    // MARK: - Actions
    @IBAction func onUpdateProfileButtonTap(_ sender: UIButton) {
        if validateEntry() {
            let lastName = (lastNameTextField.text?.isEmpty)! ? firstNameTextField.text : lastNameTextField.text
            let phone = (phoneTextField.text?.isEmpty)! ? "" : phoneTextField.text
            
            PFUser.logInWithUsername(inBackground: user.username!, password: passwordTextField.text!) { (user: PFUser?, error: Error?) in
                if let error = error {
                    self.ABIShowAlert(title: "Error", message: "Your password is incorrect: \(error.localizedDescription)", sender: nil, handler: nil)
                } else {
                    self.person[ObjectKeys.Person.firstName] = self.firstNameTextField.text
                    self.person[ObjectKeys.Person.lastName] = lastName
                    self.person[ObjectKeys.Person.phone] = phone
                    //self.person[ObjectKeys.Person.email] =  self.emailTextField.text
                    
                    self.person.saveInBackground(block: { (success: Bool, error: Error?) in
                        if success {
                            self.ABIShowAlert(title: "Success", message: "Update profile successful", sender: nil, handler: { (alertAction: UIAlertAction) in
                                let _ = self.navigationController?.popViewController(animated: true)
                            })
                        } else {
                            self.ABIShowAlert(title: "Error", message: "Unable to update user profile with error: \(error?.localizedDescription)", sender: nil, handler: nil)
                        }
                    })
                }
            }
        }
    }
    
    
    // MARK: - Helpers
    
    fileprivate func getUserProfile() {
        let query = PFQuery(className: "Person")
        query.whereKey(ObjectKeys.Person.userId, equalTo: user.objectId!)
        query.findObjectsInBackground { (persons: [PFObject]?, error: Error?) in
            if let error = error {
                debugPrint("Unable to find person associated with current user id, error: \(error.localizedDescription)")
            } else {
                if let persons = persons {
                    if persons.count > 0 {
                        let person = persons[0]
                        self.person = person
                        debugPrint("after query person is \(self.person)")
                        self.configureTextFields()
                    }
                }
            }
        }
    }
    
    fileprivate func configureTextFields() {
        if person != nil {
            if let firstName = person[ObjectKeys.Person.firstName] as? String {
                firstNameTextField.text = firstName
            }
            if let lastName = person[ObjectKeys.Person.lastName] as? String {
                lastNameTextField.text = lastName
            }
            if let phone = person[ObjectKeys.Person.phone] as? String {
                phoneTextField.text = phone
            }
            if let email = person[ObjectKeys.Person.email] as? String {
                emailTextField.text = email
            }
        }
    }
    
    fileprivate func validateEntry() -> Bool {
        // Check if password is empty
        guard !((passwordTextField.text?.isEmpty)!) else {
            ABIShowAlert(title: "Error", message: "Password field cannot be empty", sender: nil, handler: nil)
            return false
        }
        
        // Check if first name is empty
        guard !((firstNameTextField.text?.isEmpty)!) else {
            ABIShowAlert(title: "Error", message: "First name field cannot be empty", sender: nil, handler: nil)
            return false
        }

        /*
        // Check if email is empty
        guard !((emailTextField.text?.isEmpty)!) else {
            ABIShowAlert(title: "Error", message: "Email field cannot be empty", sender: nil, handler: nil)
            return false
        }
        
        // Check if it's a valid email
        guard emailTextField.text!.isValidEmail() else {
            ABIShowAlert(title: "Error", message: "Please enter a valid email", sender: nil, handler: nil)
            return false
        }*/
        
        // Check if it's a valid phone
        if !(phoneTextField.text?.isEmpty)! && !(phoneTextField.text?.isValidPhone())! {
            ABIShowAlert(title: "Error", message: "Please enter a valid phone", sender: nil, handler: nil)
            return false
        }
        
        return true
    }
}
