import SwiftUI

/// Section + TextField for Doubles/Floats
struct ValidatedRateField : View {
    /// Binds to the mutable event in the parent view
    @Binding var mutEvent: Event
    
    // ---- View Body ----
    var body : some View {
        Section("Rate") {
            TextField("Billing Rate", value: $mutEvent.atRate, format: .number)
        }
    }
}

struct EventForm : View {
    /// Binds to the Client's list of Events from the parent view
    @Binding var events: [Event]
    /// Toggles animation on balance change
    @Binding var animateBalanceChange : Bool
    /// Toggles animation on dues change
    @Binding var animateDuesChange : Bool
    /// The client object passed in from the parent view
    @EnvironmentObject var client : Client
    /// This form is dismissable
    @Environment(\.dismiss) var dismiss
    #if os(iOS)
    /// This form is presented modally on iOS
    @Environment(\.presentationMode) var presentationMode
    #endif
    /// Mutable state for the new event
    @State var newEvent : Event = Event(
        title:"",
        date:Date(),
        type: "1:1",
        hours: 0,
        minutes: 0,
        atRate: 0,
        totalCost: 0
    )
    /// Mutable private time field slot
    @State private var startingTime = Date()
    /// Mutable private time field slot
    @State private var endingTime = Date().addingTimeInterval(3600)
    /// Static valid event types
    var eventTypes = EventTypes
    
    // ---- View Body ----
    var body : some View {
        if newEvent.type != "Retainer" {
            Form {
                VStack {
                    metaFields
                    ValidatedRateField(mutEvent: $newEvent)
                }
            }
            .navigationTitle("Event Editor")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let (hours, minutes) = handleTimeFields()
                        let _ = computeThenSetCost(time: (hours, minutes))
                        client.insertEvent(event:newEvent,balBind: $animateBalanceChange,outBind:$animateDuesChange)
                        if didBalanceChange {
                            animateBalanceChange = true
                        }
                        if didDuesChange {
                            animateDuesChange = true
                        }
                        dismiss()
                    })
                    {
                        Text("Save")
                    }
                    .animation(.default)
                    .disabled(!newEvent.isValid())
                }
            }
        } else {
            Text("Woops! Not yet implemented...")
            Button("Go Back") {
                newEvent.type = "1:1"
            }
        }
    }
    
    /// The meta sections, including title, date, and time range
    @ViewBuilder
    private var metaFields : some View {
        Section("Meta") {
            FormField(title: "Event Title", text: $newEvent.title)
                .padding()
            DatePicker (
                "Event Date",
                selection: $newEvent.date,
                displayedComponents: [.date]
            )
            .padding()
            timeFields
                .padding()
            Picker("Event Type", selection: $newEvent.type) {
                ForEach(eventTypes, id: \.title) { type in
                    Text(type.title)
                }
            }
            .padding()
        }
    }
    
    /// The time range fields
    @ViewBuilder
    private var timeFields : some View {
        HStack {
            VStack {
                Label("Start", systemImage: "clock")
                DatePicker("Start Time", selection:$startingTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding()
            }
            VStack {
                Label("End", systemImage: "clock.fill")
                DatePicker("End Time", selection:$endingTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .padding()
            }
        }
    }
    
    private func handleTimeFields() -> (Int, Int) {
        let (hours, minutes) = unguardedComputeAndSetTimeFields()
        if !(hours == 0) && !(minutes == 0) {
            newEvent.hours = hours
            newEvent.minutes = minutes
        }
        return (newEvent.hours, newEvent.minutes)
    }
    
    /// Computes the hours and minutes betwen start and end times and sets the event's time fields
    private func unguardedComputeAndSetTimeFields() -> (Int, Int) {
        let difference = endingTime.timeIntervalSince(startingTime)
        let hours = Int(difference) / 3600
        let mins = (Int(difference) % 3600) / 60
        newEvent.hours = hours
        newEvent.minutes = mins
        return (hours, mins)
    }
    
    private func computeThenSetCost(time: (Int, Int)) -> Void {
        let cost = computeTotalCost(time:time)
        guard cost > 0 else { return }
        self.newEvent.totalCost = cost
        return Void()
    }
    
    /// Computes the total cost of the event based on the total time billed at the billing rate
    private func computeTotalCost(time: (Int, Int)) -> Double {
        let (hours, minutes) = (time.0, time.1)
        let rate = newEvent.atRate
        let totalCost = Double(hours) * rate + Double(minutes) * (rate / Double(60))
        return totalCost
    }
    
    @State private var didBalanceChange = false
    @State private var didDuesChange = false
}

