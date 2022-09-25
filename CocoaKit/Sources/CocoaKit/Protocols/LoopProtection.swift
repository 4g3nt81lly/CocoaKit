import Cocoa

internal var loopProtected = false

public protocol LoopProtection {
    
}

public extension LoopProtection {
    
    private var protected: Bool {
        get {
            return loopProtected
        }
        nonmutating set {
            loopProtected = newValue
        }
    }
    
    func protected(_ observerBlock: () -> Void) {
        guard !self.protected else { return }
        observerBlock()
    }
    
    func safelySet(_ block: () -> Void) {
        self.protected = true
        block()
        self.protected = false
    }
    
}
