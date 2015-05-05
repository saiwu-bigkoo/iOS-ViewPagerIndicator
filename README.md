# iOS-ViewPagerIndicator
Paging indicator widgets,swift版的分页指示器，可以配合UIScrollView使用完成分页控制


## Demo

![](https://github.com/saiwu-bigkoo/iOS-ViewPagerIndicator/blob/master/preview/indicator.gif)
![](https://github.com/saiwu-bigkoo/iOS-ViewPagerIndicator/blob/master/preview/indicator2.gif)

//备注一下哦，如果在stroyboard里面拖控件，那么拖入一个UIView,设置class为ViewPagerIndicator之外，下面的module也要填写为ViewPagerIndicator哦
```swift
//样式设置
viewPagerIndicator.setTitleColorForState(UIColor.blackColor(), state: UIControlState.Selected)//选中文字的颜色
viewPagerIndicator.setTitleColorForState(UIColor.blackColor(), state: UIControlState.Normal)//正常文字颜色
viewPagerIndicator.tintColor = UIColor.brownColor()//指示器和基线的颜色
viewPagerIndicator.showBottomLine = false//基线是否显示
viewPagerIndicator.autoAdjustSelectionIndicatorWidth = true//指示器宽度是按照文字内容大小还是按照count数量平分屏幕
viewPagerIndicator.indicatorDirection = .Top//指示器位置
viewPagerIndicator.indicatorHeight = viewPagerIndicator.bounds.height//指示器高度
```
```swift
//点击viewPagerIndicator可以控制scrollView
//滑动scrollView可以改变viewPagerIndicator
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

```
