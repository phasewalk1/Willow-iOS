import SwiftUI

struct FormField : View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text)
        }
    }
}
