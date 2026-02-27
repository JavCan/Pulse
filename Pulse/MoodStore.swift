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
    
    func setMood(_ mood: Int, for date: Date = Date()) {
        let dateKey = Self.dateKey(for: date)
        entries[dateKey] = mood
        saveEntries()
    }
    
    func mood(for date: Date) -> Int? {
        entries[Self.dateKey(for: date)]
    }
    
    // MARK: - Insights
    
    var moodInsight: String? {
        // Group entries by weekday (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        // Note: the keys are "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var weekdayScores: [Int: [Int]] = [:]
        
        for (dateString, mood) in entries {
            guard let date = formatter.date(from: dateString) else { continue }
            let weekday = Calendar.current.component(.weekday, from: date)
            weekdayScores[weekday, default: []].append(mood)
        }
        
        // Emotion scale: 1-2 Positive, 3 Neutral, 4-5 Negative
        // Only consider weekdays with at least 2 entries to avoid single day spikes
        
        var negativeWeekday: Int? = nil
        var negativeAvg: Double = 0.0
        
        var positiveWeekday: Int? = nil
        var positiveAvg: Double = 5.0
        
        var neutralWeekday: Int? = nil
        var neutralDistance: Double = 5.0
        
        for (weekday, scores) in weekdayScores {
            guard scores.count >= 2 else { continue }
            let average = Double(scores.reduce(0, +)) / Double(scores.count)
            
            if average >= 3.5 {
                if average > negativeAvg {
                    negativeAvg = average
                    negativeWeekday = weekday
                }
            } else if average <= 2.5 {
                if average < positiveAvg {
                    positiveAvg = average
                    positiveWeekday = weekday
                }
            } else {
                let distance = abs(average - 3.0)
                if distance < neutralDistance {
                    neutralDistance = distance
                    neutralWeekday = weekday
                }
            }
        }
        
        // Prioritize showing negative trends to offer help, then positive, then neutral
        if let negativeDay = negativeWeekday {
            let dayName = calendarWeekdayName(for: negativeDay)
            return "You tend to feel not so good on \(dayName)s, how about a guided meditation?"
        } else if let positiveDay = positiveWeekday {
            let dayName = calendarWeekdayName(for: positiveDay)
            return "You usually feel great on \(dayName)s! Keep that positive energy going."
        } else if let neutralDay = neutralWeekday {
            let dayName = calendarWeekdayName(for: neutralDay)
            return "\(dayName)s seem to be calm and balanced days for you. Keep staying grounded!"
        }
        
        // Default message if no significant trend or enough data
        return "Keep logging your moods to see weekly insights here!"
    }
    
    // MARK: - Helpers
    
    private func calendarWeekdayName(for weekday: Int) -> String {
        // weekday: 1=Sunday, 2=Monday, ..., 7=Saturday
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1]
    }
    
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
