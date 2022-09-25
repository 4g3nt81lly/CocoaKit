import Cocoa

public typealias SequenceSelector = [Bool]

public extension Sequence {
    
    var count: Int {
        return Array(self).count
    }
    
    var range: Range<Int> {
        return 0 ..< self.count
    }
    
    var isEmpty: Bool {
        return self.count == 0
    }
    
    subscript(_ boolArray: SequenceSelector) -> Self? {
        get {
            let array = Array(self)
            guard boolArray.count == array.count else {
                return nil
            }
            let selectedArray: [Element] = boolArray.enumerated().compactMap { (index, bool) in
                guard bool else {
                    return nil
                }
                return array[index]
            }
            return selectedArray as? Self
        }
        set {
            var array = Array(self)
            guard boolArray.count == array.count else {
                return
            }
            guard let newSequence = newValue else {
                let length = array.count
                for (index, bool) in boolArray.reversed().enumerated() {
                    if bool {
                        array.remove(at: length - index - 1)
                    }
                }
                self = array as! Self
                return
            }
            let newArray = Array(newSequence)
            guard newArray.count == array.count else {
                return
            }
            var counterIndex = 0
            for (index, bool) in boolArray.enumerated() {
                if bool {
                    array[index] = newArray[counterIndex]
                    counterIndex += 1
                }
            }
            self = array as! Self
        }
    }
    
    static func * (lhs: Self, rhs: Int) -> [Element] {
        guard rhs > 0 else {
            if rhs == 0 {
                return []
            }
            return lhs.map { $0 }
        }
        var newArray: [Element] = []
        for _ in 0 ..< rhs {
            newArray += lhs
        }
        return newArray
    }
    
    static func *= (lhs: inout Self, rhs: Int) {
        if let sequence = lhs * rhs as? Self {
            lhs = sequence
        }
    }
    
}

public extension Sequence where Element : Equatable {
    
    static func == (lhs: Self, rhs: Element) -> [Bool] {
        return lhs.map { $0 == rhs }
    }
    
}

public extension Sequence where Element : Numeric {
    
    static func * (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 * rhs }
    }
    
    static func *= (lhs: inout Self, rhs: Element) {
        lhs = lhs * rhs as! Self
    }
    
    static func + (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 + rhs }
    }
    
    static func += (lhs: inout Self, rhs: Element) {
        lhs = lhs + rhs as! Self
    }
    
    static func - (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 - rhs }
    }
    
    static func -= (lhs: inout Self, rhs: Element) {
        lhs = lhs - rhs as! Self
    }
    
}

public extension Sequence where Element : BinaryInteger {
    
    // MARK: Integer Operations
    
    static func / (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 / rhs }
    }
    
    static func /= (lhs: inout Self, rhs: Element) {
        if let result = (lhs / rhs) as? Self {
            lhs = result
        }
    }
    
    static func % (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 % rhs }
    }
    
    static func %= (lhs: inout Self, rhs: Element) {
        if let result = (lhs % rhs) as? Self {
            lhs = result
        }
    }
    
    static func & (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 & rhs }
    }
    
    static func &= (lhs: inout Self, rhs: Element) {
        if let result = (lhs & rhs) as? Self {
            lhs = result
        }
    }
    
    static func | (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 | rhs }
    }
    
    static func |= (lhs: inout Self, rhs: Element) {
        if let result = (lhs | rhs) as? Self {
            lhs = result
        }
    }
    
    static func ^ (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 ^ rhs }
    }
    
    static func ^= (lhs: inout Self, rhs: Element) {
        if let result = (lhs ^ rhs) as? Self {
            lhs = result
        }
    }
    
    static func << (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 << rhs }
    }
    
    static func <<= (lhs: inout Self, rhs: Element) {
        if let result = (lhs << rhs) as? Self {
            lhs = result
        }
    }
    
    static func >> (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 >> rhs }
    }
    
    static func >>= (lhs: inout Self, rhs: Element) {
        if let result = (lhs >> rhs) as? Self {
            lhs = result
        }
    }
    
    // MARK: Comparison
    
    static func <= (lhs: Self, rhs: Element) -> [Bool] {
        return lhs.map { $0 <= rhs }
    }
    
    static func >= (lhs: Self, rhs: Element) -> [Bool] {
        return lhs.map { $0 >= rhs }
    }
    
}

public extension Sequence where Element : FloatingPoint {
    
    static func / (lhs: Self, rhs: Element) -> [Element] {
        return lhs.map { $0 / rhs }
    }
    
    static func /= (lhs: inout Self, rhs: Element) {
        if let result = (lhs / rhs) as? Self {
            lhs = result
        }
    }
    
    static func <= (lhs: Self, rhs: Element) -> [Bool] {
        return lhs.map { $0 <= rhs }
    }
    
    static func >= (lhs: Self, rhs: Element) -> [Bool] {
        return lhs.map { $0 >= rhs }
    }
    
}

public extension Sequence where Element == Bool {
    
    var all: Bool {
        return !self.contains(false)
    }
    
    var any: Bool {
        return self.contains(true)
    }
    
}

public extension Array where Element : Equatable {
    
    func allEqual() -> Bool {
        guard !self.isEmpty else {
            return true
        }
        let first = self.first!
        for item in self[1...] {
            if item != first {
                return false
            }
        }
        return true
    }
    
}
