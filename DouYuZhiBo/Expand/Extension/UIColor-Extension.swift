//
//  UIColor-Extension.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r : CGFloat, g: CGFloat, b: CGFloat){
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class func fromHexString(hexString : String) {
        
        let characeterSet = CharacterSet.whitespacesAndNewlines
        
        let cString = hexString.trimmingCharacters(in: characeterSet).uppercased()
        
        // String should be 6 or 8 characters
        if (cString.count < 6) {
            sel
        }
        
        // strip 0X if it appears
        if ([cString hasPrefix:@"0x"] || [cString hasPrefix:@"0X"] )
        cString = [cString substringFromIndex:2];
        if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
        if ([cString length] != 6)
        return [UIColor clearColor];
        
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        
        //r
        NSString *rString = [cString substringWithRange:range];
        
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];

    }
//    class func
    
}
