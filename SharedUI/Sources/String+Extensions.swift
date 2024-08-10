//
//  File.swift
//  
//
//  Created by Maksim Zenkov on 09.08.2024.
//

import Foundation
import UIKit

extension String {
    public func toUIImage() -> UIImage? {
        let size = CGSize(width: 56, height: 56)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 51)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
