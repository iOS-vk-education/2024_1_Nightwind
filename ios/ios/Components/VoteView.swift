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
    private static let UP_VOTE_IMAGE = UIImage(systemName: "arrowtriangle.up")
    private static let UP_VOTE_CHOSEN_IMAGE = UIImage(systemName: "arrowtriangle.up.fill")
    private static let DOWN_VOTE_IMAGE = UIImage(systemName: "arrowtriangle.down")
    private static let DOWN_VOTE_CHOSEN_IMAGE = UIImage(systemName: "arrowtriangle.down.fill")
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
        upvoteButton.setImage(VoteView.UP_VOTE_IMAGE, for: .normal)
        upvoteButton.tintColor = .label
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        
        downvoteButton = UIButton(type: .system)
        downvoteButton.setImage(VoteView.DOWN_VOTE_IMAGE, for: .normal)
        downvoteButton.tintColor = .label
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
    
    private func updateVoteCount(to count: Int) {
        currentVoteCount = count
        voteCountLabel.text = "\(count)"
    }
    
    private func updateVoteImages(vote: Vote?) {
        if let vote = vote {
            upvoteButton.setImage(vote.upvote ? VoteView.UP_VOTE_CHOSEN_IMAGE : VoteView.UP_VOTE_IMAGE, for: .normal)
            downvoteButton.setImage(!vote.upvote  ? VoteView.DOWN_VOTE_CHOSEN_IMAGE : VoteView.DOWN_VOTE_IMAGE, for: .normal)
        } else {
            upvoteButton.setImage(VoteView.UP_VOTE_IMAGE, for: .normal)
            downvoteButton.setImage(VoteView.DOWN_VOTE_IMAGE, for: .normal)
        }
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
                    updateVoteImages(vote: vote)
                case .discussion(let id):
                    let vote = try await voteService.voteDiscussion(discussionId: id, jwt: jwt, upvote: upvote)
                    if let vote = vote {
                        updateVoteCount(to: vote.discussion!.voteCount)
                    } else {
                        updateVoteCount(to: upvote ? currentVoteCount - 1 : currentVoteCount + 1)
                    }
                    updateVoteImages(vote: vote)
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
        guard let jwt = userService.getJwt() else { return }
        Task {
            do {
                switch (voteType) {
                case .post(let id):
                    updateVoteImages(vote: try await voteService.getPostVote(postId: id, jwt: jwt))
                case .discussion(let id):
                    updateVoteImages(vote: try await voteService.getDiscussionVote(discussionId: id, jwt: jwt))
                }
            } catch {
                print("Vote images update failed: \(error)")
            }
        }
    }
}
