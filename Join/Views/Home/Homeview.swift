import SwiftUI
import GoogleMaps

struct HomeView: View {
    @Binding var selectedSegment: String
    @State private var isSearchViewPresented = false
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = LocationSearchListViewModel() // Initialize the view model
    @State private var isNavigatingToSearch = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    segmentedControl
                        .padding(.top, 16)

                    mapView

                    Spacer()

                    actionButtons
                }
            }
            .navigationDestination(isPresented: $isNavigatingToSearch) {
                // Inject the environment object into LocationSearchListView
                LocationSearchListView(officeLocation: .constant("Enter Address"))
                    .environmentObject(viewModel)
            }
            .navigationBarHidden(true) // Hide the default navigation bar globally
        }
    }

    // MARK: - Segmented Control
    private var segmentedControl: some View {
        CustomSegmentedControl(
            selectedSegment: $selectedSegment,
            segments: ["Rider", "Driver"]
        )
    }

    // MARK: - Google Map View
    private var mapView: some View {
        ZStack(alignment: .topLeading) {
            GoogleMapViews(userLocation: $locationManager.currentLocation)
                .edgesIgnoringSafeArea(.all)
        }
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            searchButton

            destinationRows
        }
        .padding(.bottom, 8)
        .padding(.top, 16)
        .background(Color.white)
        .cornerRadius(12)
    }

    private var searchButton: some View {
        Button(action: {
            isNavigatingToSearch = true
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Where to?")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }

    private var destinationRows: some View {
        VStack(spacing: 8) {
            DestinationRowView(icon: "bed.double.fill", title: "Home", subtitle: "Set once and go")
            DestinationRowView(icon: "briefcase.fill", title: "Work", subtitle: "Set once and go")
        }
        .padding(.horizontal)
    }
}
