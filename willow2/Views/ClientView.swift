import SwiftUI

/// The view for a Client. Contains Metadata and an interactive list of Events from which you
/// can add, (TODO) edit, and (TODO) delete Events.
struct ClientView : View {
    /// The Client object to display
    @EnvironmentObject var client : Client
    /// The Events to display
    @State var events : [Event] {
        // TODO: Remove didSet and use @Binding
        didSet {
            client.events = events
        }
    }
    /// Whether or not to animate the balance change
    @State private var animateBalanceChange = false
    /// Whether or not to animate the dues change
    @State private var animateDuesChange = false
    
    /// 'events' but sorted by date
    var sortedEvents: [Event] {
        return client.events.sorted(by: { $0.date > $1.date} )
    }
    
    // ---- View Body ----
    var body: some View {
        NavigationView {
            List {
                Section("Info") {
                    ClientMeta(animateBalanceChange: $animateBalanceChange, animateDuesChange: $animateDuesChange).environmentObject(client)
                }
                Section("Events") {
                    NavigationLink {
                        EventForm(events: $events, animateBalanceChange: $animateBalanceChange, animateDuesChange: $animateDuesChange).environmentObject(client)
                    } label : {
                        Label("Add Event", systemImage: "rectangle.portrait.and.arrow.forward.fill")
                    }
                    if client.events.isEmpty { VStack {} }
                    else {
                        ForEach(sortedEvents, id: \.id) { event in
                            let img = eventTypeToSystemImage(eventType: event.type)
                            NavigationLink {
                                EventView(event: event).environmentObject(client)
                            } label : {
                                Label(event.title, systemImage: img)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(client.name)
    }
}

/// Maps valid Event Types to system images for use in Labels
private func eventTypeToSystemImage(eventType: String) -> String {
    switch eventType {
    case "1:1":
        return "lightbulb.2"
    case "Group":
        return "person.3"
    case "Phone":
        return "phone"
    case "Retainer":
        return "dollarsign.circle"
    default:
        return "questionmark"
    }
}
