//
//  TabBarViewController.swift
//  Nightwind
//
//  Created by Патрушева Анна Алексеевна on 19.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    private let userService: UserService
    private let postService: PostService
    private let discussionService: DiscussionService
    private let voteService: VoteService

    weak var root: ViewController?
    
    init(userService: UserService, postService: PostService, discussionService: DiscussionService, voteService: VoteService) {
        self.userService = userService
        self.postService = postService
        self.discussionService = discussionService
        self.voteService = voteService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppereance()
        generateTabBar()
    }
    
    
    private func generateTabBar() {
        viewControllers = [
            generateViewController(
                viewController: UINavigationController(rootViewController:
                    MainViewController(userService: userService, postService: postService, discussionService: discussionService, voteService: voteService)),
                title: "Posts",
                image: UIImage(systemName: "list.bullet.clipboard")),
            generateViewController(
                viewController: UINavigationController(rootViewController:
                                                        WritePostViewController(userService: userService, postService: postService, voteService: voteService, discussionService: discussionService)),
                title: "Write Post",
                image: UIImage(systemName: "square.and.pencil")),
            generateViewController(
                viewController: UINavigationController(rootViewController:
                    UserViewController(userService: userService)),
                title: "User",
                image: UIImage(systemName: "person.crop.circle")
            )
        ]
    }
    
    
    private func generateViewController(viewController: UIViewController, title: String, image: UIImage?) ->
    UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setAppereance() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor(Styles.Light.tetriaryBase)
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.black
    }
}


                
