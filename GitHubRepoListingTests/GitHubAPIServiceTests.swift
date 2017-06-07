//
//  GitHubAPIServiceTests.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import XCTest

@testable import GitHubRepoListing

class GitHubAPIServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testKeys() {
        let gitHubAPIService: GitHubAPIService = GitHubAPIService()
        
        let keys = gitHubAPIService.keys
        
        XCTAssertNotNil(keys, "API keys could not be retrieved from the plist.")
    }
    
}
