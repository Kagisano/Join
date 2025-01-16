import Foundation
import SwiftUI

struct ScheduledEvent: Identifiable, Equatable {
    let id: String
    var userUID: String
    var rideType: String
    var vehicleId: String
    var date: String
    var direction: String
    var tripStartTime: Date
    var tripEndTime: Date
    var pickup: String
    var dropoff: String
    var timePref: String
    var timeslot: String
    var tripFee: Double
    var status: String

    var statusColor: Color {
        switch status {
        case "Pending": return .orange
        case "Confirmed": return .green
        case "Completed": return .gray
        default: return .black
        }
    }

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var tripStartTimeFormatted: String {
        Self.timeFormatter.string(from: tripStartTime)
    }

    var tripEndTimeFormatted: String {
        Self.timeFormatter.string(from: tripEndTime)
    }
}
