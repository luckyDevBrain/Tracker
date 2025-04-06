//
//  HabitsViewController.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import UIKit

// MARK: - Protocol

/// Протокол делегата для обновления индексов
protocol DataProviderDelegate: AnyObject {
    func didUpdateIndexPath(_ updatedIndexes: UpdatedIndexes)
}

/// Протокол для управления навигационной панелью трекеров
protocol TrackersBarControllerProtocol: AnyObject {
    func addTrackerButtonDidTapped()
    func currentDateDidChange(for selectedDate: Date)
}

/// Протокол для сохранения нового трекера
protocol NewTrackerSaverDelegate: AnyObject {
    func save(tracker: Tracker, in category: TrackerCategory)
}

// MARK: - Structs

/// Структура для хранения параметров геометрии коллекции
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

// MARK: - Class Definition

/// Контроллер для отображения и управления трекерами
final class HabitsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var dataProvider: DataProviderProtocol = { createDataProvider() }()
    private var currentDate: Date = Date()
    private var searchTextFilter: String = ""
    private lazy var navigationBar = { createNavigationBar() }()
    private lazy var searchTextField = { createSearchTextField() }()
    private lazy var collectionView = { createCollectionView() }()
    private lazy var emptyCollectionPlaceholder = { EmptyStateView() }()
    private let params = GeometricParams(cellCount: 2,
                                         leftInset: 16,
                                         rightInset: 16,
                                         cellSpacing: 9)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhiteDay
        
        // Загрузим мок-данные в БД для тестирования пока нет функциональности добавления категорий
        // MockDataGenerator.setupRecords(with: dataProvider)
        
        addSubviews()
        addConstraints()
        loadData()
        
        // Для скрытия курсора с поля ввода при тапе вне поля ввода и вне клавиатуры
        let anyTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAnyTap))
        view.addGestureRecognizer(anyTapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func handleAnyTap(_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Private Methods
    
    private func createDataProvider() -> DataProvider {
        return DataProvider(delegate: self)
    }
    
    private func loadData() {
        dataProvider.setDateFilter(with: currentDate)
        dataProvider.loadData()
        collectionView.reloadData()
        updatePlaceholderType()
    }
}

// MARK: - Extensions

// MARK: - NewTrackerSaverDelegate
extension HabitsViewController: NewTrackerSaverDelegate {
    func save(tracker: Tracker, in category: TrackerCategory) {
        dataProvider.save(tracker: tracker, in: category)
        dataProvider.loadData() // Обновляем данные
        collectionView.reloadData()
        updatePlaceholderType()
        dismiss(animated: true)
    }
}

// MARK: - TrackerViewCellDelegate
extension HabitsViewController: TrackerViewCellProtocol {
    func trackerDoneButtonDidSwitched(to isCompleted: Bool, at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HabitCell,
              let trackerID = cell.tracker?.trackerID else { return }
        dataProvider.switchTracker(withID: trackerID, to: isCompleted, for: currentDate)
        cell.isCompleted = isCompleted
        cell.quantity = dataProvider.getCompletedRecordsForTracker(at: indexPath)
    }
}

// MARK: - TrackersBarControllerProtocol
extension HabitsViewController: TrackersBarControllerProtocol {
    func currentDateDidChange(for selectedDate: Date) {
        currentDate = selectedDate
        dataProvider.setDateFilter(with: selectedDate)
        collectionView.reloadData()
        updatePlaceholderType()
    }
    
    func addTrackerButtonDidTapped() {
        searchTextField.resignFirstResponder()
        let selectTrackerTypeViewController = HabitTypeSelectionViewController()
        selectTrackerTypeViewController.saverDelegate = self
        selectTrackerTypeViewController.dataProvider = dataProvider
        selectTrackerTypeViewController.modalPresentationStyle = .automatic
        present(selectTrackerTypeViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension HabitsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchTextFilter = textField.text?.trimmingCharacters(in: .whitespaces).lowercased() ?? ""
        dataProvider.setSearchTextFilter(with: searchTextFilter)
        collectionView.reloadData()
        updatePlaceholderType()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource
extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataProvider.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataProvider.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HabitCell.cellIdentifier,
            for: indexPath) as? HabitCell,
              let tracker = dataProvider.object(at: indexPath)
        else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isDoneButtonEnabled = !currentDate.isGreater(than: Date())
        cell.tracker = tracker
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: (collectionView.frame.width - params.paddingWidth) / CGFloat(params.cellCount),
            height: 90 + HabitCell.quantityCardHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: params.leftInset, bottom: 12, right: params.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HabitsSectionHeaderView.viewIdentifier,
            for: indexPath
           ) as? HabitsSectionHeaderView {
            view.headerLabel.text = dataProvider.getCategoryNameForTracker(at: indexPath)
            return view
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
}

// MARK: - DataProviderDelegate
extension HabitsViewController: DataProviderDelegate {
    func didUpdateIndexPath(_ updatedIndexes: UpdatedIndexes) {
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: updatedIndexes.deletedIndexes)
            collectionView.insertItems(at: updatedIndexes.insertedIndexes)
            
            if !updatedIndexes.deletedSections.isEmpty {
                collectionView.deleteSections(updatedIndexes.deletedSections)
            }
            if !updatedIndexes.insertedSections.isEmpty {
                collectionView.insertSections(updatedIndexes.insertedSections)
            }
        }
    }
}

// MARK: - Layout
private extension HabitsViewController {
    func createSearchTextField() -> UISearchTextField {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.delegate = self
        searchField.font = UIFont.systemFont(ofSize: 17)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }
    
    func createNavigationBar() -> HabitNavigationBar {
        let bar = HabitNavigationBar(frame: .zero, trackerBarDelegate: self)
        return bar
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitCell.self, forCellWithReuseIdentifier: HabitCell.cellIdentifier)
        collectionView.register(HabitsSectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HabitsSectionHeaderView.viewIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    func addSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        addPlaceholder()
    }
    
    func updatePlaceholderType() {
        if dataProvider.numberOfObjects != 0 {
            emptyCollectionPlaceholder.isHidden = true
        } else if searchTextFilter.isEmpty {
            emptyCollectionPlaceholder.isHidden = false
            emptyCollectionPlaceholder.placeholderType = .noData
        } else {
            emptyCollectionPlaceholder.isHidden = false
            emptyCollectionPlaceholder.placeholderType = .emptyList
        }
    }
    
    func addPlaceholder() {
        view.addSubview(emptyCollectionPlaceholder)
        emptyCollectionPlaceholder.isHidden = true
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 7),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyCollectionPlaceholder.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyCollectionPlaceholder.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
}
