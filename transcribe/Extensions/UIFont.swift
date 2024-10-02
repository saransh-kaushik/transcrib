//
//  UIFont.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 02/10/24.
//

import UIKit

extension UIFont {
    static func sfProFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .bold:
            return UIFont(name: "SFProText-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .medium:
            return UIFont(name: "SFProText-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        case .regular:
            return UIFont(name: "SFProText-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        default:
            return UIFont.systemFont(ofSize: size)
        }
    }
}


