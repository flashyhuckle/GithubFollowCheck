import UIKit

final class ListCollectionViewCell: UICollectionViewCell {

    // MARK: - User Actions

    var onUserTap: (() -> Void)?

    // MARK: - Information Views

    private let mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.88)
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("NEWListCollectionViewCell doesn't support Interface Builder")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        avatarImageView.image = nil
    }

    // MARK: - Update
    
    func update(
        user: User,
        viewModel: ListCollectionViewCellViewModel
    ) {
        titleLabel.text = user.name
        viewModel.didReceiveAvatar = { [ weak self ] avatar in
                self?.avatarImageView.image = avatar
        }
        viewModel.getUserAvatar(user: user)
    }

    // MARK: - Setup

    private func setupLayout() {
        contentView.addSubview(mainContainerView)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10.0

        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        mainContainerView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 44.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44.0),
            avatarImageView.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor)
        ])

        mainContainerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: 10.0),
            titleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -10.0),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: mainContainerView.bottomAnchor, constant: -10.0)
        ])
    }
}

