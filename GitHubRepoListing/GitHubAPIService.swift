//
//  GitHubAPIService.swift
//  GitHubRepoListing
//
//  Created by Josh Henry on 5/24/17.
//  Copyright © 2017 Big Smash Software. All rights reserved.
//

import Foundation
import SwiftyJSON

class GitHubAPIService {
    
    //MARK: - Properties

    public static let authBaseURLString: String = "https://github.com/login/oauth/authorize?client_id="
    public static let callBackURLString: String = "www.example.com"
    private static let accessTokenURL: URL = URL(string: "https://github.com/login/oauth/access_token")!
    private static let userURL: URL = URL(string: "https://api.github.com/user")!
    
    //Fetch the keys from APIKeys.plist
    public var keys: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }
    
    
    //MARK: - Methods

    //Exchange the code received for an access token, needed for authentication
    public func getAccessToken(codeString: String, completion: @escaping (_ result: Bool, _ accessToken: String?, _ error: AppError?)->()) {
        guard let clientID = keys?["GitHubClientID"], let clientSecret = keys?["GitHubClientSecret"] else {
            completion(true, nil, AppError.noKeys)
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: GitHubAPIService.accessTokenURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let httpBodyJSON = [
            "client_id" : clientID,
            "client_secret" : clientSecret,
            "code" : codeString
        ]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: httpBodyJSON, options: [])
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            do {
                try self.validateDataTaskResults(data: data, response: response, error: error)
            }
            catch {
                completion(true, nil, error as? AppError)
                return
            }
            
            if let _ = String(data: data!, encoding: String.Encoding.utf8) {
                let json: JSON = JSON(data: data!)
                
                guard json["access_token"].exists() else {
                    completion(true, nil, AppError.noAccessToken)
                    return
                }
                
                let accessToken: String = json["access_token"].stringValue
                
                completion(true, accessToken, nil)
                return
            }
            else {
                completion(true, nil, AppError.badData)
                return
            }
        }).resume()
    }
    
    
    //Fetch GitHub user information from the API
    public func fetchGitHubUser(_ accessToken: String, completion: @escaping (_ result: Bool, _ gitHubUser: GitHubUser?, _ error: AppError?)->()) {
        var urlRequest = URLRequest(url: GitHubAPIService.userURL)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            do {
                try self.validateDataTaskResults(data: data, response: response, error: error)
            }
            catch {
                completion(true, nil, error as? AppError)
                return
            }
            
            if let _ = String(data: data!, encoding: String.Encoding.utf8) {
                let json: JSON = JSON(data: data!)
                
                guard let name: String = json["name"].string, let reposURL = URL(string: json["repos_url"].string!) else {
                    completion(true, nil, AppError.badData)
                    return
                }
                
                let gitHubUser: GitHubUser = GitHubUser(name: name, reposURL: reposURL)

                completion(true, gitHubUser, nil)
            }
            else {
                completion(true, nil, AppError.badData)
                return
            }
        }).resume()
    }
    
    
    //Fetch the authenticated user's repos
    public func fetchRepos(_ gitHubUser: GitHubUser, completion: @escaping (_ result: Bool, _ gitHubUserRepos: [Repo]?, _ error: AppError?)->()) {
        let url: URL = gitHubUser.reposURL
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            do {
                try self.validateDataTaskResults(data: data, response: response, error: error)
            }
            catch {
                completion(true, nil, error as? AppError)
                return
            }
            
            if let _ = String(data: data!, encoding: String.Encoding.utf8) {
                let json = JSON(data: data!)
                
                var repoArray = [Repo]()
                
                for repoIndex in 0..<json.count {
                    let name = json[repoIndex]["name"].stringValue
                    let stargazersCount = json[repoIndex]["stargazers_count"].intValue
                    let repo: Repo = Repo(name: name, stargazerCount: stargazersCount)
                    
                    repoArray.append(repo)
                }

                completion(true, repoArray, nil)
            }
            else {
                completion(true, nil, AppError.badData)
                return
            }
        }).resume()
    }
    
    
    //Ensure a session's dataTask response isn't an error
    private func validateDataTaskResults(data: Data?, response: URLResponse?, error: Error?) throws {
        //Ensure data is received
        guard (error == nil && data != nil) else {
            throw AppError.noData
        }
        
        //Ensure an HTTP response is received
        guard let thisURLResponse = response as? HTTPURLResponse else {
            throw AppError.noResponse
        }
        
        //Ensure the HTTP response is successful (Code: 200)
        guard thisURLResponse.statusCode == 200 else {
            throw AppError.badResponse
        }
    }
}
