//
//  HabitsViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Protocols

protocol TrackersBarControllerProtocol: AnyObject {
    func addTrackerButtonDidTapped()
    func currentDateDidChange(for selectedDate: Date)
}

protocol HabitSaverDelegate: AnyObject {
    func save(tracker: Tracker, in categoryID: UUID)
}

// MARK: - Class Definition

/// Контроллер для управления списком привычек
final class HabitsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(categoryID: UUID(),
                        name: "Домашний уют",
                        trackersInCategory: [
                            Tracker(name: "Забрать посылку на wildberries",
                                    isRegular: true,
                                    emoji: "❤️",
                                    color: .ypColorSelection5,
                                    schedule: [.mon, .tue]),
                            Tracker(name: "Спланировать отпуск",
                                    isRegular: false,
                                    emoji: "🏝️",
                                    color: .ypColorSelection2,
                                    schedule: nil),
                            Tracker(name: "Приготовить вкусный ужин",
                                    isRegular: true,
                                    emoji: "🤔",
                                    color: .ypColorSelection15,
                                    schedule: [.sun]),
                        ]),
        TrackerCategory(categoryID: UUID(),
                        name: "Занятия спортом",
                        trackersInCategory: []),
        TrackerCategory(categoryID: UUID(),
                        name: "Радостные мелочи",
                        trackersInCategory: [
                            Tracker(name: "Созвон в зуме в 19:00",
                                    isRegular: true,
                                    emoji: "😻",
                                    color: .ypColorSelection3,
                                    schedule: nil),
                            Tracker(name: "Посмотреть интересный фильм/сериал!",
                                    isRegular: true,
                                    emoji: "❤️",
                                    color: .ypColorSelection1,
                                    schedule: [.fri, .sat, .tue, .mon]),
                            Tracker(name: "Выгулять пёпселя",
                                    isRegular: false,
                                    emoji: "🐶",
                                    color: .ypColorSelection18,
                                    schedule: Array(WeekDay.allCases)),
                        ]),
        TrackerCategory(categoryID: UUID(),
                        name: "Самочувствие",
                        trackersInCategory: [])
    ]
    
    private var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackerIDs: Set<UUID> = []
    private var completedTrackersCounter: [UUID: Int] = [:]
    
    private var currentDate: Date = Date()
    private var searchFilterText: String = ""
    
    private lazy var navBar = { createNavigationBar() }()
    private lazy var searchField = { createSearchField() }()
    private lazy var habitsCollection = { createHabitsCollection() }()
    private lazy var emptyStateView = { EmptyStateView() }()
    
    private let layoutParams = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        setupSubviews()
        setupConstraints()
        reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchField.resignFirstResponder()
    }
    
    // MARK: - Private Methods
    
    private func reloadData() {
        completedTrackerIDs = fetchCompletedTrackerIDs(for: currentDate)
        initializeCompletionCounters()
        updateVisibleCategories()
        habitsCollection.reloadData()
    }
    
    private func initializeCompletionCounters() {
        completedTrackers.forEach { record in
            completedTrackersCounter[record.trackerID] = (completedTrackersCounter[record.trackerID] ?? 0) + 1
        }
    }
    
    private func isDateMatching(_ date: Date, schedule: [WeekDay]?) -> Bool {
        guard let schedule else { return true }
        if let weekday = WeekDay(rawValue: Calendar.current.component(.weekday, from: date)) {
            return schedule.contains(weekday)
        }
        return false
    }
    
    private func isNameMatching(_ name: String, searchText: String) -> Bool {
        searchText.isEmpty || name.lowercased().contains(searchText.lowercased())
    }
    
    private func updateVisibleCategories() {
        let filteredCategories = categories.compactMap { category -> TrackerCategory? in
            let visibleTrackers = category.trackersInCategory.filter {
                (!$0.isRegular || isDateMatching(currentDate, schedule: $0.schedule)) &&
                isNameMatching($0.name, searchText: searchFilterText)
            }
            return visibleTrackers.isEmpty ? nil : TrackerCategory(
                categoryID: category.categoryID,
                name: category.name,
                trackersInCategory: visibleTrackers
            )
        }
        visibleCategories = filteredCategories
        updateEmptyStateVisibility()
    }
    
    private func isTrackerCompleted(withId trackerID: UUID) -> Bool {
        completedTrackerIDs.contains(trackerID)
    }
    
    private func markTrackerCompleted(withID trackerID: UUID) {
        let record = TrackerRecord(trackerID: trackerID, dateCompleted: currentDate)
        completedTrackers.append(record)
        completedTrackerIDs.insert(trackerID)
        completedTrackersCounter[trackerID] = (completedTrackersCounter[trackerID] ?? 0) + 1
    }
    
    private func markTrackerUncompleted(withID trackerID: UUID) {
        if completedTrackerIDs.contains(trackerID) {
            completedTrackerIDs.remove(trackerID)
            if let count = completedTrackersCounter[trackerID], count > 1 {
                completedTrackersCounter[trackerID] = count - 1
            } else {
                completedTrackersCounter.removeValue(forKey: trackerID)
            }
        }
        for (index, record) in completedTrackers.enumerated() {
            if Calendar.current.isDate(record.dateCompleted, inSameDayAs: currentDate) {
                completedTrackers.remove(at: index)
                break
            }
        }
    }
    
    private func fetchCompletedTrackerIDs(for date: Date) -> Set<UUID> {
        Set(completedTrackers.filter {
            Calendar.current.isDate($0.dateCompleted, inSameDayAs: date)
        }.map { $0.trackerID })
    }
    
    private func getCompletionCount(for trackerID: UUID) -> Int {
        completedTrackersCounter[trackerID] ?? 0
    }
    
    private func saveHabit(_ habit: Tracker, in categoryID: UUID) {
        guard let index = categories.firstIndex(where: { $0.categoryID == categoryID }) else {
            assertionFailure("Failed to save habit in category \(categoryID)")
            return
        }
        var trackers = categories[index].trackersInCategory
        trackers.append(habit)
        categories[index] = TrackerCategory(
            categoryID: categoryID,
            name: categories[index].name,
            trackersInCategory: trackers
        )
    }
}

// MARK: - HabitSaverDelegate

extension HabitsViewController: HabitSaverDelegate {
    func save(tracker: Tracker, in categoryID: UUID) {
        saveHabit(tracker, in: categoryID)
        updateVisibleCategories()
        habitsCollection.reloadData()
        dismiss(animated: true)
    }
}

// MARK: - TrackerViewCellProtocol

extension HabitsViewController: TrackerViewCellProtocol {
    func trackerDoneButtonDidTapped(for trackerID: UUID) {
        if isTrackerCompleted(withId: trackerID) {
            markTrackerUncompleted(withID: trackerID)
        } else {
            markTrackerCompleted(withID: trackerID)
        }
    }
    
    func trackerCounterValue(for trackerID: UUID) -> Int {
        getCompletionCount(for: trackerID)
    }
}

// MARK: - TrackersBarControllerProtocol

extension HabitsViewController: TrackersBarControllerProtocol {
    func addTrackerButtonDidTapped() {
        print("addTrackerButtonDidTapped called")
        searchField.resignFirstResponder()
        let typeSelectionVC = HabitTypeSelectionViewController()
        typeSelectionVC.habitSaverDelegate = self
        typeSelectionVC.modalPresentationStyle = .automatic
        present(typeSelectionVC, animated: true)
    }
    
    func currentDateDidChange(for selectedDate: Date) {
        currentDate = selectedDate
        completedTrackerIDs = fetchCompletedTrackerIDs(for: currentDate)
        updateVisibleCategories()
        habitsCollection.reloadData()
    }
}

// MARK: - UITextFieldDelegate

extension HabitsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchFilterText = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        updateVisibleCategories()
        habitsCollection.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackersInCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitViewCell.cellIdentifier, for: indexPath) as? HabitViewCell
        else { return UICollectionViewCell() }
        
        let tracker = visibleCategories[indexPath.section].trackersInCategory[indexPath.row]
        
        cell.delegate = self
        cell.trackerID = tracker.trackerID
        cell.cellName = tracker.name
        cell.cellColor = tracker.color
        cell.emoji = tracker.emoji
        cell.isCompleted = isTrackerCompleted(withId: tracker.trackerID)
        cell.quantity = getCompletionCount(for: tracker.trackerID)
        
        let isFutureDate = Calendar.current.compare(Date(), to: currentDate, toGranularity: .day) == .orderedAscending
        cell.isDoneButtonEnabled = !isFutureDate
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - layoutParams.paddingWidth) / CGFloat(layoutParams.cellCount),
               height: 90 + HabitViewCell.quantityCardHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        layoutParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: layoutParams.leftInset, bottom: 12, right: layoutParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HabitsSectionHeaderView.viewIdentifier,
                for: indexPath
              ) as? HabitsSectionHeaderView
        else { return UICollectionReusableView() }
        
        view.headerLabel.text = visibleCategories[indexPath.section].name
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 18)
    }
}

// MARK: - Layout

private extension HabitsViewController {
    func createSearchField() -> UISearchTextField {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.delegate = self
        searchField.font = UIFont.systemFont(ofSize: 17)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }
    
    func createNavigationBar() -> HabitNavigationBar {
        HabitNavigationBar(frame: .zero, habitBarDelegate: self)
    }
    
    func createHabitsCollection() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitViewCell.self, forCellWithReuseIdentifier: HabitViewCell.cellIdentifier)
        collectionView.register(HabitsSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HabitsSectionHeaderView.viewIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    func setupSubviews() {
        view.addSubview(navBar)
        view.addSubview(searchField)
        view.addSubview(habitsCollection)
        addEmptyStateView()
    }
    
    func updateEmptyStateVisibility() {
        emptyStateView.isHidden = !categories.isEmpty && !visibleCategories.isEmpty
        emptyStateView.placeholderType = categories.isEmpty ? .noData : .emptyList
    }
    
    func addEmptyStateView() {
        view.addSubview(emptyStateView)
        updateEmptyStateVisibility()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 7),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            habitsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitsCollection.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            habitsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitsCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: habitsCollection.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: habitsCollection.centerYAnchor)
        ])
    }
}

// MARK: - GeometricParams

private struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
