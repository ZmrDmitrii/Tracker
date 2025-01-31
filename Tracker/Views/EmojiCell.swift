//
//  EmojiCell.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 17/1/25.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let emojiLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func updateEmojiLabelText(indexPath: IndexPath) {
        emojiLabel.text = Constants.emojis[indexPath.item]
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
