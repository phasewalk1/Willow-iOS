import SwiftUI

struct ContentView: View {
    @StateObject var deck = ClientDeck().seeded()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGreen).opacity(0.5)
                .ignoresSafeArea()
            deck.RootNavView
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(deck:ClientDeck().seeded())
    }
}

