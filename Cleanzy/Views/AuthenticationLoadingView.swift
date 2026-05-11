//
//  AuthenticationLoadingView.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 10.11.2025.
//

import Lottie
import SnapKit
import UIKit

// MARK: - LoadingView

class AuthenticationLoadingView: UIView {
    
    // MARK: - Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let loadingIndicatorView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "LoadingAnimation")
        animationView.animationSpeed = 1
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Privates

private extension AuthenticationLoadingView {
    func addViews() {
        containerView.addSubview(loadingIndicatorView)
        self.addSubview(containerView)
    }
    
    func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(144)
        }
        
        loadingIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(containerView)
            $0.width.height.equalTo(144)
        }
    }
    
    func configureUI() {
        addViews()
        configureConstraints()
        
        self.backgroundColor = .black.withAlphaComponent(0.5)
    }
}

#Preview {
    AuthenticationLoadingView()
}
