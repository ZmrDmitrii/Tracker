//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 17/12/24.
//

import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    weak var trackersViewController: TrackersViewController?
    
    // MARK: - Private Properties
    
    private let headerLabel = UILabel()
    private let createHabitButton = UIButton(type: .system)
    private let createEventButton = UIButton(type: .system)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapHabitButton() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.trackerTypeSelectionViewController = self
        createHabitViewController.delegate = trackersViewController
        present(createHabitViewController, animated: true)
    }
    
    // TODO: реализовать как в HabitButton
    @objc private func didTapEventButton(){
        present(CreateEventViewController(), animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.ypWhite
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Создание трекера"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = UIColor.ypBlack
        view.addSubview(headerLabel)
        
        createHabitButton.translatesAutoresizingMaskIntoConstraints = false
        createHabitButton.backgroundColor = UIColor.ypBlack
        createHabitButton.layer.cornerRadius = 16
        createHabitButton.layer.masksToBounds = true
        createHabitButton.setTitle("Привычка", for: .normal)
        createHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createHabitButton.tintColor = UIColor.ypWhite
        createHabitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        view.addSubview(createHabitButton)
        
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.backgroundColor = UIColor.ypBlack
        createEventButton.layer.cornerRadius = 16
        createEventButton.layer.masksToBounds = true
        createEventButton.setTitle("Нерегулярное событие", for: .normal)
        createEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createEventButton.tintColor = UIColor.ypWhite
        createEventButton.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        view.addSubview(createEventButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createHabitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            createEventButton.topAnchor.constraint(equalTo: createHabitButton.bottomAnchor, constant: 16),
            createEventButton.heightAnchor.constraint(equalToConstant: 60),
            createEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
