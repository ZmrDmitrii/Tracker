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
    private let weekDaysTableView = UITableView()
    private let doneButton = UIButton(type: .system)
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

        weekDaysTableView.translatesAutoresizingMaskIntoConstraints = false
        weekDaysTableView.dataSource = self
        weekDaysTableView.delegate = self
        weekDaysTableView.register(WeekDayCell.self, forCellReuseIdentifier: "WeekDay")
        weekDaysTableView.isScrollEnabled = false
        weekDaysTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        weekDaysTableView.separatorStyle = .none
        view.addSubview(weekDaysTableView)

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

            weekDaysTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            weekDaysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDaysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDaysTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),

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
        Constants.weekDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDay", for: indexPath) as? WeekDayCell else {
            assertionFailure("Error: unable to get table view week day cell")
            return UITableViewCell()
        }

        cell.delegate = self
        cell.configureDayLabelText(indexPath: indexPath)

        if indexPath.row == 0 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == Constants.weekDays.count - 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.hideSeparatorView()
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
        guard let indexPath = weekDaysTableView.indexPath(for: cell) else {
            assertionFailure("Error: unable to get index path for cell")
            return
        }
        timetable.insert(Constants.weekDays[indexPath.row])
    }

    func removeDayFromTimetable(for cell: WeekDayCell) {
        guard let indexPath = weekDaysTableView.indexPath(for: cell) else {
            assertionFailure("Error: unable to get index path for cell")
            return
        }
        timetable.remove(Constants.weekDays[indexPath.row])
    }
}
