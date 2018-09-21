//
//  DYPageTitleView.swift
//  DouYuZhiBo
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 ysepay. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol DYPageTitleViewDelegate : class{
    func PageTitleViewDidClickItem(pageTitleView : DYPageTitleView, selectIndex: Int)
}

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2.0
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class DYPageTitleView: UIView {

    private var titles : [String]
    private var titleLables = [UILabel]()
    private var selectedIndex : Int = 0
    weak var delegate : DYPageTitleViewDelegate?
    
    private lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView(frame: bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scollLine = UIView()
        scollLine.backgroundColor = UIColor.orange
        return scollLine
    }()
    
    init(frame: CGRect, titles: [String]) {
        
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// mark : 添加内部子控件
extension DYPageTitleView{
    
    private func setupUI(){
        
        addSubview(scrollView)
        
        setupTitleLables()
        
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLables(){
        
        let labelW = frame.width / CGFloat(titles.count)
        let labelH = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        for (index, title) in titles.enumerated() {
            
            let label = UILabel(frame: CGRect(x: labelW*CGFloat(index), y: labelY, width: labelW, height: labelH))
            label.text = title
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.tag = index + 1000
            scrollView .addSubview(label)
            
            titleLables.append(label)
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLableTapped(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    @objc private func titleLableTapped(_ sender: UITapGestureRecognizer){
        
        let targetLabel = sender.view as! UILabel
        let currentLable = titleLables[selectedIndex]
        if currentLable == targetLabel {  return }
        
        currentLable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        targetLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

        selectedIndex = targetLabel.tag - 1000
        
        // 选中下标指示条
        UIView.animate(withDuration: 0.1) {
            self.scrollLine.frame.origin.x = targetLabel.frame.origin.x
        }
        
        delegate?.PageTitleViewDidClickItem(pageTitleView: self, selectIndex: selectedIndex)
//        print("labelTapped -- \(titleLabel.text ?? "空label")")
    }
    
    private func setupBottomLineAndScrollLine() {
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 添加滑动指示
        guard let firstLabel = titleLables.first else { return  }
        
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
        
    }
}


extension DYPageTitleView : DYPageContentViewDelegate{
    
    func pageContentViewDidScroll(_ contentView: DYPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLables[sourceIndex]
        let targetLabel = titleLables[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        selectedIndex = targetIndex
    }
}
