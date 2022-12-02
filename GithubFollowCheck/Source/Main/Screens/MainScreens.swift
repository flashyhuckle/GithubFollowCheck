import UIKit

struct MainScreens {
    func createMainViewController(
        didTapSearchButton: ((String) -> Void)?,
        didTapFavoritesButton: (() -> Void)?
    ) -> UIViewController {
        let viewModel: MainViewViewModel = .init(
            didTapSearchButton: didTapSearchButton,
            didTapFavoritesButton: didTapFavoritesButton
        )

        return MainViewController(
            viewModel: viewModel
        )
    }
}
