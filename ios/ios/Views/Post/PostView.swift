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
    private let voteView = VoteView()
    private let viewCountLabel = UILabel()
    private let commentCountView = UIView()
    private let separatorView = UIView()
    private var showInfoFlag = Bool()
    private var titleView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommentCountView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCommentCountView()
    }

    private func setupView() {
        setupLabels()
        setupSeparator()
        setupLayout()
    }

    private func setupLabels() {
        displayNameLabel.font = UIFont(name: UIStyles.FontFamily.lato.fontName, size: 16)

        usernameLabel.font = UIFont.systemFont(ofSize: 12)
        usernameLabel.textColor = .gray

        creationTimeLabel.font = UIFont.systemFont(ofSize: 12)
        creationTimeLabel.textColor = .gray
        creationTimeLabel.textAlignment = .right

        titleLabel.font = UIFont(name: UIStyles.FontFamily.ebGaramond.fontName, size: 24)
        titleLabel.numberOfLines = 0

        textLabel.font = UIFont(name: UIStyles.FontFamily.lato.fontName, size: 14)
        textLabel.numberOfLines = 0

        viewCountLabel.font = UIFont.systemFont(ofSize: 13)
        viewCountLabel.textColor = UIStyles.Light.script
    }

    private func setupCommentCountView() {
        // Clear existing subviews to prevent stacking
        commentCountView.subviews.forEach { $0.removeFromSuperview() }
        
        commentCountView.backgroundColor = UIStyles.Light.primaryBase
        commentCountView.layer.cornerRadius = 16
        commentCountView.clipsToBounds = true

        let iconImage = UIImage(named: "thread")?.withTintColor(UIStyles.Light.primaryText)

        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 14)
        countLabel.textColor = UIStyles.Light.tetriaryText

        let stackView = UIStackView(arrangedSubviews: [UIImageView(image: iconImage), countLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

        commentCountView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: commentCountView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: commentCountView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: commentCountView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: commentCountView.bottomAnchor)
        ])
    }

    private func setupSeparator() {
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        let usernameAndDateStack = UIStackView(arrangedSubviews: [usernameLabel, creationTimeLabel])
        usernameAndDateStack.axis = .horizontal
        usernameAndDateStack.spacing = 2
        
        usernameAndDateStack
            .translatesAutoresizingMaskIntoConstraints = false
        
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if showInfoFlag {
            addSubviews(displayNameLabel, usernameAndDateStack, titleLabel, textLabel, separatorView, voteView, viewCountLabel, commentCountView)
            
            NSLayoutConstraint.activate([
                // Display name
                displayNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                displayNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                
                // Username and date
                usernameAndDateStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),                usernameAndDateStack.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 2),
                
                // Title
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                titleLabel.topAnchor.constraint(equalTo: usernameAndDateStack.bottomAnchor, constant: 12)
            ])
        } else {
            titleView.addSubview(displayNameLabel)
            NSLayoutConstraint.activate([
                // Display name
                displayNameLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: -8),
                displayNameLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -8),
                displayNameLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            ])
            
            titleView.addSubview(usernameAndDateStack)
            NSLayoutConstraint.activate([
                // Username and date
                usernameAndDateStack.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: -8),
                usernameAndDateStack.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 2),
            ])
            
            
            addSubviews(titleLabel, textLabel, separatorView, voteView, viewCountLabel, commentCountView)
            NSLayoutConstraint.activate([
                // Title
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
            ])
        }
        
        NSLayoutConstraint.activate([
            // Separator
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            // Text
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            
            // Vote view
            voteView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            voteView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 12),
            voteView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            // View count
            viewCountLabel.trailingAnchor.constraint(equalTo: commentCountView.leadingAnchor, constant: -8),
            viewCountLabel.centerYAnchor.constraint(equalTo: commentCountView.centerYAnchor),
            
            // Comment count
            commentCountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            commentCountView.centerYAnchor.constraint(equalTo: voteView.centerYAnchor)
        ])
        
    }

    func configure(with post: Post, showInfo: Bool, startTitleView: UIView, voteService: VoteService, userService: UserService) {
        
        displayNameLabel.text = post.user.name
        usernameLabel.text = "@\(post.user.login)"
        creationTimeLabel.text = "\u{00B7} \(post.creationTime.formattedDate())"
        titleLabel.text = post.title
        textLabel.text = post.text
        showInfoFlag = showInfo
        titleView = startTitleView
        viewCountLabel.text = "\(post.viewCount) views"

        
        if let countLabel = (commentCountView.subviews.first as? UIStackView)?.arrangedSubviews.last as? UILabel {
            countLabel.text = "\(post.discussionCount)"
        }

        // Configure vote view
        voteView.configure(
            voteType: .post(id: post.id),
            initialVoteCount: post.voteCount,
            voteService: voteService,
            userService: userService
        )
        
        
        setupView()
    }
}
