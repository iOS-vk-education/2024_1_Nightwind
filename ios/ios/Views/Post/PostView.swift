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
    private let commentCountLabel = UILabel()
    private let separatorView = UIView()
    private let avatarImageView = UIImageView()

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
        setupImageView()
        setupSeparator()
        setupLayout()
    }

    private func setupLabels() {
        displayNameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        usernameLabel.font = UIFont.systemFont(ofSize: 12)
        usernameLabel.textColor = .gray

        creationTimeLabel.font = UIFont.systemFont(ofSize: 12)
        creationTimeLabel.textColor = .gray
        creationTimeLabel.textAlignment = .right

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0

        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.numberOfLines = 0

        viewCountLabel.font = UIFont.systemFont(ofSize: 14)
        commentCountLabel.font = UIFont.systemFont(ofSize: 14)
    }

    private func setupImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
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

        addSubviews(avatarImageView, displayNameLabel, usernameAndDateStack, titleLabel, textLabel, separatorView, voteView, viewCountLabel, commentCountLabel)

        NSLayoutConstraint.activate([
            // Avatar
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 38),
            avatarImageView.heightAnchor.constraint(equalToConstant: 38),

            // Display name
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            displayNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),

            // Username and date
            usernameAndDateStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameAndDateStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            usernameAndDateStack.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 2),

            // Title
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: usernameAndDateStack.bottomAnchor, constant: 12),

            // Text
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),

            // Separator
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            // Vote view
            voteView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            voteView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            voteView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            // View count
            viewCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewCountLabel.topAnchor.constraint(equalTo: voteView.topAnchor),

            // Comment count
            commentCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            commentCountLabel.topAnchor.constraint(equalTo: voteView.topAnchor),

            // Bottom constraint
            commentCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(with post: Post, voteService: VoteService, userService: UserService) {
        displayNameLabel.text = post.user.name
        usernameLabel.text = "@\(post.user.login)"
        creationTimeLabel.text = post.creationTime
        titleLabel.text = post.title
        textLabel.text = post.text
        viewCountLabel.text = "\(post.viewCount) views"
        commentCountLabel.text = "\u{1F4AC} \(post.discussionCount)"

        // Load avatar asynchronously
        let placeholderURL = URL(string: "https://avatar.iran.liara.run/public")!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: placeholderURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }

        // Configure vote view
        voteView.configure(
            voteType: .post(id: post.id),
            initialVoteCount: post.voteCount,
            voteService: voteService,
            userService: userService
        )
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
