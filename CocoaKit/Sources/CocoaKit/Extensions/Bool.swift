import Cocoa

extension Bool : Numeric, ExpressibleByFloatLiteral {
    
    public typealias IntegerLiteralType = Int
    
    public typealias FloatLiteralType = Double
    
    public typealias Magnitude = UInt8
    
    public var magnitude: UInt8 {
        return self ? 1 : 0
    }
    
    public var readable: String {
        return self ? "Yes" : "No"
    }
    
    public init(integerLiteral value: Int) {
        self.init(exactly: value)
    }
    
    public init<T: BinaryInteger>(exactly source: T) {
        self = source != 0
    }
    
    public init<T: BinaryFloatingPoint>(float value: T) {
        self = abs(value) > 0.5
    }
    
    public init(floatLiteral value: Double) {
        self.init(float: value)
    }
    
    public init?<T: Numeric>(numeric: T) {
        if let integer = numeric as? (any BinaryInteger) {
            self.init(exactly: integer)
        } else if let floating = numeric as? (any BinaryFloatingPoint) {
            self.init(float: floating)
        } else {
            return nil
        }
    }
    
    // MARK: Arithmetic Operations
    
    public static func + <RHS: Numeric>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let sum = lhs.magnitude + boolean.magnitude
            return RHS(exactly: sum)!
        }
        let sum = RHS(exactly: lhs.magnitude)! + rhs
        return sum
    }
    
    public static func += <RHS: Numeric>(lhs: inout Self, rhs: RHS) {
        if let sum = Self(numeric: lhs + rhs) {
            lhs = sum
        } else {
            fatalError("Result of '+=' is of neither a binary integer type nor a binary floating point type.")
        }
    }
    
    public static func += <RHS: BinaryFloatingPoint>(lhs: inout Self, rhs: RHS) {
        lhs = Self(float: lhs + rhs)
    }
    
    public static func - <RHS: Numeric>(lhs: Self, rhs: RHS) -> RHS {
        let difference = RHS(exactly: lhs.magnitude)! - rhs
        return difference
    }
    
    public static func -= <RHS: Numeric>(lhs: inout Self, rhs: RHS) {
        if let difference = Self(numeric: lhs - rhs) {
            lhs = difference
        } else {
            fatalError("Result of '-=' is of neither a binary integer type nor a binary floating point type.")
        }
    }
    
    public static func * <RHS: Numeric>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let product = lhs.magnitude * boolean.magnitude
            return RHS(exactly: product)!
        }
        let product = RHS(exactly: lhs.magnitude)! * rhs
        return product
    }
    
    public static func *= <RHS: Numeric>(lhs: inout Self, rhs: RHS) {
        if let product = Self(numeric: lhs * rhs) {
            lhs = product
        } else {
            fatalError("Result of '*=' is of neither a binary integer type nor a binary floating point type.")
        }
    }
    
    public static func / <RHS: Numeric>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            guard boolean else {
                return RHS(exactly: 0)!
            }
            let quotient = lhs.magnitude / boolean.magnitude
            return RHS(exactly: quotient)!
        } else if let integer = rhs as? (any BinaryInteger) {
            return Self.divideByInteger(lhs: lhs, rhs: integer) as! RHS
        } else if let float = rhs as? (any BinaryFloatingPoint) {
            return Self.divideByFloat(lhs: lhs, rhs: float) as! RHS
        } else {
            fatalError("Operand of '/' is of neither a binary integer type nor a binary floating point type.")
        }
    }
    
    private static func divideByInteger<RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let quotient = lhs.magnitude / boolean.magnitude
            return RHS(exactly: quotient)!
        }
        let quotient = RHS(exactly: lhs.magnitude)! / rhs
        return quotient
    }
    
    private static func divideByFloat<RHS: BinaryFloatingPoint>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let quotient = lhs.magnitude / boolean.magnitude
            return RHS(exactly: quotient)!
        }
        let quotient = RHS(exactly: lhs.magnitude)! / rhs
        return quotient
    }
    
    public static func /= <RHS: Numeric>(lhs: inout Self, rhs: RHS) {
        if let result = Bool(numeric: lhs / rhs) {
            lhs = result
        } else {
            fatalError("Result of '/=' is of neither a binary integer type nor a binary floating point type.")
        }
    }
    
    public static func % <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        let remainder = RHS(exactly: lhs.magnitude)! % rhs
        return remainder
    }
    
    public static func %= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
        lhs = Self(exactly: lhs % rhs)
    }
    
    // MARK: Bitwise Operations
    
    public static prefix func ~ (x: Self) -> Self {
        return !x
    }
    
    public static func & <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let bitwiseAND = lhs.magnitude & boolean.magnitude
            return RHS(exactly: bitwiseAND)!
        }
        let bitwiseAND = RHS(exactly: lhs.magnitude)! & rhs
        return bitwiseAND
    }
    
    public static func &= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
        lhs = Self(exactly: lhs & rhs)
    }
    
    public static func | <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let bitwiseOR = lhs.magnitude | boolean.magnitude
            return RHS(exactly: bitwiseOR)!
        }
        let bitwiseOR = RHS(exactly: lhs.magnitude)! | rhs
        return bitwiseOR
    }
    
    public static func |= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
        lhs = Self(exactly: lhs | rhs)
    }
    
    public static func ^ <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let bitwiseXOR = lhs.magnitude ^ boolean.magnitude
            return RHS(exactly: bitwiseXOR)!
        }
        let bitwiseXOR = RHS(exactly: lhs.magnitude)! ^ rhs
        return bitwiseXOR
    }
    
    public static func ^= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
        lhs = Self(exactly: lhs ^ rhs)
    }
    
    public static func << <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let bitwiseleftShift = lhs.magnitude << boolean.magnitude
            return RHS(exactly: bitwiseleftShift)!
        }
        let bitwiseleftShift = RHS(exactly: lhs.magnitude)! << rhs
        return bitwiseleftShift
    }
    
    public static func <<= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
        lhs = Self(exactly: lhs << rhs)
    }
    
    public static func >> <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> RHS {
        if let boolean = rhs as? Self {
            let bitwiseRightShift = lhs.magnitude >> boolean.magnitude
            return RHS(exactly: bitwiseRightShift)!
        }
        let bitwiseRightShift = RHS(exactly: lhs.magnitude)! >> rhs
        return bitwiseRightShift
    }
    
    public static func >>= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
        lhs = Self(exactly: lhs >> rhs)
    }
    
}

// MARK: General Numeric Types Extension

public extension Numeric {
    
    static func + (lhs: Self, rhs: Bool) -> Self {
        return rhs + lhs
    }
    
    static func += (lhs: inout Self, rhs: Bool) {
        lhs = lhs + rhs
    }
    
    static func - (lhs: Self, rhs: Bool) -> Self {
        if let boolean = lhs as? Bool {
            return Self(exactly: Int8(boolean.magnitude) - Int8(rhs.magnitude))!
        }
        return Self(exactly: -Int8(rhs.magnitude))! + lhs
    }
    
    static func -= (lhs: inout Self, rhs: Bool) {
        lhs = lhs - rhs
    }
    
    static func * (lhs: Self, rhs: Bool) -> Self {
        return rhs * lhs
    }
    
    static func *= (lhs: inout Self, rhs: Bool) {
        lhs = lhs * rhs
    }
    
}

// MARK: Binary Integer Extension

public extension BinaryInteger {
    
    static func / (lhs: Self, rhs: Bool) -> Self {
        return lhs / Self(exactly: rhs.magnitude)!
    }
    
    static func /= (lhs: inout Self, rhs: Bool) {
        lhs = lhs / rhs
    }
    
    static func % (lhs: Self, rhs: Bool) -> Self {
        return lhs % Self(exactly: rhs.magnitude)!
    }
    
    static func %= (lhs: inout Self, rhs: Bool) {
        lhs = lhs % rhs
    }
    
    static func & (lhs: Self, rhs: Bool) -> Self {
        return lhs & Self(exactly: rhs.magnitude)!
    }
    
    static func &= (lhs: inout Self, rhs: Bool) {
        lhs = lhs & rhs
    }
    
    static func | (lhs: Self, rhs: Bool) -> Self {
        return lhs | Self(exactly: rhs.magnitude)!
    }
    
    static func |= (lhs: inout Self, rhs: Bool) {
        lhs = lhs | rhs
    }
    
    static func ^ (lhs: Self, rhs: Bool) -> Self {
        return lhs ^ Self(exactly: rhs.magnitude)!
    }
    
    static func ^= (lhs: inout Self, rhs: Bool) {
        lhs = lhs ^ rhs
    }
    
    static func << (lhs: Self, rhs: Bool) -> Self {
        return lhs << Self(exactly: rhs.magnitude)!
    }
    
    static func <<= (lhs: inout Self, rhs: Bool) {
        lhs = lhs << rhs
    }
    
    static func >> (lhs: Self, rhs: Bool) -> Self {
        return lhs >> Self(exactly: rhs.magnitude)!
    }
    
    static func >>= (lhs: inout Self, rhs: Bool) {
        lhs = lhs >> rhs
    }
    
}

// MARK: Binary Floating Point Extension

public extension BinaryFloatingPoint {
    
    static func / (lhs: Self, rhs: Bool) -> Self {
        return lhs / Self(exactly: rhs.magnitude)!
    }
    
    static func /= (lhs: inout Self, rhs: Bool) {
        lhs = lhs / rhs
    }
    
}
