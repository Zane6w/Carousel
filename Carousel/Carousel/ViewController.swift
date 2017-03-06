//
//  ViewController.swift
//  Carousel
//
//  Created by zhi zhou on 2017/3/6.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- 属性
    var pageView: CarouselView?
    let textView = UITextView()
    
    
    // MARK:- 方法函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarouselView()
        setupTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 设置轮播视图
    fileprivate func setupCarouselView() {
        let frame = CGRect(x: 0, y: 36, width: UIScreen.main.bounds.width, height: 300)
        pageView = CarouselView(frame: frame)
        pageView?.images = [#imageLiteral(resourceName: "img0"), #imageLiteral(resourceName: "img1"), #imageLiteral(resourceName: "img2"), #imageLiteral(resourceName: "img3"),#imageLiteral(resourceName: "img4")]
        pageView?.scrollTime = 1.5
        
        self.view.addSubview(pageView!)
        
        // 点击事件
        pageView?.imageTapHandler = { (image, index) in
            print("\(image) -- \(index)")
        }
    }
    
    
    /**
     设置 TextView 来证明“自动轮播”不会被其他操作打断
     */
    fileprivate func setupTextView() {
        textView.frame = CGRect(x: 16, y: (pageView?.frame.maxY)! + 20, width: UIScreen.main.bounds.width - 16 * 2, height: 200)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        self.view.addSubview(textView)
    }

}
