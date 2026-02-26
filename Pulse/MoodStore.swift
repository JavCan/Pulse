import Foundation
import SwiftUI

class MoodStore: ObservableObject {
    private let key = "moodEntries"
    private let defaults = UserDefaults.standard
    
    @Published private(set) var entries: [String: Int] = [:]
    
    init() {
        loadEntries()
    }
    
    // MARK: - Public API
    
    var todayMood: Int? {
        mood(for: Date())
    }
    
    func setMood(_ mood: Int) {
        let dateKey = Self.dateKey(for: Date())
        entries[dateKey] = mood
        saveEntries()
    }
    
    func mood(for date: Date) -> Int? {
        entries[Self.dateKey(for: date)]
    }
    
    // MARK: - Helpers
    
    private static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func loadEntries() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: Int].self, from: data) else { return }
        entries = decoded
    }
    
    private func saveEntries() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: key)
    }
}
