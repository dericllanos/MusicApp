//
//  TabBarViewController.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        let homeVC = ViewController(viewModel: SongsViewModel() as SongsViewModelType)
        let favoriteVC = FavoritesViewController()
        
        homeVC.title = "Home"
        favoriteVC.title = "Favorites"
        
        self.setViewControllers([homeVC, favoriteVC], animated: false)
        self.modalPresentationStyle = .fullScreen
        
        guard let items = self.tabBar.items else { return }
        let imageNames = ["music.note.list", "heart.fill"]
        
        for i in 0...1 {
            items[i].image = UIImage(systemName: imageNames[i])
        }
    }
}
