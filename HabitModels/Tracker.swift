struct Tracker {
    let id: UUID
    let name: String
    let isRegular: Bool
    let emoji: String
    let color: UIColor
    let schedule: [WeekDay]?
    
    init(
        id: UUID = UUID(),
        name: String,
        isRegular: Bool,
        emoji: String,
        color: UIColor,
        schedule: [WeekDay]?
    ) {
        self.id = id
        self.name = name
        self.isRegular = isRegular
        self.emoji = emoji
        self.color = color
        self.schedule = schedule
    }
}

// Добавляем Hashable для использования в коллекциях
extension Tracker: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Tracker, rhs: Tracker) -> Bool {
        return lhs.id == rhs.id
    }
} 