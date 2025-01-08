//
//  VoteView.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 22.12.2024.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import UIKit
import SVGKit

protocol VoteViewDelegate: AnyObject {
    func voteUpdated(to newVoteCount: Int)
}

class VoteView: UIView {
    private let ARROW_UP = UIImage(named: "arrow_up")
    private let DOUBLE_ARROW_UP = UIImage(named: "double_arrow_up")
    private let ARROW_DOWN = UIImage(named: "arrow_down")
    private let DOUBLE_ARROW_DOWN = UIImage(named: "double_arrow_down")
    
    private var voteCountLabel: UILabel!
    private var upvoteButton: UIButton!
    private var downvoteButton: UIButton!
    private var isUpvote: Bool? = nil
    private var currentVoteCount: Int = 0
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
        translatesAutoresizingMaskIntoConstraints = false
        
        upvoteButton = UIButton(type: .system)
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)

        voteCountLabel = UILabel()
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.textAlignment = .center
        voteCountLabel.font = UIStyles.FontFamily.lato

        downvoteButton = UIButton(type: .system)
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downvoteButton.addTarget(self, action: #selector(handleDownvote), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [upvoteButton, voteCountLabel, downvoteButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        updateVisualState() // Set initial UIStyles
    }

    private func updateVisualState() {
        // Clear existing subviews from the under-layer to reconfigure.
        subviews.forEach { $0.removeFromSuperview() }
        
        let baseView = UIStackView()
        baseView.axis = .horizontal
        baseView.alignment = .center
        baseView.spacing = 8
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        
        voteCountLabel.textColor = UIStyles.Light.text
        upvoteButton.tintColor = UIStyles.Light.green
        downvoteButton.tintColor = UIStyles.Light.red

        switch currentVoteCount {
        case _ where currentVoteCount > 0:
            if isUpvote == true {
                // Upvoted, positive or zero votes.
                stackView.backgroundColor = UIStyles.Light.secondaryBase
                upvoteButton.tintColor = UIStyles.Light.secondaryText
                voteCountLabel.textColor = UIStyles.Light.secondaryText
                stackView.addArrangedSubview(upvoteButton)
                stackView.addArrangedSubview(voteCountLabel)
                stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
                
                baseView.addArrangedSubview(stackView)
                baseView.addArrangedSubview(downvoteButton)
            } else if isUpvote == false {
                // Downvoted, positive or zero votes.
                stackView.backgroundColor = UIStyles.Light.errorBase
                downvoteButton.tintColor = UIStyles.Light.errorText
                stackView.addArrangedSubview(downvoteButton)
                
                baseView.addArrangedSubview(upvoteButton)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(stackView)
            } else {
                // Neutral state, positive or zero votes.
                baseView.addArrangedSubview(upvoteButton)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(downvoteButton)
            }
            break
        case _ where currentVoteCount < 0:
            if isUpvote == true {
                // Upvoted, negative votes.
                stackView.backgroundColor = UIStyles.Light.secondaryBase
                upvoteButton.tintColor = UIStyles.Light.secondaryText
                stackView.addArrangedSubview(upvoteButton)
                
                baseView.addArrangedSubview(stackView)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(downvoteButton)
            } else if isUpvote == false {
                // Downvoted, negative votes.
                stackView.backgroundColor = UIStyles.Light.errorBase
                voteCountLabel.textColor = UIStyles.Light.errorText
                downvoteButton.tintColor = UIStyles.Light.errorText
                stackView.addArrangedSubview(voteCountLabel)
                stackView.addArrangedSubview(downvoteButton)
                stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
                
                baseView.addArrangedSubview(upvoteButton)
                baseView.addArrangedSubview(stackView)
            } else {
                // Neutral state, negative votes.
                baseView.addArrangedSubview(upvoteButton)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(downvoteButton)
            }
            break
        default:
            if isUpvote == true {
                // Upvoted, neutral votes.
                stackView.backgroundColor = UIStyles.Light.secondaryBase
                upvoteButton.tintColor = UIStyles.Light.secondaryText
                stackView.addArrangedSubview(upvoteButton)
                
                baseView.addArrangedSubview(stackView)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(downvoteButton)
            } else if isUpvote == false {
                // Downvoted, neutral votes.
                stackView.backgroundColor = UIStyles.Light.errorBase
                downvoteButton.tintColor = UIStyles.Light.errorText
                stackView.addArrangedSubview(downvoteButton)
                
                baseView.addArrangedSubview(upvoteButton)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(stackView)
            } else {
                // Neutral state, negative votes.
                baseView.addArrangedSubview(upvoteButton)
                baseView.addArrangedSubview(voteCountLabel)
                baseView.addArrangedSubview(downvoteButton)
            }
            break
        }
        
        addSubview(baseView)

        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Update button images and states as per current state.
        upvoteButton.setImage(upvoteButton.isSelected ? DOUBLE_ARROW_UP : ARROW_UP, for: .normal)
        downvoteButton.setImage(downvoteButton.isSelected ? DOUBLE_ARROW_DOWN : ARROW_DOWN, for: .normal)
    }


    @objc private func handleUpvote() {
        submitVote(upvote: true)
    }

    @objc private func handleDownvote() {
        submitVote(upvote: false)
    }

    private func submitVote(upvote: Bool) {
        guard let voteType = voteType, let jwt = userService?.getJwt() else { return }
        Task {
            do {
                switch voteType {
                case .post(let id):
                    let vote = try await voteService.votePost(postId: id, jwt: jwt, upvote: upvote)
                    if let vote = vote {
                        updateVoteCount(to: vote.post!.voteCount)
                        isUpvote = upvote
                    } else {
                        updateVoteCount(to: upvote ? currentVoteCount - 1 : currentVoteCount + 1)
                        isUpvote = nil
                    }
                case .discussion(let id):
                    let vote = try await voteService.voteDiscussion(discussionId: id, jwt: jwt, upvote: upvote)
                    if let vote = vote {
                        updateVoteCount(to: vote.discussion!.voteCount)
                        isUpvote = upvote
                    } else {
                        updateVoteCount(to: upvote ? currentVoteCount - 1 : currentVoteCount + 1)
                        isUpvote = nil
                    }
                }
                updateVisualState()
                delegate?.voteUpdated(to: currentVoteCount)
            } catch {
                print("Vote submission failed: \(error)")
            }
        }
    }

    private func updateVoteCount(to count: Int) {
        currentVoteCount = count
        voteCountLabel.text = "\(count)"
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
                switch voteType {
                case .post(let id):
                    updateVoteImages(vote: try await voteService.getPostVote(postId: id, jwt: jwt))
                case .discussion(let id):
                    updateVisualState()
                    updateVoteImages(vote: try await voteService.getDiscussionVote(discussionId: id, jwt: jwt))
                }
            } catch {
                print("Vote images update failed: \(error)")
            }
        }
    }

    private func updateVoteImages(vote: Vote?) {
        if let vote = vote {
            isUpvote = vote.upvote
            updateVisualState()
        } else {
            isUpvote = nil
            updateVisualState()
        }
    }
}
