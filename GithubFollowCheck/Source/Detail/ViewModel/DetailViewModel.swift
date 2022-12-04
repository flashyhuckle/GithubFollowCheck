import Foundation
import UIKit

final class DetailViewModel {
    
    //MARK: - Input
    
    let user: User
    private let apiManager: ApiManagerInterface
    
    //MARK: - Output
    
    var didReceiveAvatar: ((UIImage?) -> Void)?
    
    //MARK: - Initialization
    
    init(
        user: User,
        apiManager: ApiManagerInterface
    ) {
        self.user = user
        self.apiManager = apiManager
    }
    
    func getUserAvatar() {
        apiManager.getUserAvatar(urlString: user.avatarURL) { result in
            switch result {
            case .success(let avatar):
                self.didReceiveAvatar?(avatar)
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    
}
