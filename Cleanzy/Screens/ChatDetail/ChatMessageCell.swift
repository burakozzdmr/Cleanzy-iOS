//
//  ChatMessageCell.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import SnapKit
import UIKit

// MARK: - ChatMessageCell

final class ChatMessageCell: UITableViewCell {
    static let reuseIdentifier = "ChatMessageCell"

    // MARK: - Avatar (received only)

    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .accent
        return iv
    }()

    // MARK: - Bubble

    private let bubbleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 18
        return v
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.numberOfLines = 0
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .regular)
        l.textColor = UIColor.systemGray3
        return l
    }()

    private let readReceiptView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.message.fill")
        iv.tintColor = .white.withAlphaComponent(0.7)
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()

    // MARK: - Date Separator

    private let dateSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.88, green: 0.89, blue: 0.91, alpha: 1.0)
        v.layer.cornerRadius = 12
        v.isHidden = true
        return v
    }()

    private let dateSeparatorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = UIColor(red: 0.40, green: 0.44, blue: 0.52, alpha: 1.0)
        l.textAlignment = .center
        return l
    }()

    // MARK: - Constraints

    private var bubbleLeading: Constraint?
    private var bubbleTrailing: Constraint?

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

extension ChatMessageCell {
    func configure(with item: ChatMessageItem) {
        if item.isDateSeparator {
            showDateSeparator(text: item.dateText ?? item.text)
            return
        }
        hideDateSeparator()
        messageLabel.text = item.text
        timeLabel.text = item.time

        if item.isSentByMe {
            configureSent()
        } else {
            configureReceived()
        }
    }
}

// MARK: - Private

private extension ChatMessageCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        dateSeparatorView.addSubview(dateSeparatorLabel)
        bubbleView.addSubviews([messageLabel, timeLabel, readReceiptView])
        contentView.addSubviews([dateSeparatorView, avatarView, bubbleView])

        dateSeparatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(26)
        }

        dateSeparatorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(14)
        }

        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalTo(bubbleView)
            $0.width.height.equalTo(32)
        }

        bubbleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().inset(4)
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.72)
        }

        let leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8)
        leadingConstraint.isActive = false
        bubbleLeading = nil

        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(14)
        }

        timeLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }

        readReceiptView.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-4)
            $0.width.height.equalTo(14)
        }
    }

    func configureSent() {
        bubbleView.backgroundColor = .accent
        messageLabel.textColor = .white
        timeLabel.textColor = .white.withAlphaComponent(0.7)
        readReceiptView.isHidden = false
        avatarView.isHidden = true

        bubbleView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.72)
        }
    }

    func configureReceived() {
        bubbleView.backgroundColor = .white
        bubbleView.layer.shadowColor = UIColor.black.cgColor
        bubbleView.layer.shadowOpacity = 0.06
        bubbleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bubbleView.layer.shadowRadius = 4
        messageLabel.textColor = UIColor(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)
        timeLabel.textColor = UIColor.systemGray3
        readReceiptView.isHidden = true
        avatarView.isHidden = false

        bubbleView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.equalTo(avatarView.snp.trailing).offset(8)
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.72)
        }
    }

    func showDateSeparator(text: String) {
        dateSeparatorLabel.text = text
        dateSeparatorView.isHidden = false
        bubbleView.isHidden = true
        avatarView.isHidden = true
    }

    func hideDateSeparator() {
        dateSeparatorView.isHidden = true
        bubbleView.isHidden = false
    }
}
