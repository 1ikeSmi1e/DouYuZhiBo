//
//  DYHomeController.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

class DYHomeController: DYBaseController {

    private lazy var pageTitleView: DYPageTitleView = {
        
        let y = (navigationController?.navigationBar.frame.maxY)!
        let frame = CGRect(x: 0, y: y, width: kMSWidth, height: 44.0)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = DYPageTitleView(frame: frame, titles: titles)
//        titleView.backgroundColor = UIColor.purple
        return titleView
    }()
    
    lazy var pageContentView: DYPageContentView = { [weak self] in
        
        let contentH : CGFloat = kMSHeight - pageTitleView.frame.maxY - (tabBarController?.tabBar.bounds.height)!
        let frame = CGRect(x: 0, y: pageTitleView.frame.maxY, width: kMSWidth, height: contentH)
        
        var childVcs = [UIViewController]()
        for _ in 0..<4 {
            let vc = DYBaseController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let pageContentView = DYPageContentView(frame: frame, childVcs: childVcs, parentViewController: self)
        return pageContentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
    }
}



// MARK : -设置UI界面
extension DYHomeController{
    
    private func setupUI(){
        
        setupNavigationBar()
        
        view.addSubview(pageTitleView)
        
        view.addSubview(pageContentView)
        
        pageTitleView.delegate = pageContentView
        pageContentView.delegate = pageTitleView
    }
    
    
    private func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        let itemSize = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highlightImgName: "image_my_history_click", size: itemSize)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highlightImgName: "btn_search_click", size: itemSize)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highlightImgName: "Image_scan_click", size: itemSize)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}



