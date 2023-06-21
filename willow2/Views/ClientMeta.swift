import SwiftUI

/// Metadata for a Client, including contact info and balance
struct ClientMeta : View {
    /// Client object from parent view
    @EnvironmentObject var client : Client
    /// Binding for the animation toggle on balance changes
    @Binding var animateBalanceChange: Bool
    /// Binding for the animation toggle on dues changes
    @Binding var animateDuesChange: Bool
    
    // ---- View Body ----
    var body : some View {
        Section("Dues\t\t\t\tBalance") {}
        BalancesView
            .animation(animateBalanceChange ? .easeInOut(duration: 1.0) : .default, value: client.outstanding)
            .onAppear {
                animateBalanceChange = false
            }
        Section("Contact") {}
        ContactView
    }
    
    /// The view for the Client's dues/balance
    @ViewBuilder
    private var BalancesView : some View {
        HStack {
            Label(String(format: "%.2f", client.outstanding), systemImage: "dollarsign.circle")
                .animation(animateDuesChange ? .easeInOut(duration: 1.0) : .default, value: client.outstanding)
                .onAppear {
                    animateDuesChange = false
                }
            Spacer()
                .frame(width: 80)
            Label(String(format: "%.2f", client.balance), systemImage: "dollarsign.circle.fill")
                .animation(animateBalanceChange ? .easeInOut(duration: 1.0) : .default, value: client.balance)
                .onAppear {
                    animateBalanceChange = false
                }
        }
    }
    
    /// The view for the Client's contact information
    @ViewBuilder
    private var ContactView : some View {
        VStack {
            Label(client.email, systemImage: "envelope")
        }
        VStack {
            Label(client.phone, systemImage: "phone")
        }
    }
}
