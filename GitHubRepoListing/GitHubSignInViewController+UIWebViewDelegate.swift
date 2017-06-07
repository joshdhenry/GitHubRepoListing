//
//  GitHubSignInViewController+UIWebViewDelegate.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension GitHubSignInViewController: UIWebViewDelegate {

    //MARK: UIWebView Methods

    //Perform GitHub sign-in authentication in the webview.
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, url.host == GitHubAPIService.callBackURLString {
            if let codeString = url.query?.components(separatedBy: "code=").last {
                //After receiving the code from the API, exchange it for an access token
                self.gitHubAPIService.getAccessToken(codeString: codeString) { (isAccessTokenReceived, accessToken, error) -> () in
                    if let e: AppError = error {
                        self.presentErrorAlert(errorMessage: e.description)
                        
                        DispatchQueue.main.async {
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                    else if isAccessTokenReceived {
                        if accessToken != nil {
                            self.gitHubAPIService.fetchGitHubUser(accessToken!) { (isUserFound, gitHubUser, error) -> () in
                                if let e: AppError = error {
                                    self.presentErrorAlert(errorMessage: e.description)
                                    
                                    DispatchQueue.main.async {
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                    }
                                }
                                //Success. Send the GitHub user's information back to ReposViewController
                                else if isUserFound {
                                    if let user: GitHubUser = gitHubUser {
                                        self.gitHubSignInViewControllerDelegate?.sendGitHubUser(passedGitHubUser: user)
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        else {
                            self.gitHubSignInViewControllerDelegate?.sendGitHubUser(passedGitHubUser: nil)
                            
                            DispatchQueue.main.async {
                                self.presentingViewController?.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            return false
        }
        return true
    }
}
