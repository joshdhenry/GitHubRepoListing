//
//  ReposViewController+GitHubSignInViewControllerDelegate.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import UIKit

extension ReposViewController: GitHubSignInViewControllerDelegate {

    //Send user information back from the GitHubSignInViewController
    public func sendGitHubUser(passedGitHubUser: GitHubUser?) {
        selectedGitHubUser = passedGitHubUser
    }
}
