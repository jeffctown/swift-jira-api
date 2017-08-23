//
//  JiraApi.swift
//  Jira
//
//  Created by Lett, Jeff on 8/23/17.
//  Copyright © 2017 Jeff Lett. All rights reserved.
//

import Foundation

public class Jira {
    
    public static var loggingEnabled = false
    
    public enum JiraError: Error {
        case unableToCreateURL
    }
    
    /** Gets Info From the Jira API 
     *
     *
     */
    public func search(host: String, jql: String, completion: @escaping (Data?, Error?) -> Void) throws {
        
        if Jira.loggingEnabled {
            print("*** Constructing Jira URL.")
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.path = "/rest/api/2/search"
        let jql = URLQueryItem(name: "jql", value: jql)
        urlComponents.queryItems = [jql]
        guard let url = urlComponents.url else {
            if Jira.loggingEnabled {
                print("*** I couldn't create a Jira URL!")
            }
            throw JiraError.unableToCreateURL
        }
        
        if Jira.loggingEnabled {
            print("*** Done Constructing Jira URL: \(url.absoluteString)")
        }
        
        //http://tickets.turner.com/rest/api/2/search?jql=project%3DCNNIOSMAR+AND+status%3DQA+AND+updated%3E%27-16h%27+ORDER+BY+updated+DESC
        
        print("*** Sending Request To Jira.")
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
        urlSession.dataTask(with: url) { (data, response, error) in
            if Jira.loggingEnabled {
                print("*** Done Sending Request To Jira.")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if Jira.loggingEnabled {
                    print("*** Response Code: \(httpResponse.statusCode)")
                }
            }
            
            if let error = error {
                if Jira.loggingEnabled {
                    print("*** Error encountered: \(error)")
                }
                completion(nil, error)
                return
            }
            
            completion(data, nil)
            
            
        }.resume()
    }
    
}
