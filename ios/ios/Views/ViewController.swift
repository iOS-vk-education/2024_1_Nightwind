//
//  UIViewController.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/8/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class ViewController: UIViewController, ObservableObject {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addView()
        if AppState.userService.getJwt() != nil {
           pushMainView()
        }
    }
    
    func addView() {
        let authView = AuthView()
        let controller = UIHostingController(rootView: authView.environmentObject(self))
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func pushMainView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            fatalError("MainViewController not found in Main storyboard.")
        }

        controller.root = self
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func popMainView() {
        self.navigationController?.popToRootViewController(animated: false)
    }
}

