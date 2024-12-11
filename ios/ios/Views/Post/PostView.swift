//
//  PostView.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import UIKit

class PostView: UIView {
    
    private let displayNameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let creationTimeLabel = UILabel()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let voteCountLabel = UILabel()
    private let viewCountLabel = UILabel()
    private let commentCountLabel = UILabel()
    private let separatorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupLabels()
        setupSeparator()
        setupLayout()
    }
    
    private func setupLabels() {
        displayNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        usernameLabel.textColor = .gray
        
        creationTimeLabel.font = UIFont.systemFont(ofSize: 14)
        creationTimeLabel.textColor = .gray
        creationTimeLabel.textAlignment = .right
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0
        
        voteCountLabel.font = UIFont.systemFont(ofSize: 14)
        viewCountLabel.font = UIFont.systemFont(ofSize: 14)
        commentCountLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func setupSeparator() {
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        let usernameAndDateStack = UIStackView(arrangedSubviews: [usernameLabel, creationTimeLabel])
        usernameAndDateStack.axis = .horizontal
        usernameAndDateStack.distribution = .equalSpacing
        usernameAndDateStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(displayNameLabel, usernameAndDateStack, titleLabel, textLabel, separatorView, voteCountLabel, viewCountLabel, commentCountLabel)
        
        NSLayoutConstraint.activate([
            // Display name
            displayNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Username and date
            usernameAndDateStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            usernameAndDateStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            usernameAndDateStack.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 4),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: usernameAndDateStack.bottomAnchor, constant: 8),
            
            // Text
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            // Separator
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            // Vote count
            voteCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            voteCountLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            
            // View count
            viewCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewCountLabel.topAnchor.constraint(equalTo: voteCountLabel.topAnchor),
            
            // Comment count
            commentCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentCountLabel.topAnchor.constraint(equalTo: voteCountLabel.topAnchor),
            
            // Bottom constraint
            commentCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with post: Post) {
        displayNameLabel.text = post.user.name
        usernameLabel.text = "@\(post.user.login)"
        creationTimeLabel.text = post.creationTime
        titleLabel.text = post.title
        textLabel.text = post.text
        voteCountLabel.text = "↑ \(post.voteCount)"
        viewCountLabel.text = "\(post.viewCount) views"
        commentCountLabel.text = "💬 \(post.disscussion.count)"
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
