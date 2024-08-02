import SwiftUI
import UIKit

struct ShareBingoViewController: UIViewControllerRepresentable {
    let bingoURL: URL?
    let image: UIImage?
    
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.dismiss) private var dismissAction

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ShareBingoViewController>) -> UIActivityViewController
    {
        var activityItems: [Any] = []
        image.map {
            activityItems.append($0)
        }
        bingoURL.map {
            activityItems.append($0)
        }
        
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )

        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.dismissAction()
        }
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ShareBingoViewController>
    ) {
        
    }

}
