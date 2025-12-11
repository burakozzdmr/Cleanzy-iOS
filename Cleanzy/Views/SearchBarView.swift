//
//  SearchBarView.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import SnapKit
import UIKit

class SearchBarView: UIView {
    
    private let containerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .lightGray.withAlphaComponent(0.25)
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Müşteri veya temizlik personeli ara"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Privates

private extension SearchBarView {
    func setupUI() {
        addViews()
        configureLayout()
    }
    
    func addViews() {
        self.addSubview(containerView)
        containerView.addSubview(searchIconImageView)
        containerView.addSubview(placeholderLabel)
    }
    
    func configureLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchIconImageView.snp.trailing).offset(12)
        }
    }
}

#Preview {
    SearchBarView()
}
