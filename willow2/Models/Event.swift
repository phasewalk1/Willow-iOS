import SwiftUI

/// Event Types
public var EventTypes: [EventType] = [
    EventType(title: "1:1"),
    EventType(title: "Group"),
    EventType(title: "Phone"),
    EventType(title: "Retainer"),
    EventType(title: "Other")
]


/// The Event Structure
struct Event : Hashable, Codable, Identifiable {
    var id = UUID()
    var title: String
    var date: Date
    var type: String
    var hours: Int
    var minutes: Int
    var atRate: Double
    var totalCost: Double
    
    /// Optional Detail
    var detail: String?
    
    /// Push self to a Client Object
    public func pushToClient(client: Client) {
        print("pushing event to client", self, "with client", client)
        client.events.append(self)
    }
    
    /// Validate self
    public func isValid() -> Bool {
        if self.title.isEmpty || self.type.isEmpty || self.atRate.isZero
        {
            return false
        }
        return true
    }
}

/// A Customizable Event Type Structure
public struct EventType : Hashable, Codable {
    var title: String
}
