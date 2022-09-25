import Cocoa

public class CKTextView : NSTextView {
    
    /// The text view's line number ruler view.
    public private(set) var lineNumberView: CKLineNumberRulerView?
    
    /// Initializes the line number view.
    public func setupLineNumberView() {
        self.lineNumberView = CKLineNumberRulerView(textView: self)
        if self.font == nil {
            self.font = .systemFont(ofSize: NSFont.systemFontSize)
        }
        let scrollView = self.enclosingScrollView!
        scrollView.verticalRulerView = lineNumberView
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true
        
        self.postsFrameChangedNotifications = true
        scrollView.contentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLineNumberView), name: NSView.boundsDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLineNumberView), name: NSView.frameDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLineNumberView), name: NSText.didChangeNotification, object: nil)
    }
    
    /**
     Sets the line number view as needing display to redraw its view.
     
     This method is marked Objective-C as it is used as the target for the text view's bound, frame, and text-changing notifications.
     */
    @objc public func refreshLineNumberView() {
        self.lineNumberView?.needsDisplay = true
    }
    
    /// Contextual menu for text view.
    public override func menu(for event: NSEvent) -> NSMenu? {
        let menu = NSMenu()
        let pasteItem = NSMenuItem(title: "Paste", action: #selector(self.pasteAsPlainText(_:)), keyEquivalent: "")
        // if there's selected content
        guard self.selectedRange().length > 0 else {
            menu.addItem(pasteItem)
            return menu
        }
        menu.addItem(withTitle: "Copy", action: #selector(self.copy(_:)), keyEquivalent: "")
        menu.addItem(pasteItem)
        menu.addItem(withTitle: "Cut", action: #selector(self.cut(_:)), keyEquivalent: "")
        
        (self.delegate as? CKTextViewDelegate)?.textView(self, contextMenu: menu)
        
        return menu
    }
    
    /**
     Calculates rect of a given character range.
     
     Reference: [](https://stackoverflow.com/a/8919401/10446972).
     
     Objective-C Reference: [](https://stackoverflow.com/questions/11154157/how-to-calculate-correct-coordinates-for-selected-text-in-nstextview/11155388).
     
     - Parameter characterRange: A character range.
     */
    public func rectForRange(_ characterRange: NSRange) -> NSRect {
        var layoutRect: NSRect
        
        // get glyph range for characters
        let textRange = self.layoutManager!.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        let textContainer = self.textContainer!
        
        // get rect at glyph range
        layoutRect = self.layoutManager!.boundingRect(forGlyphRange: textRange, in: textContainer)
        
        // get rect relative to the text view
        let containerOrigin = self.textContainerOrigin
        layoutRect.origin.x += containerOrigin.x
        layoutRect.origin.y += containerOrigin.y
        
        // layoutRect = self.convertToLayer(layoutRect)
        
        return layoutRect
    }
    
    /**
     Scrolls a given range to center of the text view, animated.
     
     This method uses `rectForRange(_:)` to determine the rect of a given character range, and then scrolls the range to the center of the text view by invoking `scroll(toPoint:animationDuration:completionHandler:)`, with or without an animation.
     
     - Parameters:
        - range: A character range.
        - animated: A flag indicating whether or not the scroll should be animated.
        - completionHandler: A closure to be executed when the animation is complete.
     */
    public func scrollRangeToCenter(_ range: NSRange, animated: Bool, completionHandler: (() -> Void)? = nil) {
        guard animated else {
            super.scrollRangeToVisible(range)
            return
        }
        // move down half the height to center
        var rect = self.rectForRange(range)
        rect.origin.y -= (self.enclosingScrollView!.contentView.frame.height - rect.height) / 2 - 10
        
        self.enclosingScrollView!.scroll(to: rect.origin, animationDuration: 0.25, completionHandler: completionHandler)
    }
    
    /// Invokes `textView(_:didClick:)` to notify for user interaction.
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        (self.delegate as? CKTextViewDelegate)?.textView(self, didClick: self.selectedRange(),
                                                         atPoint: event.locationInWindow)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

protocol CKTextViewDelegate : NSTextViewDelegate, NSTextStorageDelegate {
    
    /**
     Implement to specify custom behavior upon user interaction with the target text view.
     
     This protocol method is invoked whenever the user interacts with the text view.
     
     - Parameters:
        - textView: The text view.
        - selectedRange: The range selected by the user.
        - point: The point on which the text view is clicked.
     */
    func textView(_ textView: CKTextView, didClick selectedRange: NSRange, atPoint point: NSPoint)
    
    func textView(_ textView: CKTextView, contextMenu menu: NSMenu)
    
}

