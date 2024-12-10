//
//  ViewController.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, ObservableObject {
    weak var root: ViewController?
    
    @IBOutlet weak var jwtLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let userService = AppState.userService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        if let navigationController = navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        jwtLabel.isUserInteractionEnabled = false
        jwtLabel.text = userService.getJwt()
    }

    @IBAction func signOutTouchUpInside(_ sender: UIButton) {
        userService.logout()
        jwtLabel.text = nil
        root?.popMainView()
    }
}

