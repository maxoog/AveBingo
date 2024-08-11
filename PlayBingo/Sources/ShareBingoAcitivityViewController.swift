import SwiftUI
import UIKit
import LinkPresentation
import ServicesContracts

struct ShareBingoViewController: UIViewControllerRepresentable {
    let bingoURL: URL?
    let image: UIImage?
    let analyticsService: AnalyticsServiceProtocol
    
    @Environment(\.dismiss) private var dismissAction

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ShareBingoViewController>) -> UIActivityViewController
    {
        
        var activityItems: [Any] = []
        image.map {
            activityItems.append($0)
        }
        bingoURL.map {
            activityItems.append(LinkItemSource(url: $0))
        }
        
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )

        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            analyticsService.logEvent(PlayEvent.share(activity: activityType?.rawValue ?? "unknown"))
            
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

final class LinkItemSource: NSObject, UIActivityItemSource {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return url
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType?.rawValue == "ph.telegra.Telegraph.Share" {
            return url.absoluteString
        } else {
            return url
        }
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        
        let metadata = LPLinkMetadata()
        metadata.title = "Share you bingo!"
        return metadata
    }
}
