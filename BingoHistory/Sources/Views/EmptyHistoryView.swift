import SwiftUI
import SharedUI

struct EmptyHistoryView: View {
    let onAddBingoTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Image("empty_state_illustration", bundle: .assets)
                .resizable()
                .scaledToFill()
                .frame(width: 242, height: 213, alignment: .center)

            Text("You haven't created\nthe cards yet,\nit's time to do it!")
                .multilineTextAlignment(.center)
                .font(AveFont.headline2)
                .foregroundStyle(AveColor.content)
                .padding(.top, 36)
                .lineSpacing(1.75)

            AveButton(
                iconName: "add_icon",
                text: "Create card",
                onTap: onAddBingoTap
            )
            .padding(.top, 48)
        }
    }
}
