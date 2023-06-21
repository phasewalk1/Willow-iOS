import SwiftUI

struct EventView : View {
    @EnvironmentObject var client : Client
    @State var event : Event = Event(
        title:"",
        date:Date(),
        type: "1:1",
        hours: 0,
        minutes: 0,
        atRate: 0,
        totalCost: 0
    )
    
    var body : some View {
        NavigationView {
            List {
                Section("Title & Date") {
                    HStack {
                        Label("", systemImage: "calendar")
                        Text(event.date, style: .date)
                    }
                }
                Section("Event Metadata") {
                    HStack {
                        Label("", systemImage: "number.circle.fill")
                        Text(event.type)
                    }
                    HStack {
                        Label("", systemImage: "clock")
                        Text(event.hours, format: .number.precision(.fractionLength(0)))
                        event.hours > 1 ? Text("Hours") : Text("Hour")
                        Text(event.minutes, format: .number.precision(.fractionLength(0)))
                        Text("Minutes")
                    }
                }
            }
        }
        .navigationTitle("\(event.title)")
    }
    
    @ViewBuilder
    private var Legend : some View {
        HStack {
            Label("Date", systemImage: "calendar")
            Label("Type", systemImage: "number.circle.fill")
            Label("Hours", systemImage: "clock.fill")
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        let event = Event(
            title: "Test Event",
            date: Date(),
            type: "Group",
            hours: 1,
            minutes: 0,
            atRate: 100,
            totalCost: 100
        )
        EventView(event:event)
    }
}
