//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 3/12/24.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Private Properties

    private let topView = UIView()
    private let navigationView = UIView()
    private let middleView = UIView()
    private let createNewTrackerButton = UIButton(type: .system)
    private let datePicker = UIDatePicker()
    private let trackersLabel = UILabel()
    private let emptyListLabel = UILabel()
    private let trackersSearchBar = UISearchBar()
    private let emptyListImageView = UIImageView(image: UIImage.emptyListOfTrackersStub)
    private let trackersCollectionView = UICollectionView(frame: CGRect.zero,
                                                          collectionViewLayout: UICollectionViewFlowLayout())
    private let tapGesture = UITapGestureRecognizer()
    private let geometricParameters = CollectionGeometricParameters(numberOfCells: 2,
                                                                    rightInset: 16,
                                                                    leftInset: 16,
                                                                    cellSpacing: 9)
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var chosenCategories: [TrackerCategory] = []
    private var chosenDate: Date = Date()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: убрать тест, когда добавлю функционал выбора категории
        categories.append(TrackerCategory(header: "Test", trackers: []))
        // Конец теста

        setupViews()
        setupLayout()
        datePickerValueChanged(datePicker)
    }

    // MARK: - Private Methods

    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
        chosenDate = datePicker.date
        let calendar = Calendar.current
        let weekDayNumber = calendar.component(.weekday, from: datePicker.date)
        let weekDay = convertIntToAbbreviated(number: weekDayNumber)

        let allTrackers = categories.flatMap { $0.trackers }
        let matchingTrackers = allTrackers.filter { $0.timetable.contains(weekDay) }

        let updatedCategories: [TrackerCategory] = categories.compactMap { category -> TrackerCategory? in
            let trackersInCategory = category.trackers.filter { tracker in
                matchingTrackers.contains(where: { $0.id == tracker.id })
            }
            if trackersInCategory.isEmpty { return nil }
            return TrackerCategory(header: category.header, trackers: trackersInCategory)
        }

        chosenCategories = updatedCategories
        trackersCollectionView.isHidden = chosenCategories.isEmpty
        trackersCollectionView.reloadData()
    }

    @objc private func didTapCreateTracker() {
        let trackerTypeSelectionViewController = TrackerTypeSelectionViewController()
        trackerTypeSelectionViewController.trackersViewController = self
        present(trackerTypeSelectionViewController, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupViews() {
        view.backgroundColor = UIColor.ypWhite

        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)

        navigationView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(navigationView)

        middleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(middleView)

        createNewTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        createNewTrackerButton.setImage(UIImage.addTracker, for: .normal)
        createNewTrackerButton.addTarget(self, action: #selector(didTapCreateTracker), for: .touchUpInside)
        createNewTrackerButton.tintColor = UIColor.ypBlack
        navigationView.addSubview(createNewTrackerButton)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.compact
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationView.addSubview(datePicker)

        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersLabel.textColor = UIColor.ypBlack
        trackersLabel.text = "Трекеры"
        trackersLabel.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        topView.addSubview(trackersLabel)

        // TODO: У searchBar дополнительные отступы. Их нужно убрать. Или реализовать строку поиска по-другому (не через searchBar)
        trackersSearchBar.translatesAutoresizingMaskIntoConstraints = false
        trackersSearchBar.placeholder = "Поиск"
        trackersSearchBar.delegate = self
        trackersSearchBar.backgroundImage = UIImage()
        topView.addSubview(trackersSearchBar)

        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        emptyListImageView.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(emptyListImageView)

        emptyListLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListLabel.text = "Что будем отслеживать?"
        emptyListLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        middleView.addSubview(emptyListLabel)

        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        trackersCollectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "trackerCell")
        trackersCollectionView.register(CollectionViewHeader.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: "header")
        view.addSubview(trackersCollectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            navigationView.topAnchor.constraint(equalTo: topView.topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),

            createNewTrackerButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: -10),
            createNewTrackerButton.topAnchor.constraint(equalTo: navigationView.topAnchor),
            createNewTrackerButton.widthAnchor.constraint(equalToConstant: 44),
            createNewTrackerButton.heightAnchor.constraint(equalToConstant: 44),
            navigationView.bottomAnchor.constraint(equalTo: createNewTrackerButton.bottomAnchor),

            datePicker.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor),
            datePicker.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),

            trackersLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            trackersLabel.topAnchor.constraint(equalTo: navigationView.bottomAnchor),

            trackersSearchBar.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 7),
            trackersSearchBar.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            trackersSearchBar.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: trackersSearchBar.bottomAnchor),

            middleView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            middleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            middleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            emptyListImageView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            emptyListImageView.centerYAnchor.constraint(equalTo: middleView.centerYAnchor),

            emptyListLabel.topAnchor.constraint(equalTo: emptyListImageView.bottomAnchor, constant: 8),
            emptyListLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),

            trackersCollectionView.topAnchor.constraint(equalTo: middleView.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor)
        ])
    }

    private func createAttributedText(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        return NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium),
                         .paragraphStyle: paragraphStyle]
        )
    }

    private func updateNumberOfDaysLabel(cell: TrackerCell, id: UUID) {
        let numberOfCompletions = completedTrackers.filter { $0.id == id }.count
        cell.updateNumberOfDaysLabel(numberOfCompletions: numberOfCompletions)
    }

    private func convertIntToAbbreviated(number: Int) -> AbbreviatedWeekDay {
        return switch number {
        case 1: .sunday
        case 2: .monday
        case 3: .tuesday
        case 4: .wednesday
        case 5: .thursday
        case 6: .friday
        case 7: .saturday
        default:
            preconditionFailure("Invalid weekday number: \(number). Valid range is 1 to 7.")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chosenCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = chosenCategories[section]
        return category.trackers.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let tracker = chosenCategories[section].trackers[row]
        let trackerRecord = TrackerRecord(id: tracker.id, date: chosenDate)
        let isCompleted = completedTrackers.contains(trackerRecord)

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "trackerCell",
            for: indexPath
        ) as? TrackerCell else {
            assertionFailure("Error: unable to get tracker cell")
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configureUI(attributedName: createAttributedText(tracker.name), color: tracker.color, emoji: tracker.emoji)

        updateNumberOfDaysLabel(cell: cell, id: tracker.id)

        let image = isCompleted ?
        UIImage(
            systemName: "checkmark",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .heavy)
        ) :
        UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        )
        cell.configureCompletedButton(isCompleted: isCompleted, image: image)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: geometricParameters.leftInset,
            bottom: 0,
            right: geometricParameters.rightInset
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - geometricParameters.paddingWidth
        let cellWidth = floor(availableWidth / CGFloat(geometricParameters.numberOfCells) - 1)
        return CGSize(width: cellWidth, height: 140)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? CollectionViewHeader else {
            return UICollectionReusableView()
        }

        let section = indexPath.section
        header.configureUI(header: chosenCategories[section].header)
        return header
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        let size = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                             height: UIView.layoutFittingCompressedSize.height),
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    // TODO: добавить функционал поиска если нужно

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func didTapTrackerCompletedButton(for cell: TrackerCell) {
        if chosenDate > Date() { return }
        cell.updateCompletedButtonAppearance()
    }

    func addTrackerRecord(for cell: TrackerCell) {
        guard let indexPath = trackersCollectionView.indexPath(for: cell) else {
            assertionFailure("Error: unable to get index path for cell")
            return
        }
        let id = chosenCategories[indexPath.section].trackers[indexPath.row].id
        let trackerRecord = TrackerRecord(id: id, date: chosenDate)
        completedTrackers.insert(trackerRecord)

        updateNumberOfDaysLabel(cell: cell, id: id)
    }

    func removeTrackerRecord(for cell: TrackerCell) {
        guard let indexPath = trackersCollectionView.indexPath(for: cell) else {
            assertionFailure("Error: unable to get index path for cell")
            return
        }
        let id = chosenCategories[indexPath.section].trackers[indexPath.row].id
        let trackerRecord = TrackerRecord(id: id, date: chosenDate)
        completedTrackers.remove(trackerRecord)

        updateNumberOfDaysLabel(cell: cell, id: id)
    }
}

// MARK: - CreateHabitViewControllerDelegate

extension TrackersViewController: CreateHabitViewControllerDelegate {
    func addTracker(_ tracker: Tracker, to categoryName: String) {
        for currentCategory in categories where currentCategory.header == categoryName {
            let trackers = currentCategory.trackers
            let newCategory = TrackerCategory(header: categoryName, trackers: trackers + [tracker])
            let newCategories = categories.filter { $0.header != categoryName } + [newCategory]
            categories = newCategories
        }
        datePickerValueChanged(datePicker)
    }
}
