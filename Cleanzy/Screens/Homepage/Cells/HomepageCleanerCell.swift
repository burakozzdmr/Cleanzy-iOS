//
//  HomepageCleanerCell.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class HomepageCleanerCell: UICollectionViewCell {
    static let reuseIdentifier = "HomepageCleanerCell"

    // MARK: - UI Components

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.07
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28
        imageView.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .accent
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(red: 1.0, green: 0.75, blue: 0.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let hourlyRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .accent
        return label
    }()

    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension HomepageCleanerCell {
    func configure(with item: HomepageCleanerItem) {
        nameLabel.text = item.fullName
        ratingLabel.text = String(format: "%.1f", item.rating)
        reviewCountLabel.text = "(\(item.totalReviews) Değerlendirme)"
        hourlyRateLabel.text = "₺\(Int(item.hourlyRate))/saat"
    }

    func configure(with item: FavoriteItem) {
        nameLabel.text = item.fullName
        ratingLabel.text = String(format: "%.1f", item.rating)
        reviewCountLabel.text = "(\(item.totalReviews) Değerlendirme)"
        hourlyRateLabel.text = "₺\(Int(item.hourlyRate))/saat"
    }
}

// MARK: - Private Setup

private extension HomepageCleanerCell {
    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubviews([avatarImageView, infoStackView, hourlyRateLabel])

        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewCountLabel)

        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(ratingStackView)

        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(56)
        }

        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(hourlyRateLabel.snp.leading).offset(-8)
        }

        starImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }

        hourlyRateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
