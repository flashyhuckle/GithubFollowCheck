import UIKit

struct FavoritesScreens {
    func createFavoritesViewController(didTapTableViewCell: ((String?) -> Void)?) -> FavoritesViewController {
        let viewModel = FavoritesViewModel(
            didTapTableViewCell: didTapTableViewCell)
        return FavoritesViewController(viewModel: viewModel)
    }
}
