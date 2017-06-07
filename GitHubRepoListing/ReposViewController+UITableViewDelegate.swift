//
//  ReposViewController+UITableViewDelegate.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import UIKit

extension ReposViewController: UITableViewDelegate {

    //Populate the tableview with a cell based on it's row index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        
        cell.repoNameLabel.text = self.selectedGitHubUser?.repos[indexPath.row].name
        
        if let stargazerCount: Int = self.selectedGitHubUser?.repos[indexPath.row].stargazerCount {
            cell.repoStargazersLabel.text = String(describing: stargazerCount)
        }
        
        return cell
    }
}
