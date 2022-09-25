import Cocoa

public extension BinaryInteger {
    
    func isIn<RangeType: RangeExpression>(_ range: RangeType) -> Bool where RangeType.Bound == Self {
        return range.contains(self)
    }
    
    func isIn(collection: any Collection) -> Bool {
        return self.isIn(0 ..< Self(collection.count))
    }
    
    func isIn(sequence: any Sequence) -> Bool {
        return self.isIn(0 ..< Self(sequence.count))
    }
    
    func isBetween(_ lowerBound: Self, _ upperBound: Self, inclusive: Bool = false) -> Bool {
        return self.isIn(lowerBound ..< (upperBound + (inclusive ? 1 : 0)))
    }
    
}

public extension FloatingPoint {
    
    func isIn<RangeType: RangeExpression>(_ range: RangeType) -> Bool where RangeType.Bound == Self {
        return range.contains(self)
    }
    
    func isIn(collection: any Collection) -> Bool {
        return self.isIn(0 ..< Self(collection.count))
    }
    
    func isIn(sequence: any Sequence) -> Bool {
        return self.isIn(0 ..< Self(sequence.count))
    }
    
    func isBetween(_ lowerBound: Self, _ upperBound: Self, inclusive: Bool = false) -> Bool {
        return self.isIn(lowerBound ..< (upperBound + (inclusive ? 1 : 0)))
    }
    
}

public extension Range where Bound : Numeric & Strideable {
    
    var closed: ClosedRange<Bound> {
        return self.lowerBound ... (self.upperBound - 1)
    }
    
    func isIn(_ range: Self) -> Bool {
        return range.contains(self.lowerBound) && self.upperBound <= range.upperBound
    }
    
    func isIn(closedRange: ClosedRange<Bound>) -> Bool {
        return closedRange.contains(self.lowerBound) && closedRange.contains(self.upperBound)
    }
    
    func isIn(collection: any Collection) -> Bool {
        let range = collection.range
        let genericRange = Self(uncheckedBounds: (lower: Bound(exactly: range.lowerBound)!,
                                                  upper: Bound(exactly: range.upperBound)!))
        return self.isIn(genericRange)
    }
    
    func isIn(sequence: any Sequence) -> Bool {
        let range = sequence.range
        let genericRange = Self(uncheckedBounds: (lower: Bound(exactly: range.lowerBound)!,
                                                  upper: Bound(exactly: range.upperBound)!))
        return self.isIn(genericRange)
    }
    
}

public extension Range where Bound : Strideable, Bound.Stride : SignedInteger {
    
    var flattened: [Bound] {
        return self.makeIterator().map { $0 }
    }
    
}

public extension ClosedRange where Bound : Numeric & Strideable {
    
    var open: Range<Bound> {
        return self.lowerBound ..< (self.upperBound + 1)
    }
    
    func isIn(_ closedRange: Self) -> Bool {
        return closedRange.contains(self.lowerBound) && closedRange.contains(self.upperBound)
    }
    
    func isIn(range: Range<Bound>) -> Bool {
        return range.contains(self.lowerBound) && range.contains(self.upperBound)
    }
    
    func isIn(collection: any Collection) -> Bool {
        let range = collection.range.closed
        let genericRange = Self(uncheckedBounds: (lower: Bound(exactly: range.lowerBound)!,
                                                  upper: Bound(exactly: range.upperBound)!))
        return self.isIn(genericRange)
    }
    
    func isIn(sequence: any Sequence) -> Bool {
        let range = sequence.range.closed
        let genericRange = Self(uncheckedBounds: (lower: Bound(exactly: range.lowerBound)!,
                                                  upper: Bound(exactly: range.upperBound)!))
        return self.isIn(genericRange)
    }
    
}

public extension ClosedRange where Bound : Strideable, Bound.Stride : SignedInteger {
    
    var flattened: [Bound] {
        return self.makeIterator().map { $0 }
    }
    
}

precedencegroup ExponentPrecedenceGroup {
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
    associativity: left
}

infix operator ** : ExponentPrecedenceGroup
infix operator **= : AssignmentPrecedence

public extension Double {
    
    static func ** (base: Self, exponent: Self) -> Self {
        return pow(base, exponent)
    }
    
    static func **= (base: inout Self, exponent: Self) {
        base = base ** exponent
    }
    
    func rounded(to decimalPlaces: Int) -> Self {
        return Double(String(format: "%.\(decimalPlaces)f", self))!
    }
    
}

public extension BinaryInteger {
    
    var doubleValue: Double {
        return Double(exactly: self)!
    }
    
    static func ** (base: Self, exponent: Self) -> Self {
        let integer = Int(pow(base.doubleValue, base.doubleValue))
        return Self(integer)
    }
    
    static func **= (base: inout Self, exponent: Self) {
        base = base ** exponent
    }
    
    static func ** (base: Self, exponent: Double) -> Double {
        return pow(base.doubleValue, exponent)
    }
    
    static func **= (base: inout Self, exponent: Double) {
        let result = Int(base ** exponent)
        base = Self(result)
    }
    
}

public extension NSNumber {
    
    /// An exact integer value of the `NSNumber` object.
    var intValue: Int? {
        return Int(exactly: self)
    }
    
    /// An exact boolean value of the `NSNumber` object.
    var boolValue: Bool? {
        return Bool(exactly: self)
    }
    
    /// An exact double value of the `NSNumber` object.
    var doubleValue: Double? {
        return Double(exactly: self)
    }
    
}

public extension Sequence where Element : Numeric {
    
    func sum() -> Element {
        let sum = self.reduce(0) { $0 + $1 }
        return sum
    }
    
}

public extension Sequence where Element : Numeric & Comparable {
    
    func mode() -> Element? {
        return self.max()
    }
    
}

public extension Sequence where Element : BinaryInteger {
    
    func mean() -> Double? {
        guard !self.isEmpty else {
            return nil
        }
        let sum = self.sum()
        let mean = sum.doubleValue / self.count.doubleValue
        return mean
    }
    
    func median() -> Double? {
        guard !self.isEmpty else {
            return nil
        }
        let sorted = Array(self).sorted { $0 < $1 }
        let half = self.count / 2
        if self.count % 2 == 1 {
            return sorted[half].doubleValue
        }
        return sorted[(half - 1)...half].mean()
    }
    
    func variance() -> Double? {
        return self.map({ $0.doubleValue }).standardDeviation()
    }
    
    func standardDeviation() -> Double? {
        guard !self.isEmpty else {
            return nil
        }
        let variance = self.variance()!
        return sqrt(variance)
    }
    
}

public extension Sequence where Element : FloatingPoint {
    
    func mean() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        let sum = self.sum()
        let mean = sum / (Double(self.count) as! Element)
        return mean
    }
    
    func median() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        let sorted = Array(self).sorted { $0 < $1 }
        let half = self.count / 2
        if self.count % 2 == 1 {
            return sorted[half]
        }
        return sorted[(half - 1)...half].mean()
    }
    
    func variance() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        let mean = self.mean()!
        let differenceSum = self.reduce(Element(0)) { $0 + ($1 - mean) * ($1 - mean) }
        let variance = differenceSum / Element(self.count - 1)
        return variance
    }
    
    func standardDeviation() -> Element? {
        guard !self.isEmpty else {
            return nil
        }
        let variance = self.variance()!
        return sqrt(variance)
    }
    
}
