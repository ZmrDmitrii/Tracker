//
//  DayOfWeekCell.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 18/12/24.
//

import UIKit

final class WeekDayCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    let dayLabel = UILabel()
    let chooseDaySwitch = UISwitch()
    let separatorView = UIView()
    weak var delegate: WeekDayCellDelegate?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapSwitch() {
        if chooseDaySwitch.isOn {
            delegate?.addDayToTimetable(for: self)
        } else {
            delegate?.removeDayFromTimetable(for: self)
        }
    }
    
    private func setupLayout() {
        contentView.backgroundColor = UIColor.ypBackground
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        contentView.addSubview(dayLabel)
        
        chooseDaySwitch.translatesAutoresizingMaskIntoConstraints = false
        chooseDaySwitch.onTintColor = UIColor.ypBlue
        chooseDaySwitch.addTarget(self, action: #selector(didTapSwitch), for: .valueChanged)
        contentView.addSubview(chooseDaySwitch)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            chooseDaySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chooseDaySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
}

