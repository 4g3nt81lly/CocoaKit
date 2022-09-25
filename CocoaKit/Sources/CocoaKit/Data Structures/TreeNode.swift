import Cocoa

public protocol TreeNode<Value> : AnyObject {
    
    associatedtype Value
    
    var value: Value { get set }
    
    var parent: Self? { get set }
    
    var children: [Self] { get set }
    
    var isLeaf: Bool { get }
    
    var childCount: Int { get }
    
    func addNode(_ value: Value, children: [Self])
    
    func addNode(_ node: Self)
    
    @discardableResult
    func removeChild(_ node: Self) -> Self?
    
    func removeNode()
    
    init(_ value: Value, parent: Self?, children: [Self])
    
}

public extension TreeNode {
    
    var isLeaf: Bool {
        return self.children.isEmpty
    }
    
    var childCount: Int {
        return self.children.count
    }
    
    subscript(_ index: Int) -> Self? {
        get {
            return self.children.ckArray[index]
        }
        set {
            var array = self.children.ckArray
            array[index] = newValue
            self.children = array.array
        }
    }
    
    func addNode(_ node: Self) {
        if self is (any BinaryTreeNode) {
            guard self.childCount <= 2 else {
                return
            }
        }
        self.children.append(node)
    }
    
    func addNode(_ value: Value, children: [Self] = []) {
        let node = Self(value, parent: self, children: children)
        self.addNode(node)
    }
    
    func removeChild(_ node: Self) -> Self? {
        if let child = self.children.first(where: { $0 === node }) {
            self.children.removeAll(where: { $0 === child })
            return node
        }
        return nil
    }
    
    func removeNode() {
        self.parent?.removeChild(self)
        self.parent = nil
    }
    
}

public protocol BinaryTreeNode<Value> : TreeNode {
    
    var left: Self? { get set }
    
    var right: Self? { get set }
    
}

public extension BinaryTreeNode {
    
    var children: [Self] {
        get {
            guard !self.isLeaf else {
                return []
            }
            return [self.left, self.right].compactMap({ $0 })
        }
        set {
            guard newValue.count == 2 else {
                return
            }
            self.left = newValue.first
            self.right = newValue.last
        }
    }
    
}

public protocol KeyValueNode<Key, Value> : TreeNode {
    
    associatedtype Key : Hashable
    
    var key: Key { get set }
    
}

public final class BinaryTree<Value> : BinaryTreeNode {
    
    public var value: Value
    
    public var left: BinaryTree<Value>? = nil
    
    public var right: BinaryTree? = nil
    
    public var parent: BinaryTree?
    
    public required init(_ value: Value, parent: BinaryTree? = nil, children: [BinaryTree] = []) {
        self.value = value
        self.parent = parent
        self.children = children
    }
    
}
