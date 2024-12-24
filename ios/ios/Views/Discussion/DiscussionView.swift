//
//  DiscussionView.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 24.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

class DiscussionView: UIView {
    private let userNameLabel = UILabel()
    private let userLoginLabel = UILabel()
    private let commentTextLabel = UILabel()
    private let creationTimeLabel = UILabel()
    private let separatorView = UIView()
    private let voteView = VoteView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupSeparator() {
        separatorView.backgroundColor = .lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupView() {
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        userLoginLabel.font = UIFont.systemFont(ofSize: 12)
        userLoginLabel.textColor = .gray

        commentTextLabel.font = UIFont.systemFont(ofSize: 14)
        commentTextLabel.numberOfLines = 0

        creationTimeLabel.font = UIFont.systemFont(ofSize: 12)
        creationTimeLabel.textColor = .lightGray
        creationTimeLabel.textAlignment = .right
        
        setupSeparator()

        addSubviews(userNameLabel, userLoginLabel, commentTextLabel, creationTimeLabel, separatorView, voteView)

        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),

            userLoginLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 8),
            userLoginLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),

            creationTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            creationTimeLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),

            commentTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            commentTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            commentTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 16),

            // Separator
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.topAnchor.constraint(equalTo: commentTextLabel.bottomAnchor, constant: 16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            // Vote view
            voteView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            voteView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            voteView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        voteView.frame = CGRect(x: 8, y: separatorView.frame.maxY + 16, width: bounds.width - 32, height: 120)
    }

    func configure(with discussion: Discussion, voteService: VoteService, userService: UserService) {
        userNameLabel.text = discussion.user.name
        userLoginLabel.text = "@\(discussion.user.login)"
        commentTextLabel.text = discussion.text
        creationTimeLabel.text = discussion.creationTime.formattedDate()

        voteView.configure(
            voteType: .discussion(id: discussion.id),
            initialVoteCount: discussion.voteCount,
            voteService: voteService,
            userService: userService
        )
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = voteView.hitTest(convert(point, to: voteView), with: event) {
            return hitView
        }
        return super.hitTest(point, with: event)
    }
}
