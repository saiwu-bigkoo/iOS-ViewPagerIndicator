//
//  ViewController.swift
//  IndicatorDemo
//
//  Created by Sai on 15/4/30.
//  Copyright (c) 2015年 Sai. All rights reserved.
//

import UIKit
import ViewPagerIndicator

class ViewController: UIViewController ,ViewPagerIndicatorDelegate,UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewPagerIndicator: ViewPagerIndicator!
    var scrollViewHeight: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPagerIndicator.titles = ["Apple","Banana","Cherry","Durin"]
        //监听ViewPagerIndicator选中项变化
        viewPagerIndicator.delegate = self
        scrollViewHeight = self.view.bounds.height - viewPagerIndicator.bounds.height - 20
        //样式
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        //内容大小
        scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(viewPagerIndicator.count ), height: scrollViewHeight)
        //根据顶部的数量加入子Item
        for(var i = 0; i < viewPagerIndicator.count; i++ ){
            let title = viewPagerIndicator.titles[i] as! String
            let textView = UILabel(frame: CGRectMake(self.view.bounds.width * CGFloat(i), 0, self.view.bounds.width, scrollViewHeight))
            textView.text = title
            textView.textAlignment = NSTextAlignment.Center
            scrollView.addSubview(textView)
        }
//        viewPagerIndicator.setTitleColorForState(UIColor.blackColor(), state: UIControlState.Selected)
//        viewPagerIndicator.setTitleColorForState(UIColor.blackColor(), state: UIControlState.Normal)
//        viewPagerIndicator.tintColor = UIColor.brownColor()
//        viewPagerIndicator.showBottomLine = false
//        viewPagerIndicator.autoAdjustSelectionIndicatorWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //点击顶部选中后回调
    func indicatorChange(indicatorIndex: Int){
        scrollView.scrollRectToVisible(CGRectMake(self.view.bounds.width * CGFloat(indicatorIndex), 0, self.view.bounds.width, scrollViewHeight), animated: true)
    }
    //滑动scrollview回调
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var xOffset: CGFloat = scrollView.contentOffset.x
        var x: Float = Float(xOffset)
        var width:Float = Float(self.view.bounds.width)
        let index = Int((x + (width * 0.5)) / width)
        viewPagerIndicator.setSelectedIndex(index)//改变顶部选中
    }
}

