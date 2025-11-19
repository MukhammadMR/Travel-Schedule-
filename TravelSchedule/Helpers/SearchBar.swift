import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Введите запрос")
                        .font(.system(size: 17))
                        .foregroundColor(Color(#colorLiteral(red: 0.69, green: 0.69, blue: 0.69, alpha: 1)))
                }
                TextField("", text: $text)
                    .font(.system(size: 17))
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.none)
                    .foregroundColor(.black)
            }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(EdgeInsets(top: 7, leading: 8, bottom: 7, trailing: 8))
        .background(Color(colorScheme == .dark ? #colorLiteral(red: 0.462745098, green: 0.470588235, blue: 0.501960784, alpha: 0.24) : #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)))
        .cornerRadius(10)
        .frame(height: 36)
    }
}
