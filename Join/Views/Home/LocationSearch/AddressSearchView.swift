import SwiftUI
import GooglePlaces

struct AddressSearchView: View {
    let title: String
    @State private var searchText = ""
    @State private var isListVisible = false
    @FocusState private var isSearchFieldFocused: Bool
    @EnvironmentObject var viewModel: LocationSearchListViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBar

                // Search Bar
                searchBar

                // Predictions List
                if isListVisible {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.places, id: \.placeID) { place in
                                placeRow(for: place)
                            }
                        }
                    }
                    .background(Color.white)
                }

                Spacer()
            }
            .background(Color.white)
            .onAppear {
                viewModel.places = [] // Clear the list when view appears
                isListVisible = false
            }
        }
    }

    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
            }
            .padding(.leading)

            Spacer()

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            Spacer()

            // Placeholder for symmetry
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            TextField("Search location", text: $searchText)
                .focused($isSearchFieldFocused)
                .padding(.horizontal)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 2)
                )
                .onChange(of: searchText) { newValue in
                    handleSearchQueryChange(query: newValue)
                }

            Button(action: {
                // Clear text and reset
                searchText = ""
                isListVisible = false
                isSearchFieldFocused = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .opacity(searchText.isEmpty ? 0 : 1)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    // MARK: - Place Row
    private func placeRow(for place: GMSAutocompletePrediction) -> some View {
        Button(action: {
            handlePlaceSelection(place)
        }) {
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                    .frame(width: 30, height: 30)

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
    }

    // MARK: - Helpers
    private func handleSearchQueryChange(query: String) {
        if query.isEmpty {
            viewModel.places = []
            isListVisible = false
        } else {
            viewModel.fetchPlaces(query: query)
            isListVisible = true
        }
    }

    private func handlePlaceSelection(_ place: GMSAutocompletePrediction) {
        // Handle place selection logic (e.g., navigate or update state)
        print("Selected Place: \(place.attributedPrimaryText.string)")
    }
}
