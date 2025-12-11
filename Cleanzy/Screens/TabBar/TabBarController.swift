//
//  TabBarController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
}

// MARK: - Privates

private extension TabBarController {
    func setupTabBar() {
        let homepageVC = createNavigationController(
            with: "Anasayfa",
            and: "house",
            from: HomepageBuilder.createModule()
        )
        let chatVC = createNavigationController(
            with: "Sohbet",
            and: "bubble.left.and.bubble.right",
            from: ChatBuilder.createModule()
        )
        let favoritesVC = createNavigationController(
            with: "Favoriler",
            and: "heart",
            from: FavoritesBuilder.createModule()
        )
        let profileVC = createNavigationController(
            with: "Profil",
            and: "person",
            from: ProfileBuilder.createModule()
        )
        
        self.setViewControllers([homepageVC, chatVC, favoritesVC, profileVC], animated: false)
        
        self.tabBar.backgroundColor = .accent
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .lightGray
    }
    
    func createNavigationController(
        with title: String,
        and imagePath: String,
        from viewController: UIViewController
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imagePath)
        
        navController.tabBarItem.selectedImage = UIImage(
            systemName: imagePath.contains(".fill") ? imagePath : "\(imagePath).fill"
        )
        
        navigationItem.hidesBackButton = true
        return navController
    }
}
