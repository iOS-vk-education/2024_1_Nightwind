//
//  ViewController.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import UIKit

final class MainViewModel: UIViewController {
    @IBOutlet weak var jwtLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jwtLabel.isUserInteractionEnabled = false
        jwtLabel.text = userService.getJwt()
    }
    
    @IBAction func signOutTouchUpInside(_ sender: UIButton) {
        userService.logout()
        jwtLabel.text = nil
    }
}

