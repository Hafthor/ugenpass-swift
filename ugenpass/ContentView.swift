import SwiftUI

struct ContentView: View {
    private static let showText = "      Tap to show      "
    @State private var password = ""
    @State private var domain = ""
    @State private var gen = showText
    @State private var showingPassword = false
    let inputFont: Font = .system(size: 18.0, weight: .bold, design: .monospaced)
    let resultFont: Font = .system(size: 17.0, weight: .bold, design: .monospaced)
    let width = CGFloat(280), height = CGFloat(20)
    let padd = EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
    
    var body: some View {
        VStack {
            let lblPassword = Text("Password")
            lblPassword
            SecureField("", text: $password)
                .frame(minWidth: width, idealWidth: width, maxWidth: width, minHeight: 0, idealHeight: height, maxHeight: height, alignment: .center)
                .padding()
                .accessibility(label: lblPassword)
                .font(inputFont)
                .border(Color.gray, width: 3)
            
            let lblDomain = Text("Domain")
            lblDomain
            TextField("", text: $domain)
                .keyboardType(.URL)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .frame(minWidth: width, idealWidth: width, maxWidth: width, minHeight: 0, idealHeight: height, maxHeight: height, alignment: .center)
                .padding()
                .accessibility(label: lblDomain)
                .font(inputFont)
                .border(Color.gray, width: 3)

            HStack {
                VStack {
                    let lblGen = Text("Generated Password")
                    lblGen
                    let btnText = Text(gen).font(resultFont)
                        .padding(padd)
                    Button(action: {
                        if showingPassword {
                            gen = ContentView.showText
                            showingPassword = false
                        } else {
                            gen = g()
                            showingPassword = true
                        }
                    }) {
                        btnText
                    }.buttonStyle(PlainButtonStyle())
                    .border(Color.gray, width: 3)
                    .accessibility(label: lblGen)
                }
                VStack {
                    Text(" ")
                    Button(action: {
                        if showingPassword {
                            UIPasteboard.general.string = gen
                            gen = ContentView.showText
                            showingPassword = false
                        } else {
                            UIPasteboard.general.string = g()
                        }
                    }) {
                        Text("Copy").font(resultFont).padding(padd)
                    }.buttonStyle(PlainButtonStyle())
                    .border(Color.gray, width: 3)
                }
            }
        }
    }
    
    func g() -> String {
        let pwd = password.trimmingCharacters(in: NSMutableCharacterSet.whitespacesAndNewlines)
        let dom = domain.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lowercased()
        return UGenPass.generate(password: pwd, domain: dom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
