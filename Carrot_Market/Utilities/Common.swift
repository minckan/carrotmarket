//
//  Common.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit
import LinkPresentation

func setNavigationBarColor(_ color: UIColor) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = color
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

func createActionSheet(title: String?, message: String?, actions: [UIAlertAction]) -> UIAlertController {
    let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for index in 0...(actions.count - 1) {
        actionSheet.addAction(actions[index])
    }
    return actionSheet
}

//@available(iOS 13.0, *)
//func fetchURLPreview(url: URL) -> LPLinkMetadata? {
//    let metadataProvider = LPMetadataProvider()
//    metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
//        guard let data = metadata, error == nil else {
//            return
//        }
//        return data
//    }
//}

func getMetadataForSharingManually(title: String, url: URL?, fileName: String?, fileType: String?) -> LPLinkMetadata {
    let linkMetaData = LPLinkMetadata()
    
    if let fileName = fileName {
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)
        linkMetaData.iconProvider = NSItemProvider(contentsOf: URL(fileURLWithPath: path ?? ""))
    }
    if let url = url {
        linkMetaData.originalURL = url
    }
   
    linkMetaData.title = title
    return linkMetaData
}


func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
    let newSize = CGSize(width: newWidth, height: newHeight)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
