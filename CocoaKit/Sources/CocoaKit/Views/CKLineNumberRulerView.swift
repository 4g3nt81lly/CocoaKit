import Cocoa

public class CKLineNumberRulerView : NSRulerView {
    
    public var font: NSFont = {
        let size = NSFont.systemFontSize
        if #available(macOS 10.15, *) {
            return .monospacedSystemFont(ofSize: size, weight: .regular)
        } else {
            return NSFont(name: "Menlo-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
        }
    }() {
        didSet {
            self.needsDisplay = true
        }
    }
    
    public init(textView: NSTextView) {
        super.init(scrollView: textView.enclosingScrollView!, orientation: .verticalRuler)
        self.clientView = textView
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = self.clientView as? NSTextView else {
            return
        }
        textView.backgroundColor.setFill()
        rect.fill()
        
        let lineCountDigit = "\(textView.string.components(separatedBy: "\n").count)".count
        self.ruleThickness = CGFloat(lineCountDigit * 8 + 10)
        
        if let layoutManager = textView.layoutManager {
            
            let relativePoint = self.convert(NSZeroPoint, from: textView)
            let lineNumberAttributes: [NSAttributedString.Key : Any] = [.font : self.font, .foregroundColor : NSColor.gray]
            
            let drawLineNumber = { (lineNumberString: String, y: CGFloat) -> Void in
                let attString = NSAttributedString(string: lineNumberString, attributes: lineNumberAttributes)
                let x = self.ruleThickness - attString.size().width - 5
                attString.draw(at: NSPoint(x: x, y: relativePoint.y + y))
            }
            
            let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: textView.visibleRect, in: textView.textContainer!)
            let firstVisibleGlyphCharacterIndex = layoutManager.characterIndexForGlyph(at: visibleGlyphRange.location)
            
            let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])
            // The line number for the first visible line
            var lineNumber = newLineRegex.numberOfMatches(in: textView.string, options: [], range: NSMakeRange(0, firstVisibleGlyphCharacterIndex)) + 1
            
            var glyphIndexForStringLine = visibleGlyphRange.location
            
            // Go through each line in the string.
            while glyphIndexForStringLine < NSMaxRange(visibleGlyphRange) {
                
                // Range of current line in the string.
                let characterRangeForStringLine = (textView.string as NSString).lineRange(
                    for: NSMakeRange(layoutManager.characterIndexForGlyph(at: glyphIndexForStringLine), 0)
                )
                let glyphRangeForStringLine = layoutManager.glyphRange(forCharacterRange: characterRangeForStringLine, actualCharacterRange: nil)
                
                var glyphIndexForGlyphLine = glyphIndexForStringLine
                var glyphLineCount = 0
                
                while ( glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) ) {
                    
                    // See if the current line in the string spread across
                    // several lines of glyphs
                    var effectiveRange = NSMakeRange(0, 0)
                    
                    // Range of current "line of glyphs". If a line is wrapped,
                    // then it will have more than one "line of glyphs"
                    let lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndexForGlyphLine, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                    
                    if glyphLineCount > 0 {
                        drawLineNumber("", lineRect.minY)
                    } else {
                        drawLineNumber("\(lineNumber)", lineRect.minY + 1)
                    }
                    
                    // Move to next glyph line
                    glyphLineCount += 1
                    glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
                }
                
                glyphIndexForStringLine = NSMaxRange(glyphRangeForStringLine)
                lineNumber += 1
            }
            
            // Draw line number for the extra line at the end of the text
            if layoutManager.extraLineFragmentTextContainer != nil {
                drawLineNumber("\(lineNumber)", layoutManager.extraLineFragmentRect.minY)
            }
        }
    }
}
