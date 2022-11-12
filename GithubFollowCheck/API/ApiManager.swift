//
//  ApiManager.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import Foundation

protocol ApiManagerDelegate {
    func didReceiveResult(result: [Result])
    func didReceiveResultOfMany(result: [Result])
    func didFailWithError(error: Error)
}

struct ApiManager {
    
    var delegate: ApiManagerDelegate?
    
    let apiURL = "https://api.github.com/users/"
    let searchParameters = "/followers?per_page=100"
    
    func fetchData(username: String, page: Int = 0, getAll: Bool = false) {
        let urlString = apiURL + username + searchParameters + "&page=\(page)"
        performRequest(with: urlString, getAll: getAll)
    }
    
    func performRequest(with urlString: String, getAll: Bool = false) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
//                    fatalError()
                }
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([Result].self, from: data)
                        if getAll {
                            delegate?.didReceiveResultOfMany(result: decodedData)
                        } else {
                            delegate?.didReceiveResult(result: decodedData)
                        }
                    } catch {
                        delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
}

struct Result: Codable {
    let login: String
    let avatar_url: String
    let html_url: String
}

