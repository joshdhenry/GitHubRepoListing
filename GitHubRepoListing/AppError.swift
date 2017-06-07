//
//  AppError.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/25/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation

public enum AppError: Error {
    case noData
    case badData
    case noResponse
    case badResponse
    case parseFailure
    case noKeys
    case noAccessToken
    case badAuthURL
    
    var description: String {
        switch self {
        case .noData:
            return "Error - Failed to download data from the API."
        case .badData:
            return "Error - Invalid data received from the API."
        case .noResponse:
            return "Error - No response received from the API."
        case .badResponse:
            return "Error - Unsuccessful HTTP response code received from the API."
        case .parseFailure:
            return "Error - Could not correctly parse data received from the API."
        case .noKeys:
            return "Error - No client ID or client secret provided."
        case .noAccessToken:
            return "Error - No access token retrieved from the API."
        case .badAuthURL:
            return "Error - Could not properly form the authentication URL. Aborting authentication."
        }
    }
}
