import SwiftUI
import GoogleMaps
import CoreLocation

struct TripRequestView: View {
    @State private var selectedVehicleType: VehicleType = .sport
    @ObservedObject var viewModel: LocationSearchListViewModel
    @Binding var currentLocationText: String
    @Binding var destinationLocationText: String
    var originCoordinates: CLLocationCoordinate2D
    var destinationCoordinates: CLLocationCoordinate2D
    var selectedTimeSlot: String // Include this parameter

    var body: some View {
        VStack(spacing: 0) {
            // Map View Section
            RouteView(
                startCoordinate: originCoordinates,
                endCoordinate: destinationCoordinates
            )
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.top)

            // Main content of the screen
            TripRequestContentView(
                selectedVehicleType: $selectedVehicleType,
                currentLocationText: $currentLocationText,
                destinationLocationText: $destinationLocationText,
                originCoordinates: originCoordinates,
                destinationCoordinates: destinationCoordinates,
                selectedTimeSlot: selectedTimeSlot // Pass the selected time slot
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.white))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct TripRequestContentView: View {
    @Binding var selectedVehicleType: VehicleType
    @Binding var currentLocationText: String
    @Binding var destinationLocationText: String
    var originCoordinates: CLLocationCoordinate2D
    var destinationCoordinates: CLLocationCoordinate2D
    var selectedTimeSlot: String // Add this parameter

    var body: some View {
        VStack(spacing: 16) {
            // Header
            Text("Choose a trip")
                .font(.headline)
                .padding(.top)

            // Display the selected time slot
            Text("Selected time slot: \(selectedTimeSlot)")
                .font(.subheadline)
                .foregroundColor(.gray)

            // Ride Options
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(VehicleType.allCases) { vehicle in
                        rideOptionCard(for: vehicle)
                    }
                }
                .padding(.horizontal)
            }

            // Payment Section
            VStack(spacing: 16) {
                paymentType
                paymentButton
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }

    private func rideOptionCard(for vehicle: VehicleType) -> some View {
        let fee = calculateCarpoolFee(
            origin: originCoordinates,
            destination: destinationCoordinates,
            vehicleType: vehicle,
            tripDurationMinutes: 30, // Example trip duration
            numberOfPassengers: 1
        )

        return HStack {
            // Vehicle Image
            Image(vehicle.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80) // Reduced size
                .padding(.trailing, 8) // Adjusted padding

            // Ride Details
            VStack(alignment: .leading) {
                HStack {
                    Text(vehicle.title)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Text(String(format: "R%.2f", fee))
                        .font(.headline)
                        .foregroundColor(.black)
                }
                // Replace placeholder text with the selected time slot
                   Text("Pickup time: \(selectedTimeSlot)")
                       .font(.subheadline)
                       .foregroundColor(.gray)
               }

            Spacer()
        }
        .padding(.vertical, 8) // Reduced top and bottom padding
        .padding(.horizontal, 12) // Adjusted horizontal padding
        .background(selectedVehicleType == vehicle ? Color.white : Color.white.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedVehicleType == vehicle ? Color.black : Color.clear, lineWidth: 5)
        )
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            withAnimation(.spring()) {
                selectedVehicleType = vehicle
            }
        }
    }

    private var paymentType: some View {
        HStack {
            Image(systemName: "creditcard.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 24)
                .padding(.leading)

            Text("Visa •••• 2419")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    private var paymentButton: some View {
        Button(action: {
            // Action to confirm the ride
        }) {
            Text("Choose \(selectedVehicleType.title)")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

// Fee Calculation Logic
func calculateCarpoolFee(
    origin: CLLocationCoordinate2D,
    destination: CLLocationCoordinate2D,
    vehicleType: VehicleType,
    tripDurationMinutes: Double = 0,
    numberOfPassengers: Int = 1,
    serviceFeePercentage: Double = 0.20,
    minimumFare: Double = 50.0
) -> Double {
    let earthRadiusKm: Double = 6371.0

    let dLat = (destination.latitude - origin.latitude).degreesToRadians
    let dLon = (destination.longitude - origin.longitude).degreesToRadians

    let originLatRadians = origin.latitude.degreesToRadians
    let destinationLatRadians = destination.latitude.degreesToRadians

    let a = sin(dLat / 2) * sin(dLat / 2) +
            sin(dLon / 2) * sin(dLon / 2) * cos(originLatRadians) * cos(destinationLatRadians)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    let distanceKm = earthRadiusKm * c

    let distanceCost = distanceKm * vehicleType.ratePerKilometer
    let timeCost = tripDurationMinutes * vehicleType.ratePerMinute
    let tripCost = vehicleType.baseFare + distanceCost + timeCost

    let serviceFee = tripCost * serviceFeePercentage
    let totalCost = tripCost + serviceFee

    return max(totalCost / Double(numberOfPassengers), minimumFare)
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
}
