//
//  HabitTimetableVIewController .swift
//  Tracker
//
//  Created by Дмитрий Замараев on 18/12/24.
//

import UIKit

final class HabitTimetableViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    weak var delegate: HabitTimetableDelegate?
    
    // MARK: - Private Properties
    
    private let headerLabel = UILabel()
    private let WeekDaysTableView = UITableView()
    private let doneButton = UIButton(type: .system)

    private let WeekDays: [WeekDay] = [WeekDay.monday, WeekDay.tuesday, WeekDay.wednesday, WeekDay.thursday, WeekDay.friday, WeekDay.saturday, WeekDay.sunday]
    private var timetable: Set<WeekDay> = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    @objc private func didTapDoneButton() {
        dismiss(animated: true)
        delegate?.updateTimetableButton(with: timetable)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.ypWhite
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Расписание"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = UIColor.ypBlack
        view.addSubview(headerLabel)
        
        WeekDaysTableView.translatesAutoresizingMaskIntoConstraints = false
        WeekDaysTableView.dataSource = self
        WeekDaysTableView.delegate = self
        WeekDaysTableView.register(WeekDayCell.self, forCellReuseIdentifier: "WeekDay")
        WeekDaysTableView.isScrollEnabled = false
        WeekDaysTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        WeekDaysTableView.separatorStyle = .none
        view.addSubview(WeekDaysTableView)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.backgroundColor = UIColor.ypBlack
        doneButton.tintColor = UIColor.ypWhite
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            WeekDaysTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            WeekDaysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            WeekDaysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            WeekDaysTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - UITableViewDataSource

extension HabitTimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDay", for: indexPath) as? WeekDayCell else {
            assertionFailure("Error: unable to get table view week day cell")
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        cell.dayLabel.text = WeekDays[indexPath.row].rawValue
        
        if indexPath.row == 0 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == WeekDays.count - 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorView.isHidden = true
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HabitTimetableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
}

// MARK: - WeekDayCellDelegate

extension HabitTimetableViewController: WeekDayCellDelegate {
    func addDayToTimetable(for cell: WeekDayCell) {
        guard let indexPath = WeekDaysTableView.indexPath(for: cell) else {
            assertionFailure("Error: unable to get index path for cell")
            return
        }
        timetable.insert(WeekDays[indexPath.row])
    }
    
    func removeDayFromTimetable(for cell: WeekDayCell) {
        guard let indexPath = WeekDaysTableView.indexPath(for: cell) else {
            assertionFailure("Error: unable to get index path for cell")
            return
        }
        timetable.remove(WeekDays[indexPath.row])
    }
}
