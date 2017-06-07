//
//  ReposViewController+TableViewDataSource.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import UIKit

extension ReposViewController: UITableViewDataSource {
    
    //The number of rows to populate the table view with
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedGitHubUser?.repos.count ?? 0
    }
}
