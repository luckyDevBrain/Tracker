struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
    
    // Функции хеширования для протокола Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
    }
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.id == rhs.id && Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
    }
} 