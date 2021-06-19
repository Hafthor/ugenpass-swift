import SwiftUI

struct ContentView: View {
    private static let ugpShowText = "Tap to show"
    @State private var password = ""
    @State private var domain = ""
    @State private var ugp = ugpShowText
    @State private var showingUgp = false
    @State private var qrCodeVisible = false
    @State private var qrCodeValue = ""
    @State private var pickerSelection = "ugp"
    let inputFont: Font = .system(size: 18.0, weight: .bold, design: .monospaced)
    let resultFont: Font = .system(size: 17.0, weight: .bold, design: .monospaced)
    let width = CGFloat(280), height = CGFloat(20)
    let padd = EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5)
    let padd2 = EdgeInsets(top: 15, leading: 68, bottom: 15, trailing: 68)
    
    var body: some View {
        ZStack {
            ScrollView {
                let lblPassword = Text("Password")
                lblPassword
                SecureField("", text: $password)
                    .frame(minWidth: width, idealWidth: width, maxWidth: width, minHeight: 0, idealHeight: height, maxHeight: height, alignment: .center)
                    .padding()
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
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

                Picker("", selection: $pickerSelection) {
                    Text("ugenpass").tag("ugp")
                    Text("SuperGenPass").tag("sgp")
                }.pickerStyle(SegmentedPickerStyle()).onChange(of: pickerSelection, perform: { (value) in
                    qrCodeValue = ""
                    ugp = ContentView.ugpShowText
                    showingUgp = false
                })
                

                HStack {
                    VStack {
                        let btnText = Text(padding(ugp)).font(resultFont)
                            .padding(padd)
                        Button(action: {
                            ugp = showingUgp ? ContentView.ugpShowText : pickerSelection=="ugp" ? genugp() : gensgp()
                            qrCodeValue = showingUgp ? "" : ugp
                            showingUgp = !showingUgp
                        }) {
                            btnText
                        }.buttonStyle(PlainButtonStyle())
                        .border(Color.gray, width: 3)
                    }
                    VStack {
                        Button(action: {
                            UIPasteboard.general.string = showingUgp ? ugp : pickerSelection=="ugp" ? genugp() : gensgp()
                            ugp = ContentView.ugpShowText
                            showingUgp = false
                            qrCodeValue = ""
                        }) {
                            Text("Copy").font(resultFont).padding(padd)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .border(Color.gray, width: 3)
                    }
                }
                
                genqr(qrCodeValue).padding(28).border(Color.gray, width: 3)
            }
        }
    }
    
    func padding(_ s: String) -> String {
        let c = 23-s.count, l=c>>1, r=c-l
        return "".padding(toLength: l, withPad: " ", startingAt: 0) + s + "".padding(toLength: r, withPad: " ", startingAt: 0)
        
    }
    func genugp() -> String {
        let pwd = password.trimmingCharacters(in: NSMutableCharacterSet.whitespacesAndNewlines)
        let dom = domain.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lowercased()
        return UGenPass.generate(password: pwd, domain: dom)
    }
    
    func gensgp() -> String {
        let pwd = password.trimmingCharacters(in: NSMutableCharacterSet.whitespacesAndNewlines)
        let dom = domain.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lowercased()
        return SuperGenPass.generate(password: pwd, domain: dom, length: 10)
    }
    
    func genqr(_ code: String) -> Image {
        let rect = CGRect(x: 0, y: 0, width: 256.0, height: 256.0)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setDefaults()
        filter.setValue(qrCodeValue.data(using: .ascii), forKey: "inputMessage")
        filter.setValue(code.count <= 10 ? "Q" : "M", forKey: "inputCorrectionLevel")
        if code != "" {
            if let img = filter.outputImage {
                let scaleX = rect.size.width / img.extent.size.width
                let scaleY = rect.size.height / img.extent.size.height
                let img2 = img.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                if let cg = CIContext().createCGImage(img2, from: rect) {
                    let uiImg = UIImage(cgImage: cg)
                    return Image(uiImage: uiImg)
                }
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 1.0)
        UIColor.white.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return Image(uiImage: image)
    }
}

// ref: https://stackoverflow.com/a/28542447/4489
extension UIImage {
    convenience init?(barcode: String) {
        let filter = CIFilter(name: "CICode128BarcodeGenerator")!
        filter.setValue(barcode.data(using: .ascii), forKey: "inputMessage")
        //filter.setValue("M", forKey: "inputCorrectionLevel")
        self.init(ciImage: filter.outputImage!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
