
import SwiftUI

struct SavedPlacesView: View {
    @State private var savedPlaces: [String] = ["Home", "Work"]
    @State private var newPlace: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(savedPlaces, id: \.self) { place in
                    Text(place)
                }
                .onDelete(perform: deletePlace)
            }
            
            HStack {
                TextField("Add New Place", text: $newPlace)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addPlace) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .navigationTitle("Saved Places")
    }
    
    private func addPlace() {
        if !newPlace.isEmpty {
            savedPlaces.append(newPlace)
            newPlace = ""
        }
    }
    
    private func deletePlace(at offsets: IndexSet) {
        savedPlaces.remove(atOffsets: offsets)
    }
}
