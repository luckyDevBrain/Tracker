struct TrackerCategory {
    let id: UUID
    let title: String
    let trackers: [Tracker]
    
    init(
        id: UUID = UUID(),
        title: String,
        trackers: [Tracker] = []
    ) {
        self.id = id
        self.title = title
        self.trackers = trackers
    }
    
    // Добавляем метод для сортировки трекеров
    func sortedTrackers() -> [Tracker] {
        return trackers.sorted { $0.name < $1.name }
    }
} 