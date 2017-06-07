//
//  ReposViewController.swift
//  GitHubRepoListing
//
//  Created by Darren Lai on 5/17/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var repoTableView: UITableView!
    
    internal var selectedGitHubUser: GitHubUser?
    lazy var gitHubAPIService: GitHubAPIService = GitHubAPIService()
    
    
    //MARK: - Methods
    
    //MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTableView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user: GitHubUser = selectedGitHubUser else {
            return
        }
        
        displayRepos(user: user)
        
        self.navigationItem.title = user.name + "'s Repos"
    }
    
    
    //If segueing to the GitHub sign-in screen, set this view controller as it's gitHubSignInViewControllerDelegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueGitHubSignIn" {
            let segueViewController = segue.destination as! GitHubSignInViewController
            segueViewController.gitHubSignInViewControllerDelegate = self
        }
    }
    
    
    //MARK: Other Methods
    
    //If the user taps the "Fetch Repos" button
    @IBAction func fetchButtonTapped(_ sender: Any) {
        //If the user hasn't signed in, take them to the GitHub sign-in screen
        guard let user: GitHubUser = selectedGitHubUser else {
            performSegue(withIdentifier: "segueGitHubSignIn", sender: self)
            return
        }
        
        displayRepos(user: user)
    }
    
    
    //Fetch repos for the selected user and populate the table view
    private func displayRepos(user: GitHubUser) {
        gitHubAPIService.fetchRepos(user) { (isReposFound, gitHubRepos, error) -> () in
            if let e: AppError = error {
                self.presentErrorAlert(errorMessage: e.description)
            }
            if isReposFound {
                guard let retrievedRepos: [Repo] = gitHubRepos else {
                    return
                }
                user.repos = retrievedRepos
                
                DispatchQueue.main.async {
                    self.repoTableView.reloadData()
                }
            }
        }
    }
}

