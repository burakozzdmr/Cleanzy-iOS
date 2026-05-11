//
//  SendCodeViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 14.11.2025.
//

import Lottie
import SnapKit
import UIKit

final class SendCodeViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: SendCodePresenterProtocol!
    
    private let checkmarkAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "CheckmarkAnimation")
        animationView.animationSpeed = 0.75
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        return animationView
    }()
    
    private let successSendCodeLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "İşlem Başarılı"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let successSendDescriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi. Lütfen gelen kutunuzu kontrol edin."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("Giriş Yap", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .accent
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - Objective-C Methods

@objc private extension SendCodeViewController {
    func loginTapped() {
        presenter.didLoginTapped()
    }
}

// MARK: - Privates

private extension SendCodeViewController {
    func setupUI() {
        addViews()
        configureLayout()
        
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    func addViews() {
        view.addSubviews([
            checkmarkAnimationView,
            successSendCodeLabel,
            successSendDescriptionLabel,
            loginButton
        ])
    }
    
    func configureLayout() {
        checkmarkAnimationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(128)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(256)
        }
        
        successSendCodeLabel.snp.makeConstraints {
            $0.top.equalTo(checkmarkAnimationView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        successSendDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(successSendCodeLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.equalTo(360)
            $0.height.equalTo(56)
        }
    }
}

extension SendCodeViewController: SendCodeViewProtocol { }

#Preview {
    SendCodeViewController()
}
