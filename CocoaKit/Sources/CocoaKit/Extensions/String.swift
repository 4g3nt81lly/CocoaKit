import Cocoa

public extension String {
    
    static let empty = ""
    static let whitespace = " "
    static let newLine = "\n"
    static let carriageReturn = "\r"
    
    static let lowercased = "abcdefghijklmnopqrstuvwxyz"
    static let uppercased = String.lowercased.uppercased()
    
    static let letters = String.lowercased + String.uppercased
    
    static let digits = (0...9).flattened.map({ String($0) }).joined()
    
    static let punctuations = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
    
    func count(item: String) -> Int {
        return self.components(separatedBy: item).count - 1
    }
    
    func count(pattern: String, options: NSRegularExpression.Options = []) throws -> Int {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        let fullRange = NSRange(location: 0, length: (self as NSString).length)
        let number = regex.numberOfMatches(in: self, range: fullRange)
        return number
    }
    
    func split(at index: Int) -> [String] {
        guard index.isIn(collection: self) else {
            return [self]
        }
        let (left, right) = (self[..<index]!, self[index...]!)
        return [left, right]
    }
    
    func disintegrate() -> [String] {
        return self.map { String($0) }
    }
    
    mutating func capitalize() {
        self = self.capitalized
    }
    
    mutating func lowercase() {
        self = self.lowercased()
    }
    
    mutating func uppercase() {
        self = self.uppercased()
    }
    
    subscript(index: Int) -> String? {
        get {
            let characters = self.disintegrate().ckArray
            return characters[index]
        }
        set {
            let characters = self.disintegrate().ckArray
            characters[index] = newValue
            self = characters.joined()
        }
    }
    
    subscript(range: any RangeExpression<Int>) -> String? {
        get {
            let characters = self.disintegrate().ckArray
            return characters[range]?.joined()
        }
        set {
            let characters = self.disintegrate().ckArray
            characters[range] = newValue?.disintegrate() ?? []
            self = characters.joined()
        }
    }
    
}

extension NSString {
    
    /// Swift String value of the `NSString` object.
    var string: String {
        return self as String
    }
    
}
