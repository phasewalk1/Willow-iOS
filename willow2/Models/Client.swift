import SwiftUI
import Combine

class Client : ObservableObject, Identifiable, Hashable, Equatable {
    static let eventsDidChange = PassthroughSubject<Client, Never>()
    @Published var events : [Event] {
        didSet {
            print("Events Changed!")
            Client.eventsDidChange.send(self)
        }
    }
    var id = UUID()
    var name: String
    var email: String
    var phone: String
    var rate: Double
    var image: String?
    
    // Defaults
    var outstanding: Double = 0
    var balance: Double = 0
    var color: Color = Color.gray
    
    init(name: String, email: String, phone: String, rate: Double) {
        self.events = []
        self.name = name
        self.email = email
        self.phone = phone
        self.rate = rate
        self.image = Optional.none
    }
    
    static func == (lhs: Client, rhs: Client) -> Bool {
        return lhs.phone == rhs.phone && lhs.name == rhs.name && lhs.email == rhs.email
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public func isValid() -> Bool {
        return !name.isEmpty && !phone.isEmpty && !email.isEmpty && rate > 0
    }
    
    public func computeNetBalance() -> Double {
        return balance - outstanding
    }
}

extension Client {
    func insertEvent(event: Event, balBind: Binding<Bool>, outBind: Binding<Bool>) -> Void {
        guard event.totalCost > 0 else { return }
        if self.balance >= event.totalCost {
            self.balance -= event.totalCost
            balBind.wrappedValue = true
        } else {
            let diff = event.totalCost - self.balance
            self.balance = 0
            self.outstanding += diff
            outBind.wrappedValue = true
        }
        events.append(event)
    }
}
