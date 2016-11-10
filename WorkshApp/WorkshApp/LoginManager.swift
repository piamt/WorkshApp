//
//  LoginManager.swift
//  WorkshApp
//
//  Created by Pia Muñoz on 9/11/16.
//  Copyright © 2016 iOSWorkshops. All rights reserved.
//

import Foundation

class LoginManager {
    
    weak var vc: ViewController!
    
    func login (email: String, password: String) {
        let valid = email.isValidEmail() && password.isValidPassword()
        if valid {
            vc.loginDidSucceed()
        } else {
            vc.loginDidFail(errorMessage: "Please insert correct credentials")
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return self.characters.count >= 6
    }
}
