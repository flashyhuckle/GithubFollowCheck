import Foundation

final class FavoritesViewModel {
 
    // MARK: - Input

    private let userDefaults: UserDefaults = .standard
    private let didTapTableViewCell: ((String) -> Void)?

    // MARK: - Initialization

    init(
        didTapTableViewCell: ((String) -> Void)?
    ) {
        self.didTapTableViewCell = didTapTableViewCell
    }

    func getFavoriteUsers(
        forKey: String
    ) -> [String] {
        guard let favoriteUsers = userDefaults.array(forKey: forKey) as? [String] else { return [] }
        return favoriteUsers
    }

    func onTapTableViewCell(user: String) {
        didTapTableViewCell?(user)
    }
}
