import SwiftUI

struct QRCodeScannerOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
                
                Spacer()
            }
            .padding(.top, geometry.size.height * 0.25)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.5).mask(makeMask()))
        }
    }
    
    func makeMask() -> some View {
        GeometryReader { geometry in
            VStack {
                Rectangle()
                    .frame(height: geometry.size.height * 0.25)
                HStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.15)
                    Spacer()
                    Rectangle()
                        .frame(width: geometry.size.width * 0.15)
                }
                .frame(height: geometry.size.width * 0.7)
                Spacer()
            }
        }
        .background(Color.black)
        .compositingGroup()
        .luminanceToAlpha()
    }
}

struct QRCodeScannerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerOverlay()
    }
}
