//
//  DiscussionTableViewCell.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import UIKit

class DiscussionTableViewCell: UITableViewCell {
    
    private let userNameLabel = UILabel()
    private let userLoginLabel = UILabel()
    private let commentTextLabel = UILabel()
    private let creationTimeLabel = UILabel()
    private let voteCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        userLoginLabel.font = UIFont.systemFont(ofSize: 12)
        userLoginLabel.textColor = .gray
        
        commentTextLabel.font = UIFont.systemFont(ofSize: 14)
        commentTextLabel.numberOfLines = 0
        commentTextLabel.textColor = .white
        
        creationTimeLabel.font = UIFont.systemFont(ofSize: 12)
        creationTimeLabel.textColor = .lightGray
        creationTimeLabel.textAlignment = .right
        
        voteCountLabel.font = UIFont.systemFont(ofSize: 12)
        voteCountLabel.textColor = .gray
        
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userLoginLabel)
        contentView.addSubview(commentTextLabel)
        contentView.addSubview(creationTimeLabel)
        contentView.addSubview(voteCountLabel)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        commentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        creationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            userLoginLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 8),
            userLoginLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            
            creationTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            creationTimeLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            
            commentTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            
            voteCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            voteCountLabel.topAnchor.constraint(equalTo: commentTextLabel.bottomAnchor, constant: 8),
            voteCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with discussion: Discussion) {
        userNameLabel.text = discussion.user.name
        userLoginLabel.text = "@\(discussion.user.login)"
        commentTextLabel.text = discussion.text
        creationTimeLabel.text = discussion.creationTime
        voteCountLabel.text = "↑ \(discussion.voteCount)"
    }
}
