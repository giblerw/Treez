//
//  Tree.swift
//  Treez
//
//  Created by Weston Gibler on 10/5/18.
//  Copyright © 2018 Weston Gibler. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
