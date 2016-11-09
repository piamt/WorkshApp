//
//  ViewController.swift
//  WorkshApp
//
//  Created by Pia Muñoz on 9/11/16.
//  Copyright © 2016 iOSWorkshops. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    private let loginManager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginManager.vc = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enter(_ sender: AnyObject) {
        guard let email = emailTextField.text, let pwd = pwdTextField.text else {
            return
        }
        
        if loginManager.login(user: email, password: pwd) {
            loginDidSucceed()
        } else {
            loginDidFail()
        }
        
    }
    
    func loginDidSucceed () {
        let alertController = UIAlertController(title: "Login succeeded", message: "Eres la caña 😎", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loginDidFail () {
        let alertController = UIAlertController(title: "Login failed", message: "Please insert correct credentials", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

