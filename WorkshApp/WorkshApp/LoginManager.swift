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

enum LoginError {
    case invalidEmail
    case invalidPassword
    case wrongCredentials
}

struct Token {
    let authToken: String
    init(_ authToken: String) {
        self.authToken = authToken
    }
}

class LoginManager {
    
    fileprivate static let validCredentials = [
        Credentials(email: "00_mickeymousse@napptilus.com", password: "Napptilus"),
        Credentials(email: "00_donaldduck@napptilus.com", password: "ItsATrump")
    ]
    
    struct Credentials {
        var email: String
        var password: String
        
        mutating func rectifyEmail() {
            email = "00_" + email
        }
        
        func rectifiedCredentials() -> Credentials {
            return Credentials(email: "00_" + email, password: password)
        }
    }
    
    weak var vc: ViewController!
    
    var credentials: Credentials?
    
    func login (email: String, password: String) {
        
        credentials = Credentials(email: email, password: password)
        guard let credentials = credentials else {
            fatalError("Credentials are not initialized")
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
                self.vc?.loginDidSucceed()
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
        let cred = credentials.rectifiedCredentials()
        
        guard cred.email.isValidEmail() else {
            completionHandler(.failure(.invalidEmail))
            return
        }
        guard cred.password.isValidPassword() else {
            completionHandler(.failure(.invalidPassword))
            return
        }
        
        delay(2) {
            let results = LoginManager.validCredentials.filter({ validCredential -> Bool in
                return validCredential.email == cred.email && validCredential.password == cred.password
            })
            
            guard results.count > 0 else {
                completionHandler(.failure(.wrongCredentials))
                return
            }

            completionHandler(.success(Token("7Peyw1k6hb")))
        }
    }
    
    private func delay(_ seconds: Int, completionHandler: @escaping () -> ()) {
        let deadlineTime = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            completionHandler()
        })
    }
}
