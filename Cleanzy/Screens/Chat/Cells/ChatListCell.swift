//
//  ChatListCell.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.12.2025.
//

import SnapKit
import UIKit

class ChatListCell: UITableViewCell {

    // MARK: - Properties
    
    private let userPhotoImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .init(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let lastMessageLabel: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let chatDateTimeLabel: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let messageCountLabel: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .bold)
        return label
    }()
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Publics
    
    func configure(with userModel: UserModel) {
        
    }
}

// MARK: - Privates

private extension ChatListCell {
    func setupUI() {
        addViews()
        configureLayout()
    }
    
    func addViews() {
        contentView.addSubviews([
            userPhotoImageView,
            userNameLabel,
            lastMessageLabel,
            chatDateTimeLabel,
            messageCountLabel
        ])
    }
    
    func configureLayout() {
        userPhotoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(64)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(userPhotoImageView.snp.trailing).offset(16)
        }
        
        lastMessageLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(userPhotoImageView.snp.trailing).offset(16)
        }
        
        chatDateTimeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        messageCountLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
}
