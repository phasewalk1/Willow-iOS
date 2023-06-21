import SwiftUI

struct NetsView : View, Hashable, Equatable {
    @ObservedObject var deck: ClientDeck
    
    var body: some View {
        HStack {
            Label("", systemImage: "dollarsign.circle.fill")
                .foregroundColor(.green)
                .font(.system(size:20))
                
            Text(String(format: "%.2f", deck.netBalance))
                .font(.system(size:15))
                .padding(.trailing)
            Label("", systemImage: "dollarsign.circle")
                .foregroundColor(.red)
                .font(.system(size:20))
            Text(String(format: "%.2f", deck.netDues))
                .font(.system(size:15))
                .padding(.trailing)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.deck.clients == rhs.deck.clients
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(deck.clients)
    }
}

struct NetsView_Previews : PreviewProvider {
    static var previews: some View {
        NetsView(deck: ClientDeck())
    }
}
