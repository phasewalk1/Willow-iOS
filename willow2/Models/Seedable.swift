import SwiftUI

class SeedableEvents {
    typealias EventSeed = ([Event],[Event],[Event])
    public static func withSeededEvents(clients:[Client]) -> [Client] {
        let seed : EventSeed = seededEvents()
        clients.first(where: { $0.name == "Walter White" })?.events = seed.0
        clients.first(where: { $0.name == "Jesse Pinkman" })?.events = seed.1
        clients.first(where: { $0.name == "Hank Schrader" })?.events = seed.2
        return clients
    }
    private static func seededEvents() -> EventSeed {
        let seedEvents_Walter : [Event] = [
            .init(title: "Introduction", date: Date(), type: "1:1", hours: 2, minutes: 0, atRate: 225, totalCost: 450),
            .init(title: "Jesse", date: Date(), type: "1:1", hours: 0, minutes: 30, atRate: 250, totalCost: 125),
            .init(title: "Skyler's Idea", date: Date(), type: "Group", hours: 1, minutes: 30, atRate: 300, totalCost: 450)
        ]
        let seedEvents_Jesse : [Event] = [
            .init(title: "Rehab", date: Date(), type: "1:1", hours: 2, minutes: 0, atRate: 75, totalCost: 150),
            .init(title: "Walter", date: Date(), type: "1:1", hours: 0, minutes: 30, atRate: 250, totalCost: 125),
            .init(title: "Camino", date: Date(), type: "Phone", hours: 1, minutes: 30, atRate: 300, totalCost: 450)
        ]
        return (seedEvents_Walter,seedEvents_Jesse,[])
    }
}

class SeedableDeck : ClientDeck {
    override init() {
        super.init()
        self.clients = SeedableEvents.withSeededEvents(clients: SeedableDeck.seededClients())
    }
    
    private static func seededClients() -> [Client] {
        let seedClients : [Client] = [
            .init(name:"Jesse Pinkman", email:"jesse@aol.com", phone: "N/A", rate: 75),
            .init(name:"Walter White", email:"bluecrysta@hotmail.com", phone: "N/A", rate: 220),
            .init(name:"Hank Schrader", email:"hschrader@gmail.com", phone: "911", rate: 80)
        ]
        return seedClients
    }
}
