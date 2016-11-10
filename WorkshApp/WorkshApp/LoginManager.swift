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
            vc.showLoading()
            performLogin(completionHandler: { isSuccessful in
                self.vc.hideLoading()
                if isSuccessful {
                    self.vc.loginDidSucceed()
                }
                else {
                    self.vc.loginDidFail(errorMessage: "Email and password do not match")
                }
            })
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

extension LoginManager {
    fileprivate func performLogin(completionHandler: @escaping (Bool) -> ()) {
        delay(2) {
            completionHandler(true)
        }
    }
    
    private func delay(_ seconds: Int, completionHandler: @escaping () -> ()) {
        let deadlineTime = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            completionHandler()
        })
    }
}
