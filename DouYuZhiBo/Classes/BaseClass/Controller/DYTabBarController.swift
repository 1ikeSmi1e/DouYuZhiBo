//
//  DYTabBarController.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

class DYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.orange
        // Do any additional setup after loading the view.
        
        
        addChildViewController(DYHomeController(), title: "首页", imageNomal: "Tabbar_home", selectedImage: "Tabbar_home_selected")
        
        addChildViewController(DYLiveController(), title: "直播", imageNomal: "Tabbar_Live", selectedImage: "Tabbar_Live_selected")
        
        addChildViewController(DYFollowController(), title: "关注", imageNomal: "Tabbar_Follow", selectedImage: "Tabbar_Follow_selected")
        
        addChildViewController(DYMineController(), title: "我的", imageNomal: "Tabbar_Mine", selectedImage: "Tabbar_Mine_selected")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DYTabBarController{
    
    private func addChildViewController(_ childController: UIViewController, title: String, imageNomal: String, selectedImage:String) {
        
        let imgNormal = UIImage(named: imageNomal)
        let imgSelected = UIImage(named: selectedImage)
        let navController = DYNavigationController(rootViewController: childController)
        navController.tabBarItem = UITabBarItem(title: title, image: imgNormal, selectedImage: imgSelected)
        self.addChildViewController(navController)
    }
    
}
