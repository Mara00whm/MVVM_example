//
//  ColorExtension.swift
//  MVVM_example
//
//  Created by Marat on 01.02.2023.
//

import UIKit

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(named: "backgroundColor") ?? UIColor.white
    }
    
    static var titleForegroundColor: UIColor {
        return UIColor(named: "titleForegroundColor") ?? UIColor.black
    }
    
    static var subtitleForegroundColor: UIColor {
        return UIColor(named: "textSubtitleForegroundColor") ?? UIColor.systemGray
    }
}
