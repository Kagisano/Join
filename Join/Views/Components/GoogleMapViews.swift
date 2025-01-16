import SwiftUI
import GoogleMaps

struct GoogleMapViews: UIViewRepresentable {
    @Binding var userLocation: CLLocation?

    class Coordinator: NSObject, GMSMapViewDelegate {
        var mapView: GMSMapView?
        var shouldRecenter = true

        func centerMap(on location: CLLocation, mapView: GMSMapView) {
            guard shouldRecenter else { return }
            let cameraUpdate = GMSCameraUpdate.setTarget(location.coordinate, zoom: 15.0)
            mapView.animate(with: cameraUpdate)
        }

        // Detect when the user manually moves the map
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            shouldRecenter = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero)
        context.coordinator.mapView = mapView
        mapView.delegate = context.coordinator

        // Apply the custom map style
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            do {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } catch {
                print("Failed to apply map style: \(error)")
            }
        } else {
            print("Unable to find mapStyle.json")
        }

        // Enable My Location Layer
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false // Disable default Google button

        // Set default camera position
        if let location = userLocation {
            context.coordinator.centerMap(on: location, mapView: mapView)
        } else {
            mapView.camera = GMSCameraPosition.camera(
                withLatitude: -33.8688,
                longitude: 151.2093,
                zoom: 10.0
            )
        }

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if let userLocation = userLocation {
            context.coordinator.centerMap(on: userLocation, mapView: mapView)
        }
    }
}

struct GoogleMapContainerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isGeolocationButtonTapped = false
    @State private var coordinator: GoogleMapViews.Coordinator?

    var body: some View {
        ZStack {
            GoogleMapViews(userLocation: $locationManager.currentLocation)
                .onAppear {
                    // Create a coordinator using the current binding for userLocation
                    coordinator = GoogleMapViews(userLocation: $locationManager.currentLocation).makeCoordinator()
                }
                .edgesIgnoringSafeArea(.all)

            // Geolocation Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
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
                    .padding(.trailing, 16) // Padding from the right edge
                    .padding(.bottom, 16)   // Padding from the bottom edge
                }
            }
        }
        .onChange(of: isGeolocationButtonTapped) { tapped in
            if tapped, let location = locationManager.currentLocation {
                // Center the map
                coordinator?.shouldRecenter = true
                if let mapView = coordinator?.mapView {
                    coordinator?.centerMap(on: location, mapView: mapView)
                }
                isGeolocationButtonTapped = false
            }
        }
    }
}

extension Notification.Name {
    static let didTapGeolocation = Notification.Name("didTapGeolocation")
}
