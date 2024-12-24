//
//  DiscussionTableViewCell.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {
    private let discussionView = DiscussionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        separatorInset = .zero
        layoutMargins = .zero
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        selectionStyle = .none
        contentView.addSubview(discussionView)
        discussionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            discussionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            discussionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            discussionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            discussionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }

    func configure(with discussion: Discussion, voteService: VoteService, userService: UserService) {
        discussionView.configure(with: discussion, voteService: voteService, userService: userService)
    }
}
