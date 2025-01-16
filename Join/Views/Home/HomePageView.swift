import SwiftUI
import GoogleMaps

struct HomePageView: View {
    @Binding var isPresented: Bool
    @State private var officeLocation = "Enter Address"
    @State private var cameraPosition: GMSCameraPosition?
    @State private var showLocationAlert = false
    @State private var selectedTab: String = "Home"
    @State private var activeHomeView: Bool = true
    @State private var selectedSegment: String = "Rider"
    @State private var isSearchViewPresented = false
    @State private var showNavBar = true // Track navigation bar visibility
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = LocationSearchListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            contentView

            // Conditionally display the navigation bar
            if showNavBar {
                CustomNavBar(selectedTab: $selectedTab)
                    .frame(height: 60)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -2)
            }
        }
        .onAppear {
            updateCameraPosition()
        }
        .onChange(of: locationManager.currentLocation) { _ in
            updateCameraPosition()
        }
        .onChange(of: locationManager.isLocationPermissionDenied) { denied in
            showLocationAlert = denied
        }
        .alert(isPresented: $showLocationAlert) {
            Alert(
                title: Text("Location Access Denied"),
                message: Text("Please enable location access in Settings."),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $isSearchViewPresented) {
            LocationSearchListView(officeLocation: $officeLocation)
                .environmentObject(viewModel)
                .onAppear { showNavBar = false } // Hide nav bar
        }
    }

    /// Main Content View
    private var contentView: some View {
        ZStack {
            if selectedTab == "Home" {
                if activeHomeView {
                    HomeView(selectedSegment: $selectedSegment)
                        .environmentObject(viewModel)
                        .onAppear { showNavBar = true }
                        .padding(.bottom, 5)
                } else {
                    TripView(activeHomeView: $activeHomeView)
                        .onAppear { showNavBar = true }
                        .padding(.bottom, 5)
                }
            } else if selectedTab == "Trips" {
                ScheduleView(activeHomeView: $activeHomeView)
                    .onAppear { showNavBar = true }
                    .padding(.bottom, 5)
            } else if selectedTab == "Account" {
                AccountView()
                    .onAppear { showNavBar = true }
                    .padding(.bottom, 5)
            }
        }
    }

    /// Update the camera position on location changes
    private func updateCameraPosition() {
        guard let location = locationManager.currentLocation else { return }
        cameraPosition = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 14.0
        )
    }
}
