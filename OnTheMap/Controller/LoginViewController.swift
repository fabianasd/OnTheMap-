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
    
    @IBAction func loginTapped(_ sender: UIButton) {
        print("aqi login")
        setLoggingIn(true)
        OTMUser.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        print("handleLoginResponse")
        if success {
            OTMUser.createSessionId(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        print("aqui handleSessionResponse")
        setLoggingIn(false)
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
//        if loggingIn {
//            activityIndicator.startAnimating()
//        } else {
//            activityIndicator.stopAnimating()
//        }
        emailTextField.isEnabled = !loggingIn //o botão fica desabilitado
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    //    loginViaWebsiteButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) { //valida tentativa de login falha
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

