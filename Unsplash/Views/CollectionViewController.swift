//
//  CollectionViewController.swift
//  Unsplash
//
//  Created by LMinh on 4/24/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import UIKit
import TYPagerController

class CollectionViewController: TYTabPagerController {
    
    // MARK: - Properties
    
    var contentViewControllers: [UIViewController] = []
    var contentTitles: [String] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init content view controllers
        let downloadViewController = DownloadsViewController.instanceFromStoryboard
        downloadViewController.viewModel = DownloadsViewModel()
        downloadViewController.favoritesViewModel = FavoritesViewModel()
        
        let favoriteViewController = FavoritesViewController.instanceFromStoryboard
        favoriteViewController.viewModel = FavoritesViewModel()
        
        contentViewControllers = [downloadViewController, favoriteViewController]
        contentTitles = ["Download", "Favorite"]
        
        // UI Stuff
        setupUI()
    }
    
    // MARK: - UI Stuff
    
    func setupUI() {
        // Navigation Bar
        navigationController?.navigationBar.isHidden = true
        
        // Pager
        self.tabBar.layout.barStyle = TYPagerBarStyle.progressView
        self.tabBar.layout.normalTextFont = UIFont.systemFont(ofSize: 22, weight: .heavy)
        self.tabBar.layout.selectedTextFont = UIFont.systemFont(ofSize: 22, weight: .heavy)
        self.tabBar.layout.normalTextColor = .label
        self.tabBar.backgroundColor = .tertiarySystemBackground
        self.tabBar.layout.selectedTextColor = .systemPink
        self.tabBar.layout.progressHeight = 0
        self.tabBar.layout.cellSpacing = 0
        self.tabBar.layout.cellEdging = 0
        self.tabBarHeight = 50
        let topInset = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        self.tabBarOrignY = 45 + topInset
        self.pagerController.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.pagerController.view.backgroundColor = .clear
        self.view.backgroundColor = .systemBackground
        self.dataSource = self
        self.delegate = self
        self.tabBar.delegate = self
        self.reloadData()
    }
    
    // MARK: - Events
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Tab Pager

extension CollectionViewController: TYTabPagerControllerDataSource, TYTabPagerControllerDelegate, TYTabPagerBarDelegate {
    
    func numberOfControllersInTabPagerController() -> Int {
        return contentViewControllers.count
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let viewController = contentViewControllers[index]
        return viewController
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        let title = contentTitles[index]
        return title
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        return view.bounds.size.width/CGFloat(contentViewControllers.count)
    }
}

// MARK: Utils

extension CollectionViewController {
    static var instanceFromStoryboard: CollectionViewController {
        UIStoryboard.main.instantiateViewController(identifier: "collectionViewController") as! CollectionViewController
    }
}
