//
//  SplashViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 7.11.2025.
//

import Lottie
import SnapKit
import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: SplashPresenterProtocol!
    
    private let appLogoImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .init(named: "appLogo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let loadingAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "LoadingAnimation")
        animationView.animationSpeed = 1
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Privates

private extension SplashViewController {
    func setupUI() {
        addViews()
        configureLayout()
        
        view.backgroundColor = .white
    }
    
    func addViews() {
        view.addSubviews([
            appLogoImageView,
            loadingAnimationView
        ])
    }
    
    func configureLayout() {
        appLogoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(128)
        }
        
        loadingAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(192)
        }
    }
}

// MARK: - SplashViewProtocol

extension SplashViewController: SplashViewProtocol { }
