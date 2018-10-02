//
//  LoginVC.swift
//  Treez
//
//  Created by Weston Gibler on 10/1/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var signupModeActive = true
//Login text fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
//Signup button
    @IBAction func signupOrLogin(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alert = UIAlertController(title: "Error in form input", message: "Please enter a valid email & password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Signing up...")
        }
    
    }

    @IBOutlet weak var signupOrLoginButton: UIButton!
    
//Login button
    @IBAction func switchLoginMode(_ sender: Any) {
        //First, findout which signup mode we are in
        if (signupModeActive) {
            //Change things from signupMode to loginMode
            signupModeActive = false
            signupOrLoginButton.setTitle("Sign me up!", for: [])
            switchLoginModeButton.setTitle("Remembered your Login?...", for: [])
        } else {
            //Change things from loginMode to  signupMode
            signupModeActive = true
            signupOrLoginButton.setTitle("Log me in!", for: [])
            switchLoginModeButton.setTitle("Nevermind, sign me up.", for: [])
        }
    }
    
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
