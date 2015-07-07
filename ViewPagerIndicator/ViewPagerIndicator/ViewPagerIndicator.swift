//
//  ViewPagerIndicator.swift
//  ViewPagerIndicator
//
//  Created by Sai on 15/4/28.
//  Copyright (c) 2015年 Sai. All rights reserved.
//

import UIKit
//@IBDesignable
public class ViewPagerIndicator: UIControl {
    public enum IndicatorDirection{
        case Top,Bottom
    }
    public var indicatorDirection: IndicatorDirection = .Bottom
    @IBInspectable public var indicatorHeight: CGFloat = 2.0
    var indicatorIndex = -1
    @IBInspectable public var animationDuration: CGFloat = 0.2
    @IBInspectable public var autoAdjustSelectionIndicatorWidth: Bool = false//下横线是否适应文字大小
    var isTransitioning = false//是否在移动
    public var bouncySelectionIndicator = true//选择器动画是否支持bouncy效果
    public var colors = Dictionary<String,UIColor>()
    public var titleFont :UIFont = UIFont.systemFontOfSize(17){
        didSet{
            self.layoutIfNeeded()
        }
    }
    public var titles = NSMutableArray(){
        willSet(newTitles){
            //先移除后添加
            removeButtons()
            titles.addObjectsFromArray(newTitles as [AnyObject])
        }
        didSet{
            addButtons()
        }
    }
    var buttons = NSMutableArray()

    
    var selectionIndicator: UIView!//选中标识
    var bottomLine: UIView!//底部横线
    @IBInspectable public var showBottomLine: Bool = true{
        didSet{
            bottomLine.hidden = !showBottomLine
        }
    }
    public var delegate: ViewPagerIndicatorDelegate?
    public var count:Int {
        get{
            return titles.count
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit(){
        selectionIndicator = UIView()
        bottomLine = UIView()
        self.addSubview(selectionIndicator)
        self.addSubview(bottomLine)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        //设置默认选择哪个item
        if buttons.count == 0{
            indicatorIndex = -1
        }
        else if indicatorIndex < 0{
            indicatorIndex = 0
        }
        //button位置调整
        for (var index = 0;index < buttons.count; index++ ){
            let left = roundf((Float(self.bounds.size.width)/Float(self.buttons.count)) * Float(index))
            let width = roundf(Float(self.bounds.size.width)/Float(self.buttons.count))
            let button = buttons[index] as! UIButton
            button.frame = CGRectMake(CGFloat(left), 0, CGFloat(width),self.bounds.size.height)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0)
            button.titleLabel?.font = titleFont
            
            button.setTitleColor(titleColorForState(UIControlState.Normal),forState: UIControlState.Normal)
            button.setTitleColor(titleColorForState(UIControlState.Selected),forState: UIControlState.Selected)

            if (index == indicatorIndex){
                button.selected = true
            }
        }
        selectionIndicator.frame = selectionIndicatorRect()
        bottomLine.frame = bottomLineRect()
        selectionIndicator.backgroundColor = self.tintColor
        bottomLine.backgroundColor = self.tintColor

        self.sendSubviewToBack(selectionIndicator)
    }
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        self.layoutIfNeeded()
    }
    
    //底线Rect
    func bottomLineRect() ->CGRect{
        //控件底部横线
        var frame = CGRectMake(0, 0, self.frame.size.width, 0.5)
        if(indicatorDirection == .Top){
            frame.origin.y = 0
        }
        else{
            frame.origin.y = self.frame.size.height
        }
        
        return frame
    }
    //获取指示器的Rect
    func selectionIndicatorRect() ->CGRect{
        var frame = CGRect()
        let button = selectedButton()
        if indicatorIndex < 0 {return frame}
        let title = titles[indicatorIndex] as? NSString
        if title?.length<=0 || button == nil {return frame}
        
        if(indicatorDirection == .Top){
            frame.origin.y = 0
        }
        else{
            frame.origin.y = button!.frame.size.height - indicatorHeight
        }
        
        //底部指示器如果宽度适应内容
        if(autoAdjustSelectionIndicatorWidth){
            var attributes:[NSObject : AnyObject]!
            let attributedString = button?.attributedTitleForState(UIControlState.Selected)
            attributes = attributedString?.attributesAtIndex(0, effectiveRange: nil)
            frame.size = CGSizeMake(title!.sizeWithAttributes(attributes).width, indicatorHeight)
            //计算指示器x坐标
            frame.origin.x = (button!.frame.size.width * CGFloat(indicatorIndex)) + (button!.frame.width - frame.size.width)/2
        }
        else{//如果不是适应内容则宽度平分控件
            frame.size = CGSizeMake(button!.frame.size.width, indicatorHeight)
            frame.origin.x = button!.frame.size.width * CGFloat(indicatorIndex)
        }
        
        return frame
    }
    //设置选中哪一个
    public func setSelectedIndex(index: Int){
        setSelected(true,index: index)
    }
    public func getSelectIndex() ->Int{
        return indicatorIndex
    }
    //设置选中哪一个
    func setSelected(selected: Bool, index: Int){
        if(isTransitioning || indicatorIndex == index){return}
        disableAllButtonsSelection()
        enableAllButtonsInteraction(false)
        
        let duration:CGFloat = indicatorIndex < 0 ? 0 : animationDuration
      
        indicatorIndex = index
        isTransitioning = true
        delegate?.indicatorChange(indicatorIndex)//通知代理
        
        let button = buttons[index] as! UIButton
        button.selected = true
        var damping: CGFloat = !bouncySelectionIndicator ? 0 : 0.6
        var velocity: CGFloat = !bouncySelectionIndicator ? 0 : 0.5
        //底部滑条的动画效果
        UIView.animateWithDuration(NSTimeInterval(duration), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.selectionIndicator.frame = self.selectionIndicatorRect()
        }) { (_) -> Void in
            self.enableAllButtonsInteraction(true)
            button.userInteractionEnabled = false
            button.selected = true

            self.isTransitioning = false
        }
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
        self.layoutIfNeeded()
    }
    //选中的button
    func selectedButton() ->UIButton?{
        if(indicatorIndex >= 0 && buttons.count > 0){
            return buttons[indicatorIndex] as? UIButton
        }
        return nil
    }
    func addButtons(){
        for( var i = 0; i < titles.count; i++ ) {
            var button = UIButton()
            button.addTarget(self, action: "didSelectedButton:", forControlEvents: .TouchUpInside)

            button.exclusiveTouch = true//禁止多个按钮同时被按下
            button.tag = i
            
            button.setTitle(titles[i] as? String, forState: UIControlState.Normal)
//            button.setTitle(titles[i] as? String, forState: UIControlState.Highlighted)
//            button.setTitle(titles[i] as? String, forState: UIControlState.Selected)
//            button.setTitle(titles[i] as? String, forState: UIControlState.Disabled)

            
            self.addSubview(button)
            buttons.addObject(button)
            
        }
        selectionIndicator.frame = selectionIndicatorRect()
        
    }
    func removeButtons(){
        if(isTransitioning){return}
        for button in buttons{
            button.removeFromSuperview()
        }
        buttons.removeAllObjects()
        titles.removeAllObjects()
    }

    func didSelectedButton(sender: UIButton){
        sender.highlighted = false
        sender.selected = true
        setSelectedIndex(sender.tag)
    }
    
    func titleColorForState(state: UIControlState) ->UIColor{
        
        if let color = colors[String(state.rawValue)]{
            return color
        }
        switch(state){
        case UIControlState.Normal:
            return UIColor.darkGrayColor()
        case UIControlState.Highlighted,UIControlState.Selected:
            return self.tintColor
        case UIControlState.Disabled:
            return UIColor.lightGrayColor()
        default:
            return self.tintColor
        }
    }
    public func setTitleColorForState(color: UIColor, state: UIControlState){
        colors.updateValue(color, forKey: String(state.rawValue))
    }
    func disableAllButtonsSelection(){
        for button in buttons {
            (button as! UIButton).selected = false
        }
    }
    func enableAllButtonsInteraction(enable: Bool){
        for button in buttons {
            (button as! UIButton).userInteractionEnabled = enable
        }
    }
    
}
@objc
public protocol ViewPagerIndicatorDelegate{
    //返回当前选中第几个
    func indicatorChange(indicatorIndex: Int)
}
