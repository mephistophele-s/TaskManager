//
//  LoginViewController.swift
//  TaskManager
//
//  Created by Anastasia on 12.10.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import CryptoKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func login(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else { return }
        //TODO: cypher password
        authorizeUser(email: email, password: password)
    }
}

private extension LoginViewController {
        
    func authorizeUser(email: String, password: String) {
        
        guard isValidEmail(email) else {
            errorLabel.text = "E-mail is invalid"
            return
        }
    
        RegistrateUser(email: email, password: password).execute(onSuccess: { user in
            DataManager.instance.currentUser = user
            self.coordinator?.showTaskList()
        }) { _ in
            //TODO: process different type of errors
            LoginUser(email: email, password: password).execute(onSuccess: { user in
                DataManager.instance.currentUser = user
                self.coordinator?.showTaskList()
            }) { error in
                print("auth error: \(error)")
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
               "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
               "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
               "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
               "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
               "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
               "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
    }
}

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
