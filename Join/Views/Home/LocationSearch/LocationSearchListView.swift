import SwiftUI
import GooglePlaces
import CoreLocation

struct LocationSearchListView: View {
    @Binding var officeLocation: String
    @State private var currentLocationText = ""
    @State private var destinationLocationText = ""
    @State private var isListVisible = false
    @FocusState private var activeField: ActiveField?
    @StateObject private var locationManager = LocationManager()
    @EnvironmentObject var viewModel: LocationSearchListViewModel

    @State private var originCoordinates: CLLocationCoordinate2D? = nil
    @State private var destinationCoordinates: CLLocationCoordinate2D? = nil
    @State private var navigateToTripRequest: Bool = false

    enum ActiveField {
        case currentLocation, destinationLocation
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CustomHeaderBar(title: "Your Journey", activeView: .constant(nil))

                inputFields
                Divider()
                ScrollView {
                    locationSuggestionsList
                }
                Spacer()

                navigationLinkToTimeSlotSelection
            }
            .background(Color.white)
            .onAppear(perform: setupView)
            .onReceive(locationManager.$currentLocation) { location in
                if let location = location?.coordinate {
                    print("Updating originCoordinates: \(location.latitude), \(location.longitude)")
                    originCoordinates = location
                }
            }
            .onChange(of: locationManager.currentAddress, perform: updateCurrentLocation)
            .toolbar(.hidden)
        }
    }

    private var inputFields: some View {
        VStack {
            HStack {
                VStack {
                    Circle().fill(Color(.systemGray3)).frame(width: 6, height: 6)
                    Rectangle().fill(Color(.systemGray4)).frame(width: 2, height: 33)
                    Circle().fill(Color.black).frame(width: 7, height: 7)
                }
                VStack(spacing: 10) {
                    locationTextField(
                        "Pickup Address",
                        text: $currentLocationText,
                        field: .currentLocation
                    )
                    locationTextField(
                        "To where?",
                        text: $destinationLocationText,
                        field: .destinationLocation
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    // MARK: - Location Suggestions List
        private var locationSuggestionsList: some View {
            VStack(alignment: .leading, spacing: 0) {
                // Static "Home" and "Work" rows
                NavigationLink(destination: AddressSearchView(title: "Home")) {
                    DestinationRowView(icon: "bed.double.fill", title: "Home", subtitle: "Set once and go")
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: AddressSearchView(title: "Work")) {
                    DestinationRowView(icon: "briefcase.fill", title: "Work", subtitle: "Set once and go")
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Divider()

                // Predictions List
                if isListVisible && !viewModel.places.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(viewModel.places, id: \.placeID) { place in
                            Button(action: { handlePlaceSelection(place) }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title3)
                                        .foregroundColor(.gray)
                                        .frame(width: 40, height: 40)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(place.attributedPrimaryText.string)
                                            .font(.headline)
                                        if let secondaryText = place.attributedSecondaryText?.string {
                                            Text(secondaryText)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())

                            if place != viewModel.places.last {
                                Divider()
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            .ignoresSafeArea()
        }

    private func setupView() {
        locationManager.requestLocation()
    }
    
    private func locationTextField(_ placeholder: String, text: Binding<String>, field: ActiveField) -> some View {
        TextField(placeholder, text: text)
            .focused($activeField, equals: field)
            .accentColor(.black)
            .padding(.horizontal)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.29), radius: 4, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(activeField == field ? Color.black : Color.clear, lineWidth: 2)
            )
            .onChange(of: text.wrappedValue) { newValue in
                handleTextChange(for: field, text: newValue)
            }
    }

    private func handleTextChange(for field: ActiveField, text: String) {
        if field == .destinationLocation, !text.isEmpty {
            viewModel.fetchPlaces(query: text)
            isListVisible = true
        } else {
            viewModel.places = []
            isListVisible = false
        }
    }

    private func handlePlaceSelection(_ place: GMSAutocompletePrediction) {
        destinationLocationText = place.attributedPrimaryText.string
        fetchCoordinates(for: place.placeID) { coordinates in
            if let coordinates = coordinates {
                destinationCoordinates = coordinates
                if originCoordinates == nil, let currentLocation = locationManager.currentLocation?.coordinate {
                    originCoordinates = currentLocation
                }
                navigateToTripRequest = true
            }
        }
    }

    private func updateCurrentLocation(newAddress: String?) {
        currentLocationText = newAddress ?? ""
    }

    private func fetchCoordinates(for placeID: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.coordinate], sessionToken: nil) { place, error in
            completion(place?.coordinate)
        }
    }

    private var navigationLinkToTimeSlotSelection: some View {
        NavigationLink(
            destination: TimeSlotSelectionView(
                viewModel: viewModel,
                currentLocationText: $currentLocationText,
                destinationLocationText: $destinationLocationText,
                originCoordinates: originCoordinates ?? CLLocationCoordinate2D(),
                destinationCoordinates: destinationCoordinates ?? CLLocationCoordinate2D()
            ),
            isActive: $navigateToTripRequest
        ) {
            EmptyView()
        }
    }
}
