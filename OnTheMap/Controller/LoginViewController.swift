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
    @IBOutlet weak var loginButton: UITextField!
    @IBOutlet weak var loginViaFacebook: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

