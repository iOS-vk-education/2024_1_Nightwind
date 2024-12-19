//
//  TabBarViewController.swift
//  Nightwind
//
//  Created by Патрушева Анна Алексеевна on 19.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    weak var root: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppereance()
        generateTabBar()
    }
    
    
    private func generateTabBar() {
        
        viewControllers = [
            generateViewController(
                viewController: MainViewController(),
                title: "Posts",
                image: UIImage(systemName: "list.bullet.clipboard")),
            generateViewController(
                viewController: WritePostViewController(),
                title: "Write Post",
                image: UIImage(systemName: "square.and.pencil"))
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

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

                
