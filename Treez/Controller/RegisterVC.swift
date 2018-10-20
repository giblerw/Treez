//
//  RegisterVC.swift
//  Treez
//
//  Created by Weston Gibler on 10/20/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil && usernameField.text != nil {

            AuthService.instance.registerUser(withEmail: self.emailField.text!, andUsername: self.usernameField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
                if success {
                    AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                        self.dismiss(animated: true, completion: nil)
                        print("Successfully registered user")
                    })
                } else {
                    print(String(describing: registrationError?.localizedDescription))
                }
            })
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension RegisterVC: UITextFieldDelegate {
    
}
