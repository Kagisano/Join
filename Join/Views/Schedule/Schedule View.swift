import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MapKit

struct ScheduleView: View {
    @State private var selectedDate = Date()
    @State private var schedule: [ScheduledEvent] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showNavigationSheet = false // Show the navigation popup
    @State private var isAddRidePresented = false // Controls presentation of AddRideView
    @Binding var activeHomeView: Bool // Binding to control the home view switch

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Fixed Top: Month-Year Header and Week Calendar
                VStack(spacing: 10) {
                    // Month-Year Header
                    HStack {
                        Text(monthAndYearName(for: selectedDate))
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Week Calendar
                    WeekCalendarView(selectedDate: $selectedDate)
                        .padding(.horizontal)
                        .onChange(of: selectedDate) { newDate in
                            loadScheduleForDate(newDate)
                        }
                }
                .background(Color(UIColor.systemGroupedBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)

                // Scrollable Middle: Upcoming Trips
                ScrollView {
                    VStack(spacing: 15) {
                        if isLoading {
                            ProgressView("Loading schedule...")
                                .padding(.vertical)
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.headline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else if schedule.isEmpty {
                            noTripsPlaceholder()
                        } else {
                            ForEach(schedule.prefix(4), id: \.id) { event in
                                HStack {
                                    // Trip Details
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(event.dropoff) // Destination
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("\(selectedDate, formatter: DateFormatter.shortTimeAndDateFormatter) • R\(String(format: "%.2f", event.tripFee))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(event.status)
                                            .font(.caption)
                                            .foregroundColor(event.status == "Cancelled" ? .red : .green)
                                    }

                                    Spacer()

                                    // Navigate Button
                                    Button(action: {
                                        print("View button tapped for \(event.id)")
                                        activeHomeView = false // Switch to TripView
                                        showNavigationSheet = true // Show navigation options popup
                                    }) {
                                        Text("Start Trip")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black) // Ensure text is black
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(UIColor.systemGray5))
                                            .cornerRadius(8)
                                    }
                                    .actionSheet(isPresented: $showNavigationSheet) {
                                        ActionSheet(
                                            title: Text("Choose a Navigation App"),
                                            message: Text("Your live location will be shared rider."),
                                            buttons: [
                                                .default(Text("Apple Maps"), action: openAppleMaps),
                                                .default(Text("Google Maps"), action: openGoogleMaps),
                                                .default(Text("Waze"), action: openWaze),
                                                .cancel()
                                            ]
                                        )
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 80) // Prevent overlapping with the navigation bar
                }
            }

            // Plus Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isAddRidePresented = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.turquoise)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(16) // Padding from the bottom and right edges
                }
            }
        }
        .onAppear {
            loadScheduleForDate(selectedDate)
        }
        .sheet(isPresented: $isAddRidePresented) {
            AddRideView(schedule: $schedule)
        }
    }

    // MARK: - Helper Methods

    private func loadScheduleForDate(_ date: Date) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            errorMessage = "User is not authenticated."
            return
        }

        isLoading = true
        errorMessage = nil

        let databaseRef = Database.database().reference().child("data").child("Trip")
        let dateKey = formattedFirebaseDateKey(for: date)

        databaseRef.observeSingleEvent(of: .value) { snapshot in
            var loadedSchedule: [ScheduledEvent] = []

            if let tripsData = snapshot.value as? [String: Any] {
                for (_, tripData) in tripsData {
                    if let tripDict = tripData as? [String: Any],
                       let tripDate = tripDict["date"] as? String,
                       let tripUserUID = tripDict["userUID"] as? String,
                       tripDate == dateKey,
                       tripUserUID == userUID {
                        if let rideType = tripDict["rideType"] as? String,
                           let pickup = tripDict["pickup"] as? String,
                           let dropoff = tripDict["dropoff"] as? String,
                           let timePref = tripDict["timePref"] as? String,
                           let timeslot = tripDict["timeslot"] as? String,
                           let status = tripDict["status"] as? String {
                            let event = ScheduledEvent(
                                id: UUID().uuidString,
                                userUID: tripUserUID,
                                rideType: rideType,
                                vehicleId: "Unknown",
                                date: tripDate,
                                direction: timePref,
                                tripStartTime: Date(),
                                tripEndTime: Date(),
                                pickup: pickup,
                                dropoff: dropoff,
                                timePref: timePref,
                                timeslot: timeslot,
                                tripFee: 0.0,
                                status: status
                            )
                            loadedSchedule.append(event)
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                isLoading = false
                schedule = loadedSchedule
            }
        } withCancel: { error in
            isLoading = false
            errorMessage = "Failed to load schedule: \(error.localizedDescription)"
        }
    }

    private func noTripsPlaceholder() -> some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                Text("No scheduled trips for this date.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func formattedFirebaseDateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func monthAndYearName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // MARK: - Navigation Actions

    private func openAppleMaps() {
        let coordinates = CLLocationCoordinate2D(latitude: -26.143841, longitude: 27.956158) // Coordinates for FNB Fairlands
        let place = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: place)
        mapItem.name = "FNB Fairlands"
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    private func openGoogleMaps() {
        let url = URL(string: "comgooglemaps://?daddr=-26.143841,27.956158&directionsmode=driving")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // If Google Maps is not installed, open in Safari
            UIApplication.shared.open(URL(string: "https://www.google.com/maps/dir/?api=1&destination=-26.143841,27.956158")!)
        }
    }

    private func openWaze() {
        let url = URL(string: "waze://?ll=-26.143841,27.956158&navigate=yes")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // If Waze is not installed, open in Safari
            UIApplication.shared.open(URL(string: "https://waze.com/ul?ll=-26.143841,27.956158&navigate=yes")!)
        }
    }
}

// MARK: - DateFormatter Extension

extension DateFormatter {
    static let shortTimeAndDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()
}
