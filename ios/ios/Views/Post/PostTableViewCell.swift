//
//  PostTableViewCell.swift
//  Nightwind
//
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import UIKit

class PostTableViewCell: UITableViewCell {
    private let postView = PostView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        separatorInset = .zero
        layoutMargins = .zero
        selectionStyle = .none // Отключаем выделение ячейки
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        contentView.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds // Убираем отступы contentView
    }

    func configure(with post: Post) {
        postView.configure(with: post)
    }
}
