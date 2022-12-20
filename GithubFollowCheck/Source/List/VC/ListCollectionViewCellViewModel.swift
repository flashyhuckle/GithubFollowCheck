import UIKit

final class ListCollectionViewCellViewModel {
    
    // MARK: - Input
    let apiManager: ApiManagerInterface
    
    // MARK: - Output
    var didReceiveAvatar: ((UIImage?) -> Void)?
    
    // MARK: - Initialization
    init(
        apiManager: ApiManagerInterface
    ) {
        self.apiManager = apiManager
    }
    
    //MARK: - Lifecycle
    func getUserAvatar(user: User) {
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
