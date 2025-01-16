import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    @State private var formattedDateForDatabase: String = ""

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(currentWeekDates(), id: \.self) { date in
                    VStack {
                        Text(weekdayName(for: date))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(dayString(from: date))
                            .font(.headline)
                            .frame(width: 40, height: 40)
                            .background(circleBackground(for: date))
                            .foregroundColor(circleForeground(for: date))
                            .cornerRadius(20)
                            .onTapGesture {
                                selectedDate = date
                                formattedDateForDatabase = formatDateForDatabase(date: selectedDate)
                                print("Selected date for database: \(formattedDateForDatabase)")
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 10)
        }
    }

    // MARK: - Helpers

    private func circleBackground(for date: Date) -> Color {
        if Calendar.current.isDate(date, inSameDayAs: selectedDate) && Calendar.current.isDate(date, inSameDayAs: Date()) {
            return Color.black
        } else if Calendar.current.isDate(date, inSameDayAs: selectedDate) {
            return Color.black
        } else if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return Color.gray.opacity(0.3)
        } else {
            return Color.clear
        }
    }

    private func circleForeground(for date: Date) -> Color {
        if Calendar.current.isDate(date, inSameDayAs: selectedDate) && Calendar.current.isDate(date, inSameDayAs: Date()) {
            return .white
        } else if Calendar.current.isDate(date, inSameDayAs: selectedDate) {
            return .white
        } else if Calendar.current.isDate(date, inSameDayAs: Date()) {
            return .black
        } else {
            return .primary
        }
    }

    private func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private func weekdayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func formatDateForDatabase(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date) // Example: "2025-01-08"
    }
}
