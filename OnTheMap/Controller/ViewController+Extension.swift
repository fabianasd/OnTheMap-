//
//  ViewController+Extension.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 07/07/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Show alerts
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
