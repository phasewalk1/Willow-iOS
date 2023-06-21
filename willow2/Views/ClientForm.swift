import SwiftUI

struct ClientForm : View, Hashable, Equatable {
    @StateObject var deck : ClientDeck
    @State var mutClient : Client = Client(name: "", email: "", phone: "", rate: 0)
    @Environment(\.dismiss) var dismiss
    
    var body : some View {
        Form {
            Section {
                TextField("Name", text: $mutClient.name)
                TextField("Phone", text: $mutClient.phone)
                TextField("Email", text: $mutClient.email)
                    .autocapitalization(.none)
                TextField("Rate", value: $mutClient.rate, format: .number)
            }
            Section {
                Button(action: {
                    if mutClient.isValid() {
                        if deck.addClient(client: mutClient) {
                            dismiss()
                        }
                    }
                }) {
                    Label("Add Client", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle("Adding Client")
    }
    
    public static func == (lhs: ClientForm, rhs: ClientForm) -> Bool {
        return lhs.mutClient == rhs.mutClient
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(mutClient)
    }
}
