//
//  PostViewController.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private let tableView = UITableView()
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Start a discussion"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let scrollToTopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Наверх", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var post: Post = Post(
        id: 1,
        title: "New Episode!",
        text: """
Just wrapped up the latest episode of Aerial Girl Squad! Watching it come to life from the storyboards to the final scenes has been such a rewarding experience.
""",
        user: User(id: 1, name: "Ema Yasuhara", login: "emmya", admin: nil, creationTime: "2024-10-07"),
        viewCount: 6941,
        creationTime: "2:24 07 Oct 24",
        voteCount: 1336,
        disscussion: [
            Discussion(
                id: 1,
                text: "This episode was amazing!",
                user: User(id: 2, name: "John Doe", login: "johndoe", admin: nil, creationTime: "2024-10-07"),
                parentDiscussionId: 0,
                creationTime: "2:30 07 Oct 24",
                voteCount: 45
            )
        ]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupInputField()
        setupTableView()
        setupScrollToTopButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(DiscussionTableViewCell.self, forCellReuseIdentifier: "DiscussionCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor)
        ])
    }

    private func setupInputField() {
        view.addSubview(inputTextField) // Убедитесь, что добавлено в то же супервью
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8), // Привязываем к safe area
            inputTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    
    private func setupScrollToTopButton() {
        view.addSubview(scrollToTopButton)
        
        scrollToTopButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollToTopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollToTopButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollToTopButton.heightAnchor.constraint(equalToConstant: 44),
            scrollToTopButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        let newComment = Discussion(
            id: post.disscussion.count + 1,
            text: text,
            user: User(id: 4, name: "Current User", login: "currentuser", admin: nil, creationTime: "2024-10-08"),
            parentDiscussionId: 0,
            creationTime: "Now",
            voteCount: 0
        )
        
        let updatedDiscussions = post.disscussion + [newComment]
        post = Post(
            id: post.id,
            title: post.title,
            text: post.text,
            user: post.user,
            viewCount: post.viewCount,
            creationTime: post.creationTime,
            voteCount: post.voteCount,
            disscussion: updatedDiscussions
        )
        
        textField.text = ""
        textField.resignFirstResponder()
        
        tableView.reloadData()
        
        let indexPath = IndexPath(row: post.disscussion.count, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        return true
    }


    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + post.disscussion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: post)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionCell", for: indexPath) as? DiscussionTableViewCell else {
                return UITableViewCell()
            }
            let discussion = post.disscussion[indexPath.row - 1]
            cell.configure(with: discussion)
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollToTopButton.isHidden = scrollView.contentOffset.y < tableView.rectForRow(at: IndexPath(row: 0, section: 0)).maxY
    }
    
    // MARK: - Клавиатура
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height + view.safeAreaInsets.bottom
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
}
