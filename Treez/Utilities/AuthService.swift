//
//  AuthService.swift
//  Treez
//
//  Created by Weston Gibler on 10/20/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andUsername username: String?, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else { userCreationComplete(false, error); return }
            
            let userData = ["provider": user.user.providerID ,  "email": user.user.email, "username": username]
            DataService.instance.createDBUser(uid: user.user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
}
}
