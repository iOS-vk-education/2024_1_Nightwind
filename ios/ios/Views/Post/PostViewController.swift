//
//  PostViewController.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UIViewController {
    private let discussionService: DiscussionService
    private let voteService: VoteService
    private let userService: UserService
    
    private var inputTextFieldBottomConstraint: NSLayoutConstraint!
    
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
        button.layer.cornerRadius = 5
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var post: Post
    private var discussions: [Discussion] = []
    
    init(post: Post, discussionService: DiscussionService, voteService: VoteService, userService: UserService) {
        self.post = post
        self.discussionService = discussionService
        self.voteService = voteService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
        
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Private
extension PostViewController {
    private func update() {
        Task {
            do {
                discussions = try await discussionService.getDiscussionsForPost(postId: post.id)
                tableView.reloadData()
            } catch {}
        }
    }
    
    private func setupUI() {
        // TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(DiscussionTableViewCell.self, forCellReuseIdentifier: "DiscussionCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        // InputField
        view.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        
        // ScrollToTopButton
        view.addSubview(scrollToTopButton)
        
        scrollToTopButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        inputTextFieldBottomConstraint = inputTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor),

            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputTextFieldBottomConstraint,
            inputTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Selectors
extension PostViewController {
    @objc private func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        inputTextFieldBottomConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        inputTextFieldBottomConstraint.constant = -8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Post
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: post, voteService: voteService, userService: userService)
            return cell
        } else {
            // Discussion
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionCell", for: indexPath) as? DiscussionTableViewCell else {
                return UITableViewCell()
            }
            let discussion = discussions[indexPath.row - 1]
            cell.configure(with: discussion, voteService: voteService, userService: userService)
            return cell
        }
    }
}

// MARK: - UITextFieldDelegate
extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        let newDiscussion = DiscussionForm(
            text: text
        )

        textField.text = ""
        textField.resignFirstResponder()
        
        Task {
            do {
                try await discussionService.postDiscussion(postId: post.id, jwt: userService.getJwt()!, discussion: newDiscussion, parentDiscussionId: nil)
            
                update()
                
                let indexPath = IndexPath(row: discussions.count, section: 0)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } catch {}
        }
        
        return true
    }
}

// MARK: - UITableViewDelegate
extension PostViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollToTopButton.isHidden = scrollView.contentOffset.y < tableView.rectForRow(at: IndexPath(row: 0, section: 0)).maxY
    }
}
