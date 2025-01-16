import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct AddRideView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var officeLocation = ""
    @State private var rideType = "Request"
    @State private var timeType = "Arrive between"
    @State private var selectedDateIndex = 0
    @State private var selectedTimeSlotIndex = 0
    @State private var isSaving = false
    @State private var saveMessage = ""
    
    @Binding var schedule: [ScheduledEvent]
    
    let rideTypes = ["Request", "Offer"]
    let timeTypes = ["Arrive between", "Leave between"]
    
    private var filteredTimeSlots: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let currentHour = Int(formatter.string(from: Date())) ?? 0
        let timeSlots = [
            "07:00 - 08:00", "08:00 - 09:00", "09:00 - 10:00",
            "10:00 - 11:00", "11:00 - 12:00", "12:00 - 13:00",
            "13:00 - 14:00", "14:00 - 15:00", "15:00 - 16:00",
            "16:00 - 17:00", "17:00 - 18:00", "18:00 - 19:00"
        ]
        return selectedDateIndex == 0
            ? timeSlots.filter { $0.split(separator: " ")[0].split(separator: ":")[0] >= "\(currentHour + 1)" }
            : timeSlots
    }
    
    private var dynamicDates: [Date] {
        return (0..<7).map { offset in
            Calendar.current.date(byAdding: .day, value: offset, to: Date())!
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            headerView

            ScrollView {
                sectionCard(title: "Ride Type") {
                    Picker("Ride Type", selection: $rideType) {
                        ForEach(rideTypes, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                sectionCard(title: "Office Location") {
                    TextField("Enter location", text: $officeLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                sectionCard(title: "Choose Timeslot") {
                    Picker("Time Type", selection: $timeType) {
                        ForEach(timeTypes, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    HStack {
                        Picker("Select Date", selection: $selectedDateIndex) {
                            ForEach(dynamicDates.indices, id: \.self) { index in
                                Text(formatDateForDisplay(date: dynamicDates[index])).tag(index)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)

                        Picker("Select Timeslot", selection: $selectedTimeSlotIndex) {
                            ForEach(filteredTimeSlots.indices, id: \.self) { Text(filteredTimeSlots[$0]).tag($0) }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                    }
                }
            }

            Button(action: addRide) {
                if isSaving {
                    ProgressView().padding()
                } else {
                    Text("Add Ride")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(officeLocation.isEmpty ? Color.gray : Color.turquoise)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(officeLocation.isEmpty || filteredTimeSlots.isEmpty)
                }
            }
            .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .alert(isPresented: .constant(!saveMessage.isEmpty), content: {
            Alert(title: Text("Save Status"), message: Text(saveMessage), dismissButton: .default(Text("OK"), action: {
                saveMessage = ""
            }))
        })
    }

    private func addRide() {
        guard let userUID = globalUserUID else {
            saveMessage = "User UID is not available."
            return
        }

        isSaving = true

        // Format the selected date for database storage
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDateForDatabase = formatter.string(from: dynamicDates[selectedDateIndex])

        let newRideData: [String: Any] = [
            "userUID": userUID,
            "rideType": rideType,
            "date": selectedDateForDatabase, // Store in yyyy-MM-dd format
            "pickup": officeLocation,
            "dropoff": "Office",
            "timePref": timeType,
            "timeslot": filteredTimeSlots[selectedTimeSlotIndex],
            "status": "Pending",
            "createdAt": ISO8601DateFormatter().string(from: Date())
        ]

        let databaseRef = Database.database().reference().child("data").child("Trip").childByAutoId()
        databaseRef.setValue(newRideData) { error, _ in
            isSaving = false
            if let error = error {
                saveMessage = "Failed to save ride: \(error.localizedDescription)"
            } else {
                saveMessage = "Ride successfully added!"
                let newRide = ScheduledEvent(
                    id: databaseRef.key ?? UUID().uuidString,
                    userUID: userUID,
                    rideType: rideType,
                    vehicleId: "Unknown",
                    date: selectedDateForDatabase, // Pass the formatted date here
                    direction: timeType,
                    tripStartTime: Date(),
                    tripEndTime: Date(),
                    pickup: officeLocation,
                    dropoff: "Office",
                    timePref: timeType,
                    timeslot: filteredTimeSlots[selectedTimeSlotIndex],
                    tripFee: 0,
                    status: "Pending"
                )
                schedule.append(newRide)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.subheadline).foregroundColor(.gray)
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
    }

    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left").font(.system(size: 18, weight: .medium))
            }
            Spacer()
            Text("Add Ride").font(.system(size: 18, weight: .semibold))
            Spacer()
            Color.clear.frame(width: 20)
        }
        .padding(.horizontal)
        .frame(height: 50)
        .background(Color.white)
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 2)
    }

    private func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        return formatter.string(from: date)
    }
}
