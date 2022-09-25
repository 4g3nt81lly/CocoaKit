import Cocoa

public class CKMatrix: Sequence, IteratorProtocol, ExpressibleByArrayLiteral, ExpressibleByFloatLiteral, CustomStringConvertible {
    
    internal var value: Double?
    
    internal var sequence: [Element] = []
    
    public var isLeaf: Bool {
        return self.sequence.isEmpty && self.value != nil
    }
    
    public var length: Int {
        guard !self.isLeaf else {
            return 0
        }
        return self.sequence.count
    }
    
    public typealias Dimension = Array<Int>
    
    // MARK: ExpressibleByArrayLiteral Protocol Stubs
    
    public typealias ArrayLiteralElement = Element
    
    public required init(arrayLiteral elements: Element...) {
        self.sequence = elements
    }
    
    // MARK: ExpressibleByFloatLiteral Protocol Stubs
    
    public typealias FloatLiteralType = Double
    
    public required init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }
    
    // MARK: Sequence & Iterator Protocol Stubs
    
    public typealias Element = CKMatrix
    
    private var counter = 0
    
    public func next() -> Element? {
        guard !self.isLeaf, self.counter < self.length else {
            return nil
        }
        let element = self.sequence[self.counter]
        self.counter += 1
        return element
    }
    
    public func makeIterator() -> CKMatrix {
        return CKMatrix(sequence: self.sequence)
    }
    
    public var description: String {
        if self.isLeaf {
            return self.value!.description
        }
        return self.sequence.description
    }
    
    // MARK: Matrix Operation
    
    public static func + (lhs: CKMatrix, rhs: Double) -> CKMatrix {
        if lhs.isLeaf {
            return CKMatrix(value: lhs.value! + rhs)
        }
        var array: [Element] = []
        for arr in lhs {
            array.append(arr + rhs)
        }
        return CKMatrix(sequence: array)
    }
    
    public static func += (lhs: inout CKMatrix, rhs: Double) {
        lhs = lhs + rhs
    }
    
    public static func - (lhs: CKMatrix, rhs: Double) -> CKMatrix {
        if lhs.isLeaf {
            return CKMatrix(value: lhs.value! - rhs)
        }
        var array: [Element] = []
        for arr in lhs {
            array.append(arr - rhs)
        }
        return CKMatrix(sequence: array)
    }
    
    public static func -= (lhs: inout CKMatrix, rhs: Double) {
        lhs = lhs - rhs
    }
    
    public static func * (lhs: CKMatrix, rhs: Double) -> CKMatrix {
        if lhs.isLeaf {
            return CKMatrix(value: lhs.value! * rhs)
        }
        var array: [Element] = []
        for arr in lhs {
            array.append(arr * rhs)
        }
        return CKMatrix(sequence: array)
    }
    
    public static func *= (lhs: inout CKMatrix, rhs: Double) {
        lhs = lhs * rhs
    }
    
    public static func / (lhs: CKMatrix, rhs: Double) -> CKMatrix {
        if lhs.isLeaf {
            return CKMatrix(value: lhs.value! / rhs)
        }
        var array: [Element] = []
        for arr in lhs {
            array.append(arr / rhs)
        }
        return CKMatrix(sequence: array)
    }
    
    public static func /= (lhs: inout CKMatrix, rhs: Double) {
        lhs = lhs / rhs
    }
    
    internal init(value: Double) {
        self.value = value
    }
    
    internal init(sequence: [Element] = [], value: Double? = nil) {
        self.value = value
        self.sequence = sequence
    }
    
    internal convenience init(_ matrix: CKMatrix) {
        self.init(sequence: matrix.sequence)
    }
    
}
