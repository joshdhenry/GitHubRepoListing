//
//  GitHubUser.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/24/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation

//A class to store all necessary info about a GitHub user
class GitHubUser {
    var name: String
    var reposURL: URL
    var repos: [Repo]
    
    init(name: String, reposURL: URL, repos: [Repo]) {
        self.name = name
        self.reposURL = reposURL
        self.repos = repos
    }
    
    convenience init(name: String, reposURL: URL) {
        self.init(name: name, reposURL: reposURL, repos: [Repo]())
    }
}
