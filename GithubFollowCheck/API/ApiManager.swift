//
//  ApiManager.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import Foundation

//protocol ApiManagerDelegate {
//    func didReceiveResult(result: [ChujowyResult])
//    func didReceiveResultOfMany(result: [ChujowyResult])
//    func didFailWithError(error: Error)
//}

//struct ApiManager {
//
//    var delegate: ApiManagerDelegate?
//
//    let apiURL = "https://api.github.com/users/"
//    let searchParameters = "/followers?per_page=100"
//
//    func fetchData(username: String, page: Int = 0, getAll: Bool = false) {
//        let urlString = apiURL + username + searchParameters + "&page=\(page)"
//        performRequest(with: urlString, getAll: getAll)
//    }
//
//    func performRequest(with urlString: String, getAll: Bool = false) {
//        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { data, response, error in
//                if error != nil {
////                    fatalError()
//                }
//                if let data = data {
//                    do {
//                        let decodedData = try JSONDecoder().decode([ChujowyResult].self, from: data)
//                        if getAll {
//                            delegate?.didReceiveResultOfMany(result: decodedData)
//                        } else {
//                            delegate?.didReceiveResult(result: decodedData)
//                        }
//                    } catch {
//                        delegate?.didFailWithError(error: error)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//}
//
//struct ChujowyResult: Codable {
//    let login: String
//    let avatar_url: String
//    let html_url: String
//}

protocol ApiManagerInterface {
    func fetchData(
        username: String,
        page: Int,
        getAll: Bool,
        onCompletion: @escaping ((Swift.Result<[UserDTO], Error>) -> Void)
    )
}

struct NEWApiManager: ApiManagerInterface {

    let apiURL = "https://api.github.com/users/"
    let searchParameters = "/followers?per_page=100"

    func fetchData(
        username: String,
        page: Int,
        getAll: Bool,
        onCompletion: @escaping ((Swift.Result<[UserDTO], Error>) -> Void)
    ) {
        let urlString = apiURL + username + searchParameters + "&page=\(page)"
        performRequest(with: urlString) { result in
            onCompletion(result)
        }
    }

    private func performRequest(
        with urlString: String,
        getAll: Bool = false,
        onCompletion: @escaping ((Swift.Result<[UserDTO], Error>) -> Void)
    ) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in

                if let data = data {
                    do {
                            let decodedData = try JSONDecoder().decode([UserDTO].self, from: data)
                        if getAll {
                            onCompletion(.success(decodedData))
                        } else {
                            onCompletion(.success(decodedData))
                        }
                    } catch {
                        onCompletion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}

struct UserDTO: Codable {
    let login: String
    let avatar_url: String
    let html_url: String
}
