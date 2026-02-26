import SwiftUI

struct MoodCalendarView: View {
    @ObservedObject var moodStore: MoodStore
    @Environment(\.dismiss) var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Month title
                Text(monthYearString)
                    .font(Font.custom("Comfortaa", size: 24).weight(.bold))
                    .foregroundColor(.Clay)
                    .padding(.top, 20)
                
                // Weekday headers
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(weekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(Font.custom("Comfortaa", size: 11).weight(.medium))
                            .foregroundColor(.Clay.opacity(0.5))
                    }
                }
                .padding(.horizontal, 20)
                
                // Calendar grid
                LazyVGrid(columns: columns, spacing: 10) {
                    // Empty cells for offset
                    ForEach(0..<firstWeekdayOffset, id: \.self) { _ in
                        Color.clear
                            .frame(height: 52)
                    }
                    
                    // Day cells
                    ForEach(1...daysInMonth, id: \.self) { day in
                        let date = dateFor(day: day)
                        let mood = moodStore.mood(for: date)
                        let isToday = Calendar.current.isDateInToday(date)
                        
                        VStack(spacing: 2) {
                            Text("\(day)")
                                .font(Font.custom("Comfortaa", size: 12).weight(isToday ? .bold : .regular))
                                .foregroundColor(isToday ? .SalviaGreen : .Clay.opacity(0.7))
                            
                            if let mood = mood {
                                Image("\(mood)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                            } else {
                                Circle()
                                    .fill(Color.PalidSand.opacity(0.4))
                                    .frame(width: 28, height: 28)
                            }
                        }
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isToday ? Color.GlaciarBlue.opacity(0.3) : Color.clear)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 40)
            
            // Floating Close Button
            VStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.red.opacity(0.5))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Calendar Helpers
    
    private var currentDate: Date { Date() }
    
    private var calendar: Calendar { Calendar.current }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    private var daysInMonth: Int {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return range.count
    }
    
    /// Offset for the first day of the month (Monday = 0)
    private var firstWeekdayOffset: Int {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let firstOfMonth = calendar.date(from: components)!
        // weekday: 1=Sunday, 2=Monday, ..., 7=Saturday
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        // Convert to Monday-based: Mon=0, Tue=1, ..., Sun=6
        return (weekday + 5) % 7
    }
    
    private func dateFor(day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        return calendar.date(from: components) ?? currentDate
    }
}

#Preview {
    NavigationStack {
        MoodCalendarView(moodStore: MoodStore())
    }
}
