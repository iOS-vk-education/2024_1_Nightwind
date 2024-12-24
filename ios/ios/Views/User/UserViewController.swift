//
//  UserViewController.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 24.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    private let userService: UserService
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let creationTimeLabel = UILabel()
    private let signOutButton = UIButton(type: .system)

    init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchUserInfo()
    }

    private func setupUI() {
        // Name label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Login label
        loginLabel.font = UIFont.systemFont(ofSize: 18)
        loginLabel.textAlignment = .center
        loginLabel.translatesAutoresizingMaskIntoConstraints = false

        // Creation time label
        creationTimeLabel.font = UIFont.systemFont(ofSize: 14)
        creationTimeLabel.textColor = .gray
        creationTimeLabel.textAlignment = .center
        creationTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Sign-out button
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.backgroundColor = .systemRed
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.cornerRadius = 8
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)

        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(creationTimeLabel)
        view.addSubview(signOutButton)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            creationTimeLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            creationTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            creationTimeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            signOutButton.topAnchor.constraint(equalTo: creationTimeLabel.bottomAnchor, constant: 32),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant: 150),
            signOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func fetchUserInfo() {
        Task {
            do {
                let user = try await userService.getUser()
                updateUI(with: user)
            } catch {
                // Handle error (e.g., show an alert)
                print("Failed to fetch user info: \(error)")
            }
        }
    }

    private func updateUI(with user: User) {
        nameLabel.text = user.name
        loginLabel.text = "@" + user.login
        creationTimeLabel.text = "Joined: " + user.creationTime.formattedDate()
    }

    @objc private func signOut() {
        userService.logout()
        navigationController?.popToRootViewController(animated: true)
    }
}
