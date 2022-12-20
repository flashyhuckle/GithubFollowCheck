import Foundation

final class FavoritesViewModel {
 
    // MARK: - Input

    private let userDefaults: UserDefaults = .standard
    private let didTapTableViewCell: ((String) -> Void)?
    
    //MARK: - Output
    
    var didReceiveFavoriteUsers: (([String]) -> Void)?

    // MARK: - Initialization

    init(
        didTapTableViewCell: ((String) -> Void)?
    ) {
        self.didTapTableViewCell = didTapTableViewCell
    }
    
    //MARK: - Lifecycle
    func viewWillAppear() {
        getFavoriteUsers()
    }

    private func getFavoriteUsers(
    ) {
        guard let favoriteUsers = userDefaults.array(forKey: "favoriteUsers") as? [String] else { return }
        didReceiveFavoriteUsers?(favoriteUsers)
    }

    func onTapTableViewCell(user: String) {
        didTapTableViewCell?(user)
    }
}
