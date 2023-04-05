//
//  UIFont+Extensions.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/5.
//

import UIKit

extension UIFont {
    class func projectFont(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        
        if weight == .bold {
            return UIFont(name: "Montserrat-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        } else if weight == .semibold {
            return UIFont(name: "Montserrat-SemiBold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        } else if weight == .thin {
            return UIFont(name: "Montserrat-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        } else if weight == .medium {
            return UIFont(name: "Montserrat-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
        }
        
        return UIFont(name: "Montserrat-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    class func actionTextFont(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        if weight == .bold {
            return UIFont(name: "Poppins-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        } else if weight == .semibold {
            return UIFont(name: "Poppins-SemiBold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        } else if weight == .thin {
            return UIFont(name: "Poppins-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        } else if weight == .medium {
            return UIFont(name: "Poppins-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
        }
        
        return UIFont(name: "Poppins-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}
