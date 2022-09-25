import Cocoa

/**
 A custom subclass of `NSScrollView`.
 
 Reference: [](https://stackoverflow.com/a/58307677/10446972).
 */
public class CKScrollView : NSScrollView {
    
    /// Scrolls a clip view to a point, animated.
    public override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        CATransaction.begin()
        // abort currently-running animations
        CATransaction.setDisableActions(true)
        self.contentView.setBoundsOrigin(point)
        CATransaction.commit()
    }
    
}

public extension NSScrollView {
    
    /// Scrolls a point to the origin of scroll view's content view, animated.
    func scroll(to point: NSPoint, animationDuration: Double, completionHandler: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animationDuration
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.contentView.animator().setBoundsOrigin(point)
            self.reflectScrolledClipView(self.contentView)
        }, completionHandler: completionHandler)
    }
    
}
