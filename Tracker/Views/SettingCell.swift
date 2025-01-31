//
//  SettingCell.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 19/12/24.
//

import UIKit

final class SettingCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let textStackView = UIStackView()
    private let nameLabel = UILabel()
    private let chosenOptionsLabel = UILabel()
    private let iconImageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configureUIForCategoryButtonOfHabit() {
        nameLabel.text = "Категория"
        // TODO: Добавить переменную с названием категории когда создам VC с выбором категории
        chosenOptionsLabel.text = ""
        chosenOptionsLabel.isHidden = true
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func configureUIForTimetableButtonOfHabit(timetable: Set<AbbreviatedWeekDay>) {
        nameLabel.text = "Расписание"
        let days = timetable.map { $0.rawValue }.joined(separator: ", ")
        chosenOptionsLabel.text = days
        chosenOptionsLabel.isHidden = chosenOptionsLabel.text == ""
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        separatorView.isHidden = true
    }
    
    func configureUIForCategoryButtonOfIrregular() {
        nameLabel.text = "Категория"
        // TODO: Добавить переменную с названием категории когда создам VC с выбором категории
        chosenOptionsLabel.text = ""
        chosenOptionsLabel.isHidden = true
        separatorView.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        
        contentView.backgroundColor = UIColor.ypBackground
        
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .vertical
        textStackView.spacing = 2
        contentView.addSubview(textStackView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameLabel.textColor = UIColor.ypBlack
        textStackView.addArrangedSubview(nameLabel)
        
        chosenOptionsLabel.translatesAutoresizingMaskIntoConstraints = false
        chosenOptionsLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        chosenOptionsLabel.textColor = UIColor.ypGray
        textStackView.addArrangedSubview(chosenOptionsLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage.chevronIcon
        contentView.addSubview(iconImageView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}
