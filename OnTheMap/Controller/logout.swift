//
//  logout.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 15/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//


import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OTMUser.logout(completion: handleLogoutResponse(boolean:error:))
    }
    
    func handleLogoutResponse(boolean: Bool, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}


