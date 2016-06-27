# Flip Side Menu

FlipSideMenu 主要由三个部分组成：

1. `Menu`协议，用于获取每一个MenuItem
2. `MenuItemsAnimator`，负责动画的实现
3. `MenuTransitionAnimator`，负责实现`UIViewControllerAnimatedTransitioning`协议

### Menu 

`Menu`的实现如下

``` Swift
protocol Menu {
    var menuItems: [UIView] {get}
}
```

### MenuItemsAnimator

`MenuItemsAnimator`负责动画的实现。为了达到3D的效果，它修改了UIView中layer的transform属性。CATransform3D是一个4x4(mij)的矩阵，其中m34代表景深，当m34=1/z，且z为正数时，摄像头的位置就是人眼的位置，z越大，摄像头离物体越远，默认情况下，z无限大。

`MenuItemsAnimator`代码实现如下：

``` Swift
class MenuItemsAnimator {
    var completion: () -> Void = {}
    var duration: CFTimeInterval = 0.0
    
    private let layers: [CALayer]
    private let startAngle : CGFloat
    private let endAngle : CGFloat
    
    init(views: [UIView], startAngle: CGFloat, endAngle: CGFloat) {
        self.layers = views.map({$0.layer})
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    // start animating
    func start() {
        let count = Double(layers.count)
        let duration = count * self.duration / (4*count - 3)
        for (index, layer) in self.layers.enumerate() {
            layer.transform = transformRotationLayer(layer, angle: startAngle)
            
            let delay = 3 * Double(index) * duration / count
            UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {
                layer.transform = self.transformRotationLayer(layer, angle: self.endAngle)
                }, completion: nil)
        }
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()){
            self.completion()
        }
    }
    
    // MARK: return layer's transform for animating
    private func transformRotationLayer(layer: CALayer, angle: CGFloat) -> CATransform3D {
        let offset = layer.bounds.width / 2.0
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        
        transform = CATransform3DTranslate(transform, -offset, 0, 0)
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        transform = CATransform3DTranslate(transform, offset, 0, 0)
        
        return transform
    }
}

```

### MenuTransitionAnimator

`MenuTransitionAnimator`负责实现UIViewControllerAnimatedTransitioning协议，该协议有两个方法：

``` Swift
// 返回动画的时长
func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval

// 动画的实现
func animateTransition(transitionContext: UIViewControllerContextTransitioning)
```

`animateTransition`方法调用`MenuItemsAnimator`来实现动画

在实现了`MenuTransitionAnimator`后，在ViewController中，我们只要指定MenuViewController的`transitioningDelegate`，并在对应协议方法中返回`MenuTransitionAnimator`实例对应即可。

