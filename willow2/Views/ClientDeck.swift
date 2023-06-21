import SwiftUI
import Combine

struct StatementForm : View, Hashable, Equatable {
    @ObservedObject var deck: ClientDeck
    @State private var selectedClient: Client? = nil
   
    var body: some View {
        Form {
            Section {
                Picker("Client", selection: $selectedClient) {
                    ForEach(deck.clients, id: \.id) { client in
                        Text(client.name).tag(client as Client?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            Section {
                Button(action: {
                    if let client = selectedClient {
                        print("Sending Statement to \(client.name)")
                    }
                }) {
                    Label("Send Statement", systemImage: "paperplane")
                }
            }
        }
    }
    
    private func numEvents() -> Int {
        return self.deck.allEvents().count
    }
    
    private func nameToClientObj(name: String) -> Client? {
        return deck.clients.first(where: { $0.name == name })
    }
    
    private func numEvents(for: Client) -> Int {
        var count = 0
        if let index = deck.clients.firstIndex(of: `for`) {
            let client: Client = deck.clients[index]
                for _ in client.events {
                    count += 1
                }
        }
        return count
    }
    
    static func == (lhs: StatementForm, rhs: StatementForm) -> Bool {
        return lhs.deck.clients == rhs.deck.clients
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(deck.clients)
    }
}

class ClientDeck : ObservableObject {
    @Published var clients: [Client] = []
    @Published var netBalance: Double = 0.0
    @Published var netDues: Double = 0.0
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.clients = []
        listenForEventsChanges()
    }
    
    @ViewBuilder
    public var RootNavView : some View {
        NavigationStack {
            List {
                Section("Overview") {
                    NetsView(deck: self)
                        .padding()
                    
                    NavigationLink(value: StatementForm(deck: self)) {
                        Label("Send a Statement", systemImage: "paperplane")
                            .padding()
                    }
                }
                Section("Clients") {
                    ForEach(self.clients, id: \.id) { client in
                        NavigationLink(value: client) {
                            Label(client.name, systemImage: client.image != nil ? client.image.unsafelyUnwrapped : "person.crop.circle")
                                .padding()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Make sure the title is in inline mode
                        .toolbar {
                            ToolbarItem(placement: .principal) { // Use the 'principal' placement for custom title view
                                HStack {
                                    Image(systemName: "tree.circle")
                                        .foregroundColor(.green)
                                    Text("Willow")
                                        .font(.title)
                                }
                            }
                        }
                        .navigationDestination(for: Client.self) { client in
                            ClientView(events: client.events).environmentObject(client)
                        }
            .navigationDestination(for: Client.self) { client in
                ClientView(events: client.events).environmentObject(client)
            }
            .navigationDestination(for: ClientForm.self) { form in
                form
            }
            .navigationDestination(for: StatementForm.self) { form in
                form
            }
            
            NavigationLink(value: ClientForm(deck: self)) {
                Label("Add Client", systemImage: "sparkles")
                    .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Adds a Client to the deck.
    ///
    /// - Parameters:
    ///     - client: The *Client* object to append.
    public func addClient(client: Client) -> Bool {
        if !clients.contains(client) {
            clients.append(client)
        }
        return true
    }
    
    /// Seeds a ClientDeck with some sample data.
    public func seeded() -> ClientDeck {
        let seed = SeedableDeck()
        self.clients = seed.clients
        return self
    }
   
    /// Returns all events in the deck, agnostic of client.
    public func allEvents() -> [Event] {
        var events : [Event] = []
        for client in clients {
            events += client.events
        }
        return events
    }
    
    /// Computes the net balance and net dues for the deck.
    private func calculateSums() {
        netBalance = clients.reduce(0) { sum, client in
            sum + client.balance
        }
        netDues = clients.reduce(0) { sum, client in
            sum + client.outstanding
        }
    }
    
    /// Subscribes to changes in the deck's events
    private func listenForEventsChanges() {
        Client.eventsDidChange.sink { [weak self] _ in
            print("Listening for changes and recalculating sums...")
            self?.calculateSums()
            print("Adjusted sums...")
            print("Net Balance: \(self?.netBalance ?? 0)")
            print("Net Dues: \(self?.netDues ?? 0)")
        }.store(in: &cancellables)
    }
    
}

struct ClientDeck_Previews : PreviewProvider {
    static var previews : some View {
        let deck = ClientDeck().seeded()
        deck.RootNavView
    }

}

