//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 26/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var lodingActivity: UIActivityIndicatorView!
    @IBOutlet weak var textView: UITextView!
    
        override func viewDidLoad() {
            let attributedString = NSMutableAttributedString(string: "Don`t have an account? Sign Up")
            attributedString.addAttribute(.link, value: "https://www.udacity.com", range: NSRange(location: 22, length: 8))

            textView.attributedText = attributedString
            textView.textAlignment = .center
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
        }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OTMUser.createSessionId(
            username: self.emailTextField.text ?? "",
            password: self.passwordTextField.text! ?? "",
            completion: handleSessionResponse(sessionResponse:error:))
    }
    
        func handleGetUserResponse(getUserResponse: GetUserResponse?, error: Error?) {
            print("handleLoginResponse")
        }
    
    func handleSessionResponse(sessionResponse: SessionResponse?, error: Error?) {
        setLoggingIn(false)
        if sessionResponse?.error == nil && sessionResponse != nil {
            UserModel.session = sessionResponse!
            OTMUser.key = (sessionResponse?.account?.key!)!
            OTMUser.getUser(completion: handleGetUserResponse(getUserResponse:error:))
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
            showLoginFailure(message: (sessionResponse?.error ?? error?.localizedDescription) ?? "")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            lodingActivity.startAnimating()
        } else {
            lodingActivity.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn //o botão fica desabilitado
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) { //valida tentativa de login falha
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

