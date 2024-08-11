import SwiftUI
import UIKit
import LinkPresentation

struct ShareBingoViewController: UIViewControllerRepresentable {
    let bingoURL: URL?
    let image: UIImage?
    
    @Environment(\.dismiss) private var dismissAction

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ShareBingoViewController>) -> UIActivityViewController
    {
        
        var activityItems: [Any] = []
        image.map {
            activityItems.append(ImageActivityItemSource(image: $0))
        }
        bingoURL.map {
            activityItems.append($0)
        }
        
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
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

final class ImageActivityItemSource: NSObject, UIActivityItemSource {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let imageProvider = NSItemProvider(object: image)
        
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        metadata.title = "Share you bingo!"
        return metadata
    }
}
