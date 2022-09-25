import Cocoa

@objc public protocol Introspective : AnyObject {
    
    @objc optional var evade: [String] { get set }
    
}

extension Introspective {
    
    private var defaultEvade: [String] {
        get {
            return ["propertyNames", "properties", "evade"]
        }
    }
    
    public var propertyNames: [String] {
        get {
            let evade = self.defaultEvade + (self.evade ?? [])
            let mirror = Mirror(reflecting: self)
            return mirror.children.compactMap { !evade.contains($0.label ?? "") ? $0.label : nil }
        }
    }
    
    public var properties: [String : Any] {
        get {
            var dictionary: [String : Any] = [:]
            for name in self.propertyNames {
                dictionary[name] = self[name]
            }
            return dictionary
        }
    }
    
    public subscript(label: String) -> Any? {
        get {
            let mirror = Mirror(reflecting: self)
            return mirror.children.first(where: { $0.label == label })?.value
        }
        set {
            if let object = self as? NSObject {
                object.setValue(newValue, forKey: label)
            }
        }
    }
    
}
