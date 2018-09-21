//
//  UIBarbuttonItem-Extension.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    //extension 只能扩充便利构造函数
    
    convenience init(imageName: String, highlightImgName: String = "", size : CGSize = CGSize.zero){
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        
        if highlightImgName.count > 0 {
            btn.setImage(UIImage(named: highlightImgName), for: .highlighted)
        }
        
        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)
    }
}
