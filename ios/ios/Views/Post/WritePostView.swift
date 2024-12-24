//
//  WritePostView.swift
//  Nightwind
//
//  Created by Ivan Vinogradov on 21.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

class WritePostView: UIView {
    
    let usernameLabel = UILabel()
    let userDetailsLabel = UILabel()
    let titleTextView = UITextView()
    let contentTextView = UITextView()
    let postButton = UIButton(type: .system)
    let errorLabel = UILabel()
    private let separatorLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupTitleTextView()
        setupContentTextView()
        setupPostButton()
        setupErrorLabel()
        setupSeparatorLine()
        setupLayout()
    }
    
    
    private func setupTitleTextView() {
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.font = UIFont.boldSystemFont(ofSize: 24)
        titleTextView.textAlignment = .center
        titleTextView.text = "Post Title"
        titleTextView.textColor = .placeholderText
        titleTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    private func setupContentTextView() {
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.borderStyle = .none
        contentTextView.text = "Write your thoughts here..."
        contentTextView.textColor = .placeholderText
        contentTextView.isScrollEnabled = true
    }
    
    private func setupPostButton() {
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle("Post", for: .normal)
        postButton.backgroundColor = UIColor(Styles.Light.tetriaryBase)
        postButton.tintColor = .white
        postButton.layer.cornerRadius = 15
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    private func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.textColor = .white
        errorLabel.backgroundColor = UIColor(Styles.Light.errorText)
        errorLabel.layer.cornerRadius = 12
        errorLabel.clipsToBounds = true
        errorLabel.textAlignment = .center
        errorLabel.text = "Cannot create post for some reason."
        errorLabel.isHidden = true
    }
    
    private func setupSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = .lightGray
    }

    private func setupLayout() {
        addSubviews(titleTextView, contentTextView, postButton, errorLabel, separatorLine)

        NSLayoutConstraint.activate([
            // Title layout
            titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextView.heightAnchor.constraint(equalToConstant: 60),

            // Separator Line
            separatorLine.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),

            // Content TextView layout
            contentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentTextView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 8),
            contentTextView.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: -16),

            // Post Button layout
            postButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            postButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            postButton.widthAnchor.constraint(equalToConstant: 80),
            postButton.heightAnchor.constraint(equalToConstant: 40),

            // Error Label layout
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            errorLabel.topAnchor.constraint(equalTo: postButton.bottomAnchor, constant: 8),
            errorLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
