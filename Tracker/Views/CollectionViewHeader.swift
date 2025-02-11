//
//  TrackerHeader.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 12/12/24.
//

import UIKit

final class CollectionViewHeader: UICollectionReusableView {

    // MARK: - Private Properties

    private let headerLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.textColor = UIColor.ypBlack
        addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func configureUI(header: String) {
        headerLabel.text = header
    }
}
