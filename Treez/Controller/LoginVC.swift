//
//  LoginVC.swift
//  Treez
//
//  Created by Weston Gibler on 10/1/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    var signupModeActive = true
//Login text fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBAction func LoginClicked(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.email.text!,
                                   password: self.password.text!)
            }
        }
    }
    
    @IBAction func RegisterClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
