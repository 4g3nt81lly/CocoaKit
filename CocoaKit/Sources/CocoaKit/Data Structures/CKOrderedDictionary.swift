import Cocoa

/// An ordered collection of key-value pairs in the form of a dictionary.
public struct CKOrderedDictionary<Key: Hashable, Value> : ExpressibleByDictionaryLiteral, Sequence, IteratorProtocol {
    
    public typealias Element = (Key, Value?)
    
    /// An array of key-value pairs.
    private var orderedPairs: [Element]
    
    /// An array of the dictionary's keys.
    public var keys: [Key] {
        return self.orderedPairs.map { $0.0 }
    }
    
    /// An array of the dictionary's values.
    public var values: [Value?] {
        return self.orderedPairs.map { $0.1 }
    }
    
    public func reversed() -> [Element] {
        return self.orderedPairs.reversed()
    }
    
    public mutating func reverse() {
        self.orderedPairs.reverse()
    }
    
    /// A counter for the iterator.
    private var counter = 0
    
    public mutating func next() -> Element? {
        guard self.counter < self.orderedPairs.count else {
            return nil
        }
        let element = self.orderedPairs[self.counter]
        self.counter += 1
        return element
    }
    
    public func makeIterator() -> Self {
        return Self(keyValuePairs: self.orderedPairs)
    }
    
    subscript(key: Key, default: Key? = nil) -> Value? {
        get {
            return self.orderedPairs.first(where: { $0.0 == key })?.1 ?? self.orderedPairs.first(where: { $0.0 == `default` })?.1
        }
        set {
            if let index = self.orderedPairs.firstIndex(where: { $0.0 == key }) {
                self.orderedPairs[index].1 = newValue
            } else {
                self.orderedPairs += [(key, newValue)]
            }
        }
    }
    
    /**
     Sets a value by key.
     
     - Parameters:
        - key: The key by which the value is set.
        - value: The value to be set.
     */
    mutating func set(_ key: Key, value: Value) {
        self[key] = value
    }
    
    /**
     Removes a value by key.
     
     - Parameter key: The key of the value to be removed.
     */
    mutating func remove(byKey key: Key) {
        self.orderedPairs.removeAll(where: { $0.0 == key })
    }
    
    init(keyValuePairs pairs: [Element]) {
        self.orderedPairs = pairs
    }
    
    public init(dictionaryLiteral elements: Element...) {
        self.init(keyValuePairs: elements)
    }
    
}
