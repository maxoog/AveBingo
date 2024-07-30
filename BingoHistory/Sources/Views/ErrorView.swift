import SwiftUI
import SharedUI

struct ErrorView: View {
    let onReloadTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Image("error_state_illustration", bundle: .assets)
                .resizable()
                .scaledToFill()
                .frame(width: 213, height: 213, alignment: .center)
            
            Text("Something went\nwrong")
                .multilineTextAlignment(.center)
                .font(AveFont.headline2)
                .foregroundStyle(AveColor.content)
                .lineSpacing(1.75)
            
            AveButton(
                iconName: "reload_icon",
                text: "Reload",
                onTap: onReloadTap
            )
            .padding(.top, 48)
        }
    }
}
