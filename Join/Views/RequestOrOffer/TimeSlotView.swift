import SwiftUI
import CoreLocation

struct TimeSlotSelectionView: View {
    @State private var timeType: String = "Arrive between"
    @State private var selectedTimeSlot: String = "09:00 - 10:00"
    @State private var showDropdown = false
    @State private var navigateToTripRequestView = false
    @State private var riderTrips: [String: Any] = [:] // Store fetched trips
    @State private var showAlert = false
    @State private var alertMessage = ""

    @StateObject private var tripService = FirebaseTripService()

    @ObservedObject var viewModel: LocationSearchListViewModel
    @Binding var currentLocationText: String
    @Binding var destinationLocationText: String
    var originCoordinates: CLLocationCoordinate2D
    var destinationCoordinates: CLLocationCoordinate2D
    var riderUserUID: String // User's UID from Firebase Authentication

    var body: some View {
        VStack {
            CustomHeaderBar(title: "Choose a timeslot")
            timeTypePicker
            timeSlotDropdown
            requestInformationText
            Spacer()
            nextButton
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Nearby Trips"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            fetchNearbyTrips()
        }
    }

    // MARK: - Time Type Picker
    private var timeTypePicker: some View {
        Picker("", selection: $timeType) {
            ForEach(["Arrive between", "Leave between"], id: \.self) { type in
                Text(type).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }

    // MARK: - Time Slot Dropdown
    private var timeSlotDropdown: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }) {
                HStack {
                    Text(selectedTimeSlot)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(showDropdown ? 180 : 0))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            if showDropdown {
                VStack(spacing: 0) {
                    ForEach(["07:00 - 08:00", "08:00 - 09:00", "09:00 - 10:00", "10:00 - 11:00"], id: \.self) { slot in
                        Button(action: {
                            selectedTimeSlot = slot
                            showDropdown = false
                        }) {
                            HStack {
                                Text(slot)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Request Information Text
    private var requestInformationText: some View {
        Text("Request to \(timeType.lowercased()) \(selectedTimeSlot)")
            .foregroundColor(.gray)
            .font(.subheadline)
            .padding(.horizontal)
    }

    // MARK: - Next Button
    private var nextButton: some View {
        Button(action: {
            createTrip()
        }) {
            Text("Next")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    // MARK: - Fetch Nearby Trips
    private func fetchNearbyTrips() {
        tripService.fetchTripsNearLocation(
            latitude: originCoordinates.latitude,
            longitude: originCoordinates.longitude,
            precision: 6 // Adjust precision for proximity
        ) { result in
            switch result {
            case .success(let trips):
                if !trips.isEmpty {
                    alertMessage = "Found \(trips.count) nearby trips!"
                } else {
                    alertMessage = "No nearby trips found."
                }
                showAlert = true
            case .failure(let error):
                alertMessage = "Error fetching nearby trips: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    // MARK: - Create Trip
    private func createTrip() {
        let tripID = UUID().uuidString
        let rideType = "Priority" // Example ride type; replace with dynamic input if needed
        let tripFee = 50.0 // Example trip fee; replace with calculated value if needed

        tripService.createTrip(
            tripID: tripID,
            riderUserUID: riderUserUID,
            originCoordinates: originCoordinates,
            destinationCoordinates: destinationCoordinates,
            timeType: timeType,
            selectedTimeSlot: selectedTimeSlot,
            rideType: rideType,
            tripFee: tripFee
        ) { result in
            switch result {
            case .success:
                print("Trip created successfully!")
                navigateToTripRequestView = true
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
