//
//  UIViewController+ErrorAlert.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Display a UI alert given an error message
    func presentErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
