//
//  TabBarViewController.swift
//  MusicApp
//
//  Created by Frederic Rey Llanos on 19/05/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var favorites : [Int] = []
    var songsViewModel = SongsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setup()
    }
    
    private func setup() {
        self.favorites = self.songsViewModel.getAllIndex
        
        let homeVC = ViewController(viewModel: SongsViewModel())
        let favoriteVC = FavoritesViewController()
        
        homeVC.title = "Home"
        favoriteVC.title = "Favorites"
        
        self.setViewControllers([homeVC, favoriteVC], animated: false)
        self.modalPresentationStyle = .fullScreen
        
        guard let items = self.tabBar.items else { return }
        let imageNames = ["music.note.list", "heart.fill"]
        
        if self.favorites.count > 0 {
            items[1].isEnabled = true
        }
        if self.favorites.isEmpty {
            items[1].isEnabled = false
        }
        
        for i in 0...1 {
            items[i].image = UIImage(systemName: imageNames[i])
        }
    }
}
