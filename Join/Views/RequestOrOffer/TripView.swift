import SwiftUI
import GoogleMaps

struct TripView: View {
    @Binding var activeHomeView: Bool // Control the view switching
    @StateObject private var locationManager = LocationManager()
    @State private var isGeolocationButtonTapped = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Google Map Section
                mapSection

                // Trip Card Section
                TripCardView(
                    fromTitle: "From",
                    fromLocation: locationManager.currentLocation?.coordinateDescription ?? "Unknown",
                    fromTime: "07:00 AM",
                    toTitle: "To",
                    toLocation: "Work Address",
                    toTime: "09:00 AM",
                    disclaimer: "Your trip is scheduled for 07:00 - 08:00.",
                    price: "R120.00",
                    activeHomeView: $activeHomeView
                )
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true) // Hide the navigation bar completely
        }
        .onChange(of: isGeolocationButtonTapped) { tapped in
            handleGeolocationTap(tapped)
        }
    }

    // MARK: - Map Section
    private var mapSection: some View {
        ZStack {
            GoogleMapViews(userLocation: $locationManager.currentLocation)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.6) // Limit map height

            // Geolocation Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    geolocationButton
                }
            }
        }
    }

    // MARK: - Geolocation Button
    private var geolocationButton: some View {
        Button(action: {
            isGeolocationButtonTapped = true
        }) {
            Image(systemName: "location.fill")
                .frame(width: 50, height: 50)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }

    // MARK: - Handle Geolocation Tap
    private func handleGeolocationTap(_ tapped: Bool) {
        if tapped, let location = locationManager.currentLocation {
            // Handle map recentering logic
            print("Recenter map to: \(location.coordinateDescription)")
            isGeolocationButtonTapped = false
        }
    }
}

extension CLLocation {
    var coordinateDescription: String {
        "\(coordinate.latitude), \(coordinate.longitude)"
    }
}
