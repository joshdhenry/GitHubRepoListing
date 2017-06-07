//
//  GitHubSignInViewController.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/23/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import UIKit

class GitHubSignInViewController: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var signInWebView: UIWebView!
    
    public var gitHubSignInViewControllerDelegate: GitHubSignInViewControllerDelegate?
    internal let gitHubAPIService = GitHubAPIService()

    
    //MARK: - Methods
    
    //MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInWebView.delegate = self
        
        let clientID = gitHubAPIService.keys?["GitHubClientID"] as? String
        initiateGitHubAuthRequest(gitHubClientID: clientID)
    }
    
    
    //Load the GitHub sign-in screen into the webview and begin authentication
    private func initiateGitHubAuthRequest(gitHubClientID: String?) {
        guard let clientID: String = gitHubClientID else {
            self.presentErrorAlert(errorMessage: AppError.noKeys.description)
                return
        }
        
        let authURLString = GitHubAPIService.authBaseURLString + clientID
        
        guard let authURL = URL(string: authURLString) else {
            self.presentErrorAlert(errorMessage: AppError.badAuthURL.description)
            return
        }
        
        let authURLRequest = URLRequest(url: authURL)
        signInWebView.loadRequest(authURLRequest)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
