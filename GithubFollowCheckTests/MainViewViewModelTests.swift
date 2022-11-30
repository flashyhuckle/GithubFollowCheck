import XCTest
@testable import GithubFollowCheck

final class MainViewViewModelTests: XCTestCase {

    // MARK: - Properties

    private var sut: MainViewViewModel!

    // MARK: - SetUp

    override func setUp() {
        super.setUp()
    }

    // MARK: - TearDown

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_WhenSearchButtonHasBeenPressed_ThenShouldCallAnAction() {
        let expectation = expectation(description: "Returned didTapSearchButton")
        let expectedText: String = "test-text"

        sut = MainViewViewModel(
            didTapSearchButton: { text in
                XCTAssertEqual(expectedText, "test-text")
                expectation.fulfill()
            },
            didTapFavoritesButton: nil
        )
        
        sut.onTapSearch(text: expectedText)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_WhenFavoritesButtonHasBeenPressed_ThenShouldCallAnAction() {
        let expectation = expectation(description: "Returned didTapFavoritesButton")

        sut = MainViewViewModel(
            didTapSearchButton: nil,
            didTapFavoritesButton: {
                expectation.fulfill()
            }
        )

        sut.onTapFavorites()

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
