//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 17/12/24.
//

import UIKit

final class CreateHabitViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    weak var delegate: CreateHabitViewControllerDelegate?
    weak var trackerTypeSelectionViewController: TrackerTypeSelectionViewController?
    
    // MARK: - Private Properties
    
    private let headerLabel = UILabel()
    private let maxNumberOfSymbolsErrorLabel = UILabel()
    private let trackerNameTextField = UITextField()
    private let textFieldStackView = UIStackView()
    private let spacingView = UIView()
    private let settingsTableView = UITableView()
    // TODO: добавить (скорее всего UICollectionView с двумя секциями) - emoji, color
    private let bottomButtonsStackView = UIStackView()
    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    
    private var timetable: Set<abbreviatedWeekDay> = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapCreateButton() {
        dismiss(animated: true)
        trackerTypeSelectionViewController?.dismiss(animated: true)
        // TODO: тестовая категория, в будущем реализовать выбор категории в кнопке Category
        let testCategoryName = "Test"
        // Выше удалить
        let trackerName = trackerNameTextField.text ?? ""
        // TODO: когда добавлю выбор цвета и эмоджи - изменить создание newTracker
        let newTracker = Tracker(id: UUID(),
                                 name: trackerName,
                                 color: UIColor.blue,
                                 emoji: "",
                                 timetable: timetable)
        delegate?.addTracker(newTracker, to: testCategoryName)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.ypWhite
        setupHeaderAndTextField()
        setupTableView()
        setupCollectionView()
        setupBottomButtons()
    }
    
    private func setupLayout() {
        setupHeaderAndTextFieldLayout()
        setupTableViewLayout()
        setupCollectionViewLayout()
        setupBottomButtonsLayout()
    }
    
    private func setupHeaderAndTextField() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Новая привычка"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = UIColor.ypBlack
        view.addSubview(headerLabel)
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 8
        textFieldStackView.alignment = .center
        view.addSubview(textFieldStackView)
        
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.delegate = self
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.backgroundColor = UIColor.ypBackground
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.clearButtonMode = .whileEditing
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameTextField.frame.height))
        trackerNameTextField.leftView = leftPaddingView
        trackerNameTextField.leftViewMode = .always
        textFieldStackView.addArrangedSubview(trackerNameTextField)
        
        maxNumberOfSymbolsErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        maxNumberOfSymbolsErrorLabel.text = "Ограничение 38 символов"
        maxNumberOfSymbolsErrorLabel.textColor = UIColor.ypRed
        maxNumberOfSymbolsErrorLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        maxNumberOfSymbolsErrorLabel.isHidden = true
        textFieldStackView.addArrangedSubview(maxNumberOfSymbolsErrorLabel)
        
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.isHidden = true
        textFieldStackView.addArrangedSubview(spacingView)
    }
    
    private func setupTableView() {
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(SettingCell.self, forCellReuseIdentifier: "Setting")
        settingsTableView.isScrollEnabled = false
        settingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        settingsTableView.separatorStyle = .none
        view.addSubview(settingsTableView)
    }
    
    private func setupCollectionView() { }
    
    private func setupBottomButtons() {
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.spacing = 8
        view.addSubview(bottomButtonsStackView)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.tintColor = UIColor.ypRed
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        bottomButtonsStackView.addArrangedSubview(cancelButton)
        
        // TODO: становится темной только, когда выбраны все элементы (название, категория, расписание, эмоджи, цвет)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = UIColor.ypGray
        createButton.setTitle("Создать", for: .normal)
        createButton.tintColor = UIColor.ypWhite
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        bottomButtonsStackView.addArrangedSubview(createButton)
    }
    
    private func setupHeaderAndTextFieldLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            trackerNameTextField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            
            spacingView.heightAnchor.constraint(equalToConstant: 0),
        ])
    }
    
    private func setupTableViewLayout() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupCollectionViewLayout() {
        NSLayoutConstraint.activate([
        ])
    }
    
    private func setupBottomButtonsLayout() {
        NSLayoutConstraint.activate([
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func didTapCategoryButton() {
        // TODO: добавить выбор категории
    }
    
    private func didTapTimetableButton() {
        timetable.removeAll()
        let habitTimetableViewController = HabitTimetableViewController()
        habitTimetableViewController.delegate = self
        present(habitTimetableViewController, animated: true)
    }
    
    private func convertWeekDayToAbbreviated(day: WeekDay) -> abbreviatedWeekDay {
        switch day {
        case .monday: return .monday
        case .tuesday: return .tuesday
        case .wednesday: return .wednesday
        case .thursday: return .thursday
        case .friday: return .friday
        case .saturday: return .saturday
        case .sunday: return .sunday
        }
    }
}

// MARK: - UITextFieldDelegate

extension CreateHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        
        let currentText = trackerNameTextField.text ?? ""
        let requestedLength = currentText.count + string.count - range.length
        
        if requestedLength >= maxLength {
            maxNumberOfSymbolsErrorLabel.isHidden = false
            spacingView.isHidden = false
        } else {
            maxNumberOfSymbolsErrorLabel.isHidden = true
            spacingView.isHidden = true
        }
        
        return requestedLength <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource

extension CreateHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Setting", for: indexPath) as? SettingCell else {
            assertionFailure("Error: unable to get table view week setting cell")
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.nameLabel.text = "Категория"
            // TODO: Добавить переменную с названием категории когда создам VC с выбором категории
            cell.chosenOptionsLabel.text = ""
            cell.chosenOptionsLabel.isHidden = true
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == 1 {
            cell.nameLabel.text = "Расписание"
            let days = timetable.map { $0.rawValue }.joined(separator: ", ")
            cell.chosenOptionsLabel.text = days
            if cell.chosenOptionsLabel.text == "" {
                cell.chosenOptionsLabel.isHidden = true
            } else {
                cell.chosenOptionsLabel.isHidden = false
            }
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorView.isHidden = true
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            didTapCategoryButton()
        } else if indexPath.row == 1 {
            didTapTimetableButton()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - HabitTimetableDelegate

extension CreateHabitViewController: HabitTimetableDelegate {
    
    func updateTimetableButton(with timetable: Set<WeekDay>) {
        for day in timetable {
            let abbreviatedDay = convertWeekDayToAbbreviated(day: day)
            self.timetable.insert(abbreviatedDay)
        }
        settingsTableView.reloadData()
    }
}
