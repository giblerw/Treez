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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func LoginClicked(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let errorAlert = UIAlertController(title: "Missing Required Input", message: "Please enter your email address and password, or click below to signup with new account", preferredStyle: .actionSheet)
            let errorAlertAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            errorAlert.addAction(errorAlertAction)
            present(errorAlert, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.email.text!,
                               password: self.password.text!)
            let loginSuccessful = storyboard?.instantiateViewController(withIdentifier: "HomeTabController") 
            present(loginSuccessful!, animated: true, completion: nil)
        }
    }
    
    @IBAction func RegisterClicked(_ sender: Any) {
        let registerVc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        present(registerVc!, animated: true, completion: nil)
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
