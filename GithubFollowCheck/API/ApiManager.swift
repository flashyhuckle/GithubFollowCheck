import Foundation
import UIKit

protocol ApiManagerInterface {
    func fetchData(
        username: String,
        page: Int,
        onCompletion: @escaping ((Swift.Result<[UserDTO], Error>) -> Void)
    )
    func getUserAvatar(
        urlString: String,
        onCompletion: @escaping ((Swift.Result<UIImage, Error>) -> Void)
    )
}

struct NEWApiManager: ApiManagerInterface {

    let apiURL = "https://api.github.com/users/"
    let searchParameters = "/followers?per_page=100"

    func fetchData(
        username: String,
        page: Int,
        onCompletion: @escaping ((Swift.Result<[UserDTO], Error>) -> Void)
    ) {
        let urlString = apiURL + username + searchParameters + "&page=\(page)"
        performRequest(with: urlString) { result in
            onCompletion(result)
        }
    }

    private func performRequest(
        with urlString: String,
        onCompletion: @escaping ((Swift.Result<[UserDTO], Error>) -> Void)
    ) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in

                if let data = data {
                    do {
                            let decodedData = try JSONDecoder().decode([UserDTO].self, from: data)
                        onCompletion(.success(decodedData))
                    } catch {
                        onCompletion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    func getUserAvatar(
        urlString: String,
        onCompletion: @escaping ((Swift.Result<UIImage, Error>) -> Void)
    ) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    onCompletion(.success(UIImage(data: data)!))
                } else {
                    onCompletion(.failure(error!))
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
