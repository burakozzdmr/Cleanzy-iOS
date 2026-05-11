//
//  HomepageSectionHeaderView.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class HomepageSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HomepageSectionHeaderView"

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.isHidden = true
        return button
    }()

    var onActionTapped: (() -> Void)?

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

extension HomepageSectionHeaderView {
    func configure(title: String, actionTitle: String? = nil) {
        titleLabel.text = title
        if let actionTitle {
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }
}

// MARK: - Private Setup

private extension HomepageSectionHeaderView {
    func setupUI() {
        addSubviews([titleLabel, actionButton])

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        onActionTapped?()
    }
}
