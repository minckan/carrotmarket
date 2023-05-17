//
//  LinkPresentationItemSource.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/17.
//

import UIKit
import LinkPresentation
import Foundation

class LinkPresentationItemSource: NSObject, UIActivityItemSource {
    var linkMetaData = LPLinkMetadata()
    
    // Prepare data to share
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return linkMetaData
    }
    
    // Placeholder for real data, we don't care in this example so just return a simple string
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Placeholder"
    }
    
    // Return the data will be shared
    // - Parameters:
    //  - activityType: Ex: mail, message, airdrop, etc...
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return linkMetaData.originalURL
    }
    
    init(metadata: LPLinkMetadata) {
        self.linkMetaData = metadata
    }
    
}
