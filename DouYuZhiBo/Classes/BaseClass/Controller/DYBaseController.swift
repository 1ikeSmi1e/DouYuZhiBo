//
//  BaseController.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

class DYBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let AAgr = [String]()
//        
//        guard let firstStr = AAgr.first else {
//            
//           print("来到了这里")
//            return
//        }
//         print(firstStr)
        
        
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        get {
            return .default
        }
    }

}
