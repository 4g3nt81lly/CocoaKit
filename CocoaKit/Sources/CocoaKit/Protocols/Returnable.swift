import Cocoa

@dynamicCallable
public protocol Callable {
    
    func dynamicallyCall(withKeywordArguments args: Arguments) -> Any?
    
}

public protocol Returnable : Callable {
    
    var name: String { get set }
    
}

// MARK: Variable

public struct Variable : Returnable {
    
    public var name: String
    
    public var value: Any?
    
    public func dynamicallyCall(withKeywordArguments args: Arguments) -> Any? {
        return self.value
    }
    
}

// MARK: Function

public typealias Arguments = KeyValuePairs<String, Any?>

public typealias AnyFunction = (Arguments) -> Any?

/// A dynamically callable wrapper class for closures.
public struct DynamicFunction : Returnable {
    
    /// Name of the dynamic function.
    public var name: String
    
    /// A function body.
    public var body: AnyFunction
    
    /// The target object by which the function is registered.
    public var target: AnyObject?
    
    /// Dynamically calls the containing closure with custom arguments.
    @discardableResult
    public func dynamicallyCall(withKeywordArguments args: Arguments = [:]) -> Any? {
        return self.body(args)
    }
    
}
