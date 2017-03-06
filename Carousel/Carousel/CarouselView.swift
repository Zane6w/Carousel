//
//  CarouselView.swift
//  Carousel
//
//  Created by zhi zhou on 2017/3/6.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class CarouselView: UIView {
    
    // MARK:- 内部属性
    fileprivate let scrollView = UIScrollView()
    fileprivate let pageControl = UIPageControl()
    fileprivate var timer: Timer?
    
    fileprivate var previousImageView: UIImageView?
    fileprivate var nowImageView: UIImageView?
    fileprivate var nextImageView: UIImageView?
    /// 当前索引
    fileprivate var currentIndex = 0
    
    // MARK:- 开放属性
    /// 自动滚动时间间隔
    var scrollTime: TimeInterval = 0 {
        didSet {
            timer?.invalidate()
            timer = nil
            startTimer(scrollTime)
        }
    }
    
    /// 图片数组
    var images = [UIImage]() {
        didSet {
            let width = scrollView.bounds.width
            
            scrollView.contentSize = CGSize(width: CGFloat(images.count) * width, height: 0)
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
            pageControl.numberOfPages = images.count
            
            setupImageView(images)
        }
    }
    
    /// 是否隐藏页数指示器
    var isHiddenPageControl = false {
        didSet {
            pageControl.isHidden = isHiddenPageControl
        }
    }
    
    /// 页数指示器默认颜色
    var pageIndicatorTintColor: UIColor? {
        didSet {
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    /// 当前页面页数指示器颜色
    var currentPageIndicatorTintColor: UIColor? {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    
    typealias TapHandler = (UIImage, Int) -> Void
    /// 图片点击事件（参数：图片，索引）
    var imageTapHandler: TapHandler?
    
    
    // MARK:- 系统函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInterface()
        startTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 界面设置
extension CarouselView {
    
    fileprivate func setupInterface() {
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        setupTapGesture()
        
        self.addSubview(scrollView)
        
        /* ---------- */
        
        pageControl.sizeToFit()
        let pageCenterY: CGFloat = self.bounds.height - 16 - pageControl.bounds.height * 0.5
        pageControl.center = CGPoint(x: self.bounds.width * 0.5, y: pageCenterY)
        pageControl.hidesForSinglePage = true
        
        self.addSubview(pageControl)
    }
    
    fileprivate func setupImageView(_ images: [UIImage]) {
        previousImageView = UIImageView(image: images.last)
        nowImageView = UIImageView(image: images.first)
        nextImageView = UIImageView(image: images[1])
        
        previousImageView?.isUserInteractionEnabled = true
        nowImageView?.isUserInteractionEnabled = true
        nextImageView?.isUserInteractionEnabled = true
        
        previousImageView?.frame = CGRect(origin: .zero, size: scrollView.bounds.size)
        nowImageView?.frame = CGRect(origin: CGPoint(x: 1 * scrollView.bounds.width, y: 0), size: scrollView.bounds.size)
        nextImageView?.frame = CGRect(origin: CGPoint(x: 2 * scrollView.bounds.width, y: 0), size: scrollView.bounds.size)
        
        scrollView.addSubview(previousImageView!)
        scrollView.addSubview(nowImageView!)
        scrollView.addSubview(nextImageView!)
    }
    
}

// MARK:- 图片点击事件
extension CarouselView: UIGestureRecognizerDelegate {
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
        tapGesture.delegate = self
        
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func tap(gesture: UITapGestureRecognizer) {
        if imageTapHandler != nil {
            imageTapHandler!(images[pageControl.currentPage], pageControl.currentPage)
        }
    }
    
}

// MARK:- 定时器
extension CarouselView {
    
    fileprivate func startTimer(_ timeInterval: TimeInterval = 1.0) {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    // 翻到下一页
    @objc fileprivate func nextPage() {
        let offsetX: CGFloat = 2 * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

// MARK:- Scroll View 方法函数
extension CarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        
        let scrollViewWidth = scrollView.bounds.width
        
        if offsetX >= scrollViewWidth * 2 {
            scrollView.contentOffset = CGPoint(x: scrollViewWidth, y: 0)
            self.currentIndex = currentIndex + 1
            
            if self.currentIndex == images.count - 1 {
                previousImageView?.image = images[currentIndex - 1]
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images.first
                
                pageControl.currentPage = currentIndex
                currentIndex = -1
            } else if currentIndex == images.count {
                previousImageView?.image = images.last
                nowImageView?.image = images.first
                nextImageView?.image = images[1]
                
                pageControl.currentPage = 0
                currentIndex = 0
            } else if currentIndex == 0 {
                previousImageView?.image = images.last
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images[currentIndex + 1]
                
                pageControl.currentPage = currentIndex
            } else {
                previousImageView?.image = images[currentIndex - 1]
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images[currentIndex + 1]
                
                pageControl.currentPage = currentIndex
            }
        }
        
        if offsetX <= 0 {
            scrollView.contentOffset = CGPoint(x: scrollViewWidth, y: 0);
            
            currentIndex -= 1
            
            if currentIndex == -2 {
                currentIndex = images.count - 2
                
                previousImageView?.image = images[currentIndex - 1]
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images.last
                
                pageControl.currentPage = currentIndex
            } else if currentIndex == -1 {
                currentIndex = images.count - 1
                
                previousImageView?.image = images[currentIndex - 1]
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images.first
                
                pageControl.currentPage = currentIndex
            } else if currentIndex == 0 {
                previousImageView?.image = images.last
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images[currentIndex + 1]
                
                pageControl.currentPage = currentIndex
            } else {
                previousImageView?.image = images[currentIndex - 1]
                nowImageView?.image = images[currentIndex]
                nextImageView?.image = images[currentIndex + 1]
                
                pageControl.currentPage = currentIndex
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
}
