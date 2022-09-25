import Cocoa

public class CKArray<Element> : Sequence, IteratorProtocol, ExpressibleByArrayLiteral, CustomStringConvertible {
    
    public var array: [Element]
    
    public var count: Int {
        return self.array.count
    }
    
    public var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    public var description: String {
        return "\(self.array)"
    }
    
    public subscript(_ index: Int) -> Element? {
        get {
            let positiveIndex = index >= 0 ? index : self.count + index
            guard positiveIndex.isIn(sequence: self.array) else {
                return nil
            }
            return self.array[positiveIndex]
        }
        set {
            let positiveIndex = index >= 0 ? index : self.count + index
            guard positiveIndex.isIn(sequence: self.array) else {
                return
            }
            if let newElement = newValue {
                self.array[positiveIndex] = newElement
            } else {
                self.array.remove(at: positiveIndex)
            }
        }
    }
    
    public subscript<RangeType : RangeExpression>(_ range: RangeType) -> [Element]? where RangeType.Bound == Int {
        get {
            let array = self.array
            if let openRange = range as? Range<RangeType.Bound> {
                
                let newLowerBound = openRange.lowerBound + (openRange.lowerBound < 0 ? self.count : 0)
                let newUpperBound = openRange.upperBound + (openRange.upperBound < 0 ? self.count : 0)
                
                guard newLowerBound < newUpperBound else {
                    return nil
                }
                let positiveRange = newLowerBound ..< newUpperBound
                
                guard positiveRange.isIn(sequence: array) else {
                    return nil
                }
                return Array(array[positiveRange])
                
            } else if let closedRange = range as? ClosedRange<RangeType.Bound> {
                
                return self[closedRange.open]
                
            } else if let partialRangeFrom = range as? PartialRangeFrom<RangeType.Bound> {
                
                let positiveRange = (partialRangeFrom.lowerBound + (partialRangeFrom.lowerBound < 0 ? self.count : 0)) ..< self.count
                return self[positiveRange]
                
            } else if let partialRangeThrough = range as? PartialRangeThrough<RangeType.Bound> {
                
                let positiveRange = 0 ..< (partialRangeThrough.upperBound + (partialRangeThrough.upperBound < 0 ? self.count : 1))
                return self[positiveRange]
                
            } else if let partialRangeUpTo = range as? PartialRangeUpTo<RangeType.Bound> {
                
                return self[...(partialRangeUpTo.upperBound - 1)]
                
            } else {
                return nil
            }
        }
        set {
            let array = self.array
            if let openRange = range as? Range<RangeType.Bound> {
                
                let newLowerBound = openRange.lowerBound + (openRange.lowerBound < 0 ? self.count : 0)
                let newUpperBound = openRange.upperBound + (openRange.upperBound < 0 ? self.count : 0)
                
                guard newLowerBound < newUpperBound else {
                    return
                }
                let positiveRange = newLowerBound ..< newUpperBound
                
                guard positiveRange.isIn(sequence: array) else {
                    return
                }
                let leftPortion = Array(array[..<positiveRange.lowerBound])
                let rightPortion = Array(array[positiveRange.upperBound...])
                
                let newPortion = newValue ?? []
                self.array = leftPortion + (newPortion.isEmpty ? [] : newPortion) + rightPortion
                
            } else if let closedRange = range as? ClosedRange<RangeType.Bound> {
                
                self[closedRange.range] = newValue
                
            } else if let partialRangeFrom = range as? PartialRangeFrom<RangeType.Bound> {
                
                let positiveRange = (partialRangeFrom.lowerBound + (partialRangeFrom.lowerBound < 0 ? self.count : 0)) ..< self.count
                self[positiveRange] = newValue
                
            } else if let partialRangeThrough = range as? PartialRangeThrough<RangeType.Bound> {
                
                let positiveRange = 0 ..< (partialRangeThrough.upperBound + (partialRangeThrough.upperBound < 0 ? self.count : 1))
                self[positiveRange] = newValue
                
            } else if let partialRangeUpTo = range as? PartialRangeUpTo<RangeType.Bound> {
                
                self[...(partialRangeUpTo.upperBound - 1)] = newValue
                
            } else {
                return
            }
        }
    }
    
    public init(array: [Element] = []) {
        self.array = array
    }
    
    public init(sequence: any Sequence<Element>) {
        self.array = Array(sequence)
    }
    
    public convenience init(_ ckArray: CKArray) {
        self.init(array: ckArray.array)
    }
    
    // MARK: ExpressibleByArrayLiteral Protocol Stubs
    
    public typealias ArrayLiteralElement = Element
    
    required public init(arrayLiteral elements: Element...) {
        self.array = elements
    }
    
    // MARK: Sequence & Iterator Protocol Stubs
    
    private var counter = 0
    
    public func next() -> Element? {
        guard self.counter < self.count else {
            return nil
        }
        let element = self.array[self.counter]
        self.counter += 1
        return element
    }
    
    public func makeIterator() -> CKArray {
        return CKArray(self)
    }
    
}

public extension Sequence {
    
    var ckArray: CKArray<Element> {
        return CKArray(sequence: self)
    }
    
}
