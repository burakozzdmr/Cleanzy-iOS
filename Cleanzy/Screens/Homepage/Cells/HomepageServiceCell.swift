//
//  HomepageServiceCell.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class HomepageServiceCell: UICollectionViewCell {
    static let reuseIdentifier = "HomepageServiceCell"

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

    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        view.layer.cornerRadius = 24
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .accent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
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

extension HomepageServiceCell {
    func configure(with item: HomepageServiceItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.displayName
        descriptionLabel.text = item.description
    }
}

// MARK: - Private Setup

private extension HomepageServiceCell {
    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubviews([iconContainerView, titleLabel, descriptionLabel])
        iconContainerView.addSubview(iconImageView)

        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        iconContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(22)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconContainerView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
