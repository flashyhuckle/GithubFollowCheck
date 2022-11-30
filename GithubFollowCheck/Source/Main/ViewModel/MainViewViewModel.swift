import Foundation

final class MainViewViewModel {

    private let didTapSearchButton: ((String) -> Void)?
    private let didTapFavoritesButton: (() -> Void)?

    init(
        didTapSearchButton: ((String) -> Void)?,
        didTapFavoritesButton: (() -> Void)?
    ) {
        self.didTapSearchButton = didTapSearchButton
        self.didTapFavoritesButton = didTapFavoritesButton
    }

    func onTapSearch(text: String?) {
        guard let text else { return }
        didTapSearchButton?(text)
    }

    func onTapFavorites() {
        didTapFavoritesButton?()
    }
}
