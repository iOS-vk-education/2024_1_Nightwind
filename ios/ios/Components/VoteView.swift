//
//  VoteView.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 22.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit

protocol VoteViewDelegate: AnyObject {
    func voteUpdated(to newVoteCount: Int)
}

class VoteView: UIView {
    private var voteCountLabel: UILabel!
    private var upvoteButton: UIButton!
    private var downvoteButton: UIButton!
    private var currentVoteCount: Int = 0
    private var jwt: String?
    weak var delegate: VoteViewDelegate?
    var voteService: VoteService!
    var userService: UserService!
    
    enum VoteType {
        case post(id: Int)
        case discussion(id: Int)
    }
    
    var voteType: VoteType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        voteCountLabel = UILabel()
        voteCountLabel.textAlignment = .center
        voteCountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        voteCountLabel.textColor = .label
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        upvoteButton = UIButton(type: .system)
        upvoteButton.setTitle("▲", for: .normal)
        upvoteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        
        downvoteButton = UIButton(type: .system)
        downvoteButton.setTitle("▼", for: .normal)
        downvoteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.addTarget(self, action: #selector(handleDownvote), for: .touchUpInside)
        
        addSubview(voteCountLabel)
        addSubview(upvoteButton)
        addSubview(downvoteButton)
        
        NSLayoutConstraint.activate([
            upvoteButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            upvoteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            voteCountLabel.leadingAnchor.constraint(equalTo: upvoteButton.trailingAnchor, constant: 8),
            voteCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            downvoteButton.leadingAnchor.constraint(equalTo: voteCountLabel.trailingAnchor, constant: 8),
            downvoteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            downvoteButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func updateVoteCount(to count: Int) {
        currentVoteCount = count
        voteCountLabel.text = "\(count)"
    }
    
    @objc private func handleUpvote() {
        submitVote(upvote: true)
    }
    
    @objc private func handleDownvote() {
        submitVote(upvote: false)
    }
    
    private func submitVote(upvote: Bool) {
        guard let voteType = voteType, let jwt = userService.getJwt() else { return }
        Task {
            do {
                switch voteType {
                case .post(let id):
                    let vote = try await voteService.votePost(postId: id, jwt: jwt, upvote: upvote)
                    if let vote = vote {
                        updateVoteCount(to: vote.post!.voteCount)
                    } else {
                        updateVoteCount(to: upvote ? currentVoteCount - 1 : currentVoteCount + 1)
                    }
                case .discussion(let id):
                    let vote = try await voteService.voteDiscussion(discussionId: id, jwt: jwt, upvote: upvote)
                    if let vote = vote {
                        updateVoteCount(to: vote.discussion!.voteCount)
                    } else {
                        updateVoteCount(to: upvote ? currentVoteCount - 1 : currentVoteCount + 1)
                    }
                }
                delegate?.voteUpdated(to: currentVoteCount)
            } catch {
                print("Vote submission failed: \(error)")
            }
        }
    }
    
    func configure(voteType: VoteType, initialVoteCount: Int, voteService: VoteService, userService: UserService) {
        self.voteType = voteType
        self.currentVoteCount = initialVoteCount
        updateVoteCount(to: initialVoteCount)
        self.voteService = voteService
        self.userService = userService
    }
}
