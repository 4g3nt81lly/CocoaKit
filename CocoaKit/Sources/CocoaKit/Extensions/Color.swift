import Cocoa

public extension NSColor {
    
    static let transparent = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    static func random(excluding exclusion: [NSColor] = [], randomizeAlpha: Bool = false) -> NSColor {
        var color: NSColor {
            return NSColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: randomizeAlpha ? .random(in: 0...1) : 1)
        }
        var randomColor = color
        while exclusion.contains(randomColor) {
            randomColor = color
        }
        return randomColor
    }
    
    func hex(alpha: Bool = false) -> UInt64? {
        guard let components = self.cgColor.components,
              components.count >= 3 else {
            return nil
        }
        
        let r = UInt64(lroundf(Float(components[0] * 255)))
        let g = UInt64(lroundf(Float(components[1] * 255)))
        let b = UInt64(lroundf(Float(components[2] * 255)))
        let needsAlpha = alpha && (components.count == 4)
        let a = UInt64(lroundf((needsAlpha ? Float(components[3]) : 1.0) * 255))
        
        var hexInt = (r << 16) + (g << 08) + (b << 00)
        
        if needsAlpha {
            hexInt = (r << 24) + (g << 16) + (b << 08) + (a << 00)
        }
        
        return hexInt
    }
    
    func hexString(withAlpha alpha: Bool = false, hashtag: Bool = false, uppercase: Bool = false) -> String? {
        guard let hexInt = self.hex(alpha: alpha) else {
            return nil
        }
        var string = (hashtag ? "#" : "") + String(format: "%0\(alpha ? "8" : "6")X", hexInt)
        if uppercase {
            string.uppercase()
        }
        return string
    }
    
    convenience init(hex: UInt64) {
        var rgbaComponents = (
            r: CGFloat((hex >> 16) & 0xff) / 255,
            g: CGFloat((hex >> 08) & 0xff) / 255,
            b: CGFloat((hex >> 00) & 0xff) / 255,
            a: CGFloat(1)
        )
        if hex.isBetween(0xffffff00, 0xffffffff, inclusive: true) {
            rgbaComponents = (
                r: CGFloat((hex >> 24) & 0xff) / 255,
                g: CGFloat((hex >> 16) & 0xff) / 255,
                b: CGFloat((hex >> 08) & 0xff) / 255,
                a: CGFloat((hex >> 00) & 0xff) / 255
            )
        }
        self.init(red: rgbaComponents.r, green: rgbaComponents.g, blue: rgbaComponents.b, alpha: rgbaComponents.a)
    }
    
    convenience init(hex: String) {
        let trimmed = hex.replacingOccurrences(of: "#", with: String.empty).trimmingCharacters(in: .whitespacesAndNewlines)
        let hexInt = UInt64(trimmed, radix: 16) ?? 0xffffff
        self.init(hex: hexInt)
    }
    
}
