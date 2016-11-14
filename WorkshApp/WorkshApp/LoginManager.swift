//
//  LoginManager.swift
//  WorkshApp
//
//  Created by Pia Muñoz on 9/11/16.
//  Copyright © 2016 iOSWorkshops. All rights reserved.
//

import Foundation

class LoginManager {
    
    fileprivate static let validCredentials = [
        Credentials(email: "mickeymousse@napptilus.com", password: "Napptilus"),
        Credentials(email: "donaldduck@napptilus.com", password: "ItsATrump")
    ]
    
    struct Credentials {
        var email: String
        var password: String
        
        init?(email: String, password: String) {
            guard email.isValidEmail() && password.isValidPassword() else {
                return nil
            }
            self.email = email
            self.password = password
        }
    }
    
    weak var vc: ViewController!
    
    var credentials: Credentials?
    
    func login (email: String, password: String) {
        
        credentials = Credentials(email: email, password: password)
        guard let credentials = credentials else {
            vc.loginDidFail(errorMessage: "Please insert correct credentials")
            return
        }
        
        vc.showLoading()
        performLogin(credentials: credentials) { isSuccessful in
            self.vc.hideLoading()
            if isSuccessful {
                self.vc.loginDidSucceed()
            }
            else {
                self.vc.loginDidFail(errorMessage: "Email and password do not match")
            }
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
    fileprivate func performLogin(credentials: Credentials, completionHandler: @escaping (Bool) -> ()) {
        delay(2) {
            
            for element in LoginManager.validCredentials {
                if element?.email == credentials.email && element?.password == credentials.password {
                    completionHandler(true)
                    return
                }
            }
            completionHandler(false)

//            Solution with filter:
//            let results = LoginManager.validCredentials.filter({ validCredential -> Bool in
//                return validCredential!.email == credentials.email && validCredential!.password == credentials.password
//            })
//            
//            guard results.count > 0 else {
//                completionHandler(false)
//                return
//            }
//
//            completionHandler(true)
        }
    }
    
    private func delay(_ seconds: Int, completionHandler: @escaping () -> ()) {
        let deadlineTime = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            completionHandler()
        })
    }
}
