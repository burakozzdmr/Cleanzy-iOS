//
//  ChatListCell.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.12.2025.
//

import SnapKit
import UIKit

final class ChatListCell: UITableViewCell {
    static let reuseIdentifier = "ChatListCell"

    // MARK: - Avatar

    private let avatarContainer: UIView = {
        let v = UIView()
        return v
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 28
        iv.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .accent
        return iv
    }()

    private let initialsLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .accent
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    private let onlineDot: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
        v.layer.cornerRadius = 6
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.white.cgColor
        v.isHidden = true
        return v
    }()

    // MARK: - Content

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = UIColor(red: 0.08, green: 0.10, blue: 0.15, alpha: 1.0)
        l.numberOfLines = 1
        return l
    }()

    private let lastMessageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor.systemGray
        l.numberOfLines = 1
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = UIColor.systemGray2
        return l
    }()

    private let unreadBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = .accent
        l.layer.cornerRadius = 11
        l.clipsToBounds = true
        l.isHidden = true
        return l
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1.0)
        return v
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension ChatListCell {
    func configure(with item: ChatItem) {
        nameLabel.text = item.userName
        lastMessageLabel.text = item.lastMessage
        timeLabel.text = item.time

        if let initials = item.groupInitials {
            initialsLabel.text = initials
            initialsLabel.isHidden = false
            avatarImageView.image = nil
            avatarImageView.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        } else {
            initialsLabel.isHidden = true
            avatarImageView.image = UIImage(systemName: "person.fill")
        }

        onlineDot.isHidden = !item.isOnline

        if item.unreadCount > 0 {
            unreadBadge.text = "\(item.unreadCount)"
            unreadBadge.isHidden = false
            timeLabel.textColor = .accent
        } else {
            unreadBadge.isHidden = true
            timeLabel.textColor = UIColor.systemGray2
        }
    }
}

// MARK: - Private Setup

private extension ChatListCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .white

        avatarContainer.addSubviews([avatarImageView, initialsLabel, onlineDot])
        contentView.addSubviews([avatarContainer, nameLabel, lastMessageLabel, timeLabel, unreadBadge, separator])

        avatarContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(56)
        }

        avatarImageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        initialsLabel.snp.makeConstraints { $0.edges.equalToSuperview() }

        onlineDot.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(-1)
            $0.width.height.equalTo(12)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(avatarContainer.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).offset(-8)
        }

        lastMessageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(avatarContainer.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(unreadBadge.snp.leading).offset(-8)
        }

        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(16)
        }

        unreadBadge.snp.makeConstraints {
            $0.centerY.equalTo(lastMessageLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(22)
        }

        separator.snp.makeConstraints {
            $0.leading.equalTo(avatarContainer.snp.trailing).offset(12)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
