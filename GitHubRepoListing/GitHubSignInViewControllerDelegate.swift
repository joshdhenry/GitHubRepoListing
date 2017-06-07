//
//  GitHubSignInViewControllerDelegate.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/24/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation

//A protocol to send a GitHub user's information back after authenticating
protocol GitHubSignInViewControllerDelegate {
    func sendGitHubUser(passedGitHubUser: GitHubUser?)
}
