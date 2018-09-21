//
//  DYPageContentView.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

protocol DYPageContentViewDelegate : class {
    func pageContentViewDidScroll(_ contentView : DYPageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let reuseId = "DYPageContentViewCell"

class DYPageContentView: UIView {

    
    private var childVCs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var isForbidScrollDelegate : Bool = false
    private var startOffsetX : CGFloat = 0
    weak var delegate : DYPageContentViewDelegate?
    
    private lazy var collectionView : UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionView.alwaysBounceVertical = false
//        collectionView.alwaysBounceHorizontal = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        if #available(iOS 11.0,  *){
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentViewController : UIViewController?) {
        
        self.childVCs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// mark: 内部子控件
extension DYPageContentView{
    private func setupUI(){
        
        for childVc in childVCs {
            parentViewController?.addChildViewController(childVc)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    
}

extension DYPageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVCs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}


// MARK:- 点击了标题
extension DYPageContentView : DYPageTitleViewDelegate{
    
    func PageTitleViewDidClickItem(pageTitleView: DYPageTitleView, selectIndex: Int) {
        
        isForbidScrollDelegate = true
        
        // 1. 切换到对应内容控制器
        let offsetX : CGFloat = CGFloat(selectIndex) * self.bounds.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated:false)
    }
}


// MARK:- 遵守UICollectionViewDelegate
extension DYPageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentViewDidScroll(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
