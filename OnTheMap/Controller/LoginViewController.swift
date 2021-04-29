//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 26/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var lodingActivity: UIActivityIndicatorView!
    @IBOutlet weak var loginFacebook: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func login(_ sender: UIButton) {
        print("aqi login")
        OTMUser.createSessionId(username: self.emailTextField.text ?? "",
                                password: self.passwordTextField.text ?? "",
                                completion: self.handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OTMUser.createSessionId(username: self.emailTextField.text ?? "",
                                           password: self.passwordTextField.text ?? "",
                                           completion: self.handleLoginResponse(success:error:))        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            print("aqui handleSession")
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
    }
}

