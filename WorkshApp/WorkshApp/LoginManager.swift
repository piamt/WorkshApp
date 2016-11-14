//
//  LoginManager.swift
//  WorkshApp
//
//  Created by Pia Muñoz on 9/11/16.
//  Copyright © 2016 iOSWorkshops. All rights reserved.
//

import Foundation

enum LoginResult {
    case failure(LoginError)
    case success(Token)
}

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
    case wrongCredentials
}

struct Token {
    let authToken: String
}

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
        performLogin(credentials: credentials) { loginResult in
            self.vc.hideLoading()
            switch loginResult {
            case .failure(let error):
                switch error {
                case .invalidEmail:
                    self.vc.loginDidFail(errorMessage: "Invalid email")
                case .invalidPassword:
                    self.vc.loginDidFail(errorMessage: "Invalid password")
                case .wrongCredentials:
                    self.vc.loginDidFail(errorMessage: "Wrong credentials")
                }
            case .success(let token):
                UserDefaults.standard.set(token.authToken, forKey: "authToken")
                UserDefaults.standard.synchronize()
                self.vc.loginDidSucceed()
            
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
    fileprivate func performLogin(credentials: Credentials, completionHandler: @escaping (LoginResult) -> ()) {
        delay(2) {
            
            
            let results = LoginManager.validCredentials.filter({ validCredential -> Bool in
                return validCredential!.email == credentials.email && validCredential!.password == credentials.password
            })
            
            guard results.count > 0 else {
                completionHandler(.failure(.wrongCredentials))
                return
            }

            completionHandler(.success(Token(authToken: "7Peyw1k6hb")))
        }
    }
    
    private func delay(_ seconds: Int, completionHandler: @escaping () -> ()) {
        let deadlineTime = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            completionHandler()
        })
    }
}
