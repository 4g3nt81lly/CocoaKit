import Cocoa

@propertyWrapper
public struct UserDefault<Value : Codable> {
    
    private let container = UserDefaults.standard
    
    public let key: String
    
    public let defaultValue: Value?
    
    public var wrappedValue: Value? {
        get {
            guard let data = self.container.data(forKey: self.key) else {
                return self.defaultValue
            }
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? self.defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            self.container.set(data, forKey: self.key)
        }
    }
    
    public init(_ key: String, wrappedValue: Value? = nil) {
        self.key = key
        self.defaultValue = wrappedValue
        self.wrappedValue = wrappedValue
    }
    
}

@dynamicMemberLookup
public final class UserDefaultsManager {
    
    public var container = UserDefaults.standard
    
    public subscript(dynamicMember key: String) -> Any? {
        get {
            return self.container.value(forKey: key)
        }
        set {
            self.container.set(newValue, forKey: key)
        }
    }
    
    public func set(_ value: Any?, forKey key: String) {
        self.container.set(value, forKey: key)
    }
    
    public func value(forKey key: String) -> Any? {
        return self.container.value(forKey: key)
    }
    
    public func object(forKey key: String) -> Any? {
        return self.container.object(forKey: key)
    }
    
    public func string(forKey key: String) -> String? {
        return self.container.string(forKey: key)
    }
    
    public func integer(forKey key: String) -> Int {
        return (self.value(forKey: key) as? Int) ?? -1
    }
    
    public func float(forKey key: String) -> Float {
        return (self.value(forKey: key) as? Float) ?? -1.0
    }
    
    public func bool(forKey key: String) -> Bool {
        return self.container.bool(forKey: key)
    }
    
    public func array(forKey key: String) -> [Any]? {
        return self.container.array(forKey: key)
    }
    
    public func dictionary(forKey key: String) -> [String : Any]? {
        return self.container.dictionary(forKey: key)
    }
    
    public init(suiteName: String? = nil) {
        if let name = suiteName {
            self.container = UserDefaults(suiteName: name) ?? .standard
        }
    }
    
}
