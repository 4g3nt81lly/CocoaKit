import Cocoa

/**
 An object used for convenient data exchange between objects at a global scope.
 
 This object stores and manages globally-accessible variables and dynamic functions.
 
 Analogous to `NotificationCenter`, the target object by which a function is registered is the "observer," except that it does not literally observe and implement a method of its own to handle the notification: it passes a callable handler as a `DynamicFunction` object to this `Global` object, yielding the initiative to whoever is entitled to "send the notification." The mere role of the target object is to provide a handler and reference to itself, if necessary.
 
 Dynamic functions are structs that wrap actionable closures, which are capable of capturing references and accessible when these references are retained.
 
 - Note: No more than one unique instance of this object should be created.
 
 For dynamic functions that capture **strong** references to objects, be sure to deregister them when they are no longer needed, otherwise those references will be retained and potentially prevent other objects from deallocating.
 
 For dynamic functions that capture **weak** or **unowned** references to objects, you are entailed to keep track of their lifecycles and make sure that they are valid upon access, otherwise manually perform validation to prevent crash if necessary.
 
 If actions of a handler involve updating UI, make sure you call it from the main thread.
 */
@dynamicMemberLookup
public final class Global {
    
    public typealias KeyName = String
    
    ///  Registered functions.
    public private(set) var store: [KeyName : any Returnable] = [:]
    
    public subscript(dynamicMember name: KeyName) -> (any Returnable)? {
        return self.store[name]
    }
    
    public subscript(name: String) -> (any Returnable)? {
        get {
            return self.store[name]
        }
        set {
            if let newBody = newValue {
                self.store[name] = newBody
            }
        }
    }
    
    public init() {}
    
    public func set(_ value: Any?, forKey key: KeyName) {
        guard !self.store.keys.contains(key) else { return }
        let variable = Variable(name: key, value: value)
        self.store[key] = variable
    }
    
    public func value<T>(forKey key: KeyName, ofType type: T.Type = Any.Type) -> T? {
        return self.store[key]?() as? T
    }
    
    public func removeValue(forKey key: KeyName) -> Any? {
        guard let _ = self[key] else {
            return nil
        }
        return self.store.removeValue(forKey: key)
    }
    
    /**
     Registers a globally-accessible function.
     
     - Parameters:
        - name: The name of the function.
        - target: The target object by which the function is registered.
        - function: The function body as a closure.
     */
    public func registerFunction(withName name: KeyName, target: AnyObject? = nil, _ function: @escaping AnyFunction) {
        guard !self.store.keys.contains(name) else { return }
        let dynamicFunction = DynamicFunction(name: name, body: function, target: target)
        self.store[name] = dynamicFunction
    }
    
    /**
     Deregisters a function by name.
     
     - Parameter name: The name of the function to be deregistered.
     */
    public func deregisterFunction(ofName name: KeyName) {
        self.store.removeValue(forKey: name)
    }
    
    /**
     Deregisters all functions with a given target by which these functions are registered.
     
     - Parameter target: The common target object of the functions to be deregistered.
     */
    public func deregisterAll(forTarget target: AnyObject?) {
        for (key, value) in self.store {
            guard let function = value as? DynamicFunction else {
                continue
            }
            if function.target === target {
                self.store.removeValue(forKey: key)
            }
        }
    }
    
}
