# iOS-ViewPagerIndicator
Paging indicator widgets,swift版的分页指示器，可以配合UIScrollView使用完成分页控制


## Demo

![](https://github.com/saiwu-bigkoo/iOS-ViewPagerIndicator/blob/master/preview/indicator.gif)

```swift
//样式设置
viewPagerIndicator.setTitleColorForState(UIColor.blackColor(), state: UIControlState.Selected)
viewPagerIndicator.setTitleColorForState(UIColor.blackColor(), state: UIControlState.Normal)
viewPagerIndicator.tintColor = UIColor.brownColor()
viewPagerIndicator.showBottomLine = false
viewPagerIndicator.autoAdjustSelectionIndicatorWidth = true
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
