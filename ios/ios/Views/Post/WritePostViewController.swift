//
//  PostViewController.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import UIKit

class WritePostViewController: UIViewController, UITextViewDelegate, ObservableObject {
    private let userService: UserService
    private let postService: PostService
    private let writePostView = WritePostView()
    
    override func loadView() {
        view = writePostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        writePostView.titleTextView.delegate = self
        writePostView.contentTextView.delegate = self
        
        setupActions()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    init(userService: UserService, postService: PostService) {
        self.userService = userService
        self.postService = postService
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text.isEmpty {
            textView.text = "Start writing here"
            textView.textColor = .placeholderText
        }
    }
    private func setupActions() {
        writePostView.postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func postButtonTapped() {
        guard let title = writePostView.titleTextView.text, !title.isEmpty else {
            displayError(message: "Title cannot be empty.")
            return
        }
        
        guard let text = writePostView.contentTextView.text, !text.isEmpty else {
            displayError(message: "Content cannot be empty.")
            return
        }
        createPost(jwt: userService.getJwt()!, title: title, text: text)
    }
    
    private func createPost(jwt: String, title: String, text: String) {
        print("Post created with title: \(title) and content: \(text)")
        Task {
            do {
                try await postService.createPost(jwt: userService.getJwt()!, title: title, text: text)
            } catch {}
        }
        writePostView.titleTextView.text = ""
        writePostView.contentTextView.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    private func displayError(message: String) {
        writePostView.errorLabel.text = message
        writePostView.errorLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.writePostView.errorLabel.isHidden = true
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height + view.safeAreaInsets.bottom
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
}
