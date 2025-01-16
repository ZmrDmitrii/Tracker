//
//  TrackerCell.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 10/12/24.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    let topView = UIView()
    let bottomView = UIView()
    let emojiContainerView = UIView()
    let emojiLabel = UILabel()
    let trackerNameLabel = UILabel()
    let numberOfDaysLabel = UILabel()
    let buttonContainerView = UIView()
    let trackerIsCompletedButton = UIButton(type: .system)
    
    var IsCompletedButtonTapped = false
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        emojiContainerView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        trackerIsCompletedButton.translatesAutoresizingMaskIntoConstraints = false
        
        topView.layer.cornerRadius = 16
        
        emojiContainerView.backgroundColor = UIColor.ypWhite30
        emojiContainerView.layer.cornerRadius = 12
        emojiContainerView.layer.masksToBounds = true
        
        emojiLabel.font = UIFont.systemFont(ofSize: 12)
        
        trackerNameLabel.textColor = UIColor.ypWhite
        trackerNameLabel.numberOfLines = 2
        
        trackerIsCompletedButton.layer.cornerRadius = 17
        trackerIsCompletedButton.layer.masksToBounds = true
        trackerIsCompletedButton.setImage(UIImage(systemName: "plus",
                                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)),
                                          for: .normal)
        trackerIsCompletedButton.tintColor = UIColor.ypWhite
        trackerIsCompletedButton.addTarget(self,
                                           action: #selector(didTapTrackerCompletedButton),
                                           for: UIControl.Event.touchUpInside)
        
        numberOfDaysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        numberOfDaysLabel.textColor = UIColor.ypBlack
        
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        topView.addSubview(emojiContainerView)
        topView.addSubview(emojiLabel)
        topView.addSubview(trackerNameLabel)
        bottomView.addSubview(numberOfDaysLabel)
        bottomView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(trackerIsCompletedButton)
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiContainerView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            emojiContainerView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            emojiContainerView.widthAnchor.constraint(equalToConstant: 24),
            emojiContainerView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContainerView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContainerView.centerXAnchor),
            
            trackerNameLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50),
            
            buttonContainerView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 3),
            buttonContainerView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -7),
            buttonContainerView.widthAnchor.constraint(equalToConstant: 44),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            trackerIsCompletedButton.centerYAnchor.constraint(equalTo: buttonContainerView.centerYAnchor),
            trackerIsCompletedButton.centerXAnchor.constraint(equalTo: buttonContainerView.centerXAnchor),
            trackerIsCompletedButton.widthAnchor.constraint(equalToConstant: 34),
            trackerIsCompletedButton.heightAnchor.constraint(equalToConstant: 34),
            
            numberOfDaysLabel.centerYAnchor.constraint(equalTo: trackerIsCompletedButton.centerYAnchor),
            numberOfDaysLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateCompletedButtonAppearance() {
        if !IsCompletedButtonTapped {
            let fadeOpacityAnimation = createOpacityAnimation(fromValue: 1, toValue: 0.3)
            trackerIsCompletedButton.setImage(UIImage(systemName: "checkmark",
                                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .heavy)),
                                              for: .normal)
            trackerIsCompletedButton.layer.add(fadeOpacityAnimation, forKey: "fadeOpacity")
            trackerIsCompletedButton.layer.opacity = 0.3
            IsCompletedButtonTapped = true
            delegate?.addTrackerRecord(for: self)
        } else {
            let resetOpacityAnimation = createOpacityAnimation(fromValue: 0.3, toValue: 1)
            trackerIsCompletedButton.setImage(UIImage(systemName: "plus",
                                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)),
                                              for: .normal)
            trackerIsCompletedButton.layer.add(resetOpacityAnimation, forKey: "resetOpacity")
            trackerIsCompletedButton.layer.opacity = 1
            IsCompletedButtonTapped = false
            delegate?.removeTrackerRecord(for: self)
        }
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapTrackerCompletedButton() {
        delegate?.didTapTrackerCompletedButton(for: self)
    }
    
    private func createOpacityAnimation(fromValue: Float, toValue: Float) -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = "opacity"
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.2
        return animation
    }
}
