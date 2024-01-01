//
//  Collections.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 13/12/21.
//
//MARK: - COMPLETO
import Foundation

public class ConcurrentInitializableDictionary<T> : Collection
{
    public var initialized : Bool = false
    private var _dictionary : Dictionary<UUID, T> = Dictionary<UUID, T>()
    private var _lockObject = NSRecursiveLock()
    
    public typealias Index = Dictionary<UUID, T>.Index
    public typealias Element = Dictionary<UUID, T>.Element
    
    public func cloneDictionary() -> [(UUID, T)]
    {
        _lockObject.lock()
        let clone = _dictionary.map { $0 }
        _lockObject.unlock()
        return clone
    }
    
    public var startIndex: Index
    {
        _lockObject.lock()
        let index = _dictionary.startIndex
        _lockObject.unlock()
        return index
    }
    public var endIndex: Index
    {
        _lockObject.lock()
        let index = _dictionary.endIndex
        _lockObject.unlock()
        return index
    }
    
    public subscript(index: Index) -> Element
    {
        get
        {
            _lockObject.lock()
            let value = _dictionary[index]
            _lockObject.unlock()
            return value
        }
    }
    
    public func index(after i: Index) -> Index
    {
        _lockObject.lock()
        let value = _dictionary.index(after: i)
        _lockObject.unlock()
        return value
    }

    public func count() -> Int
    {
        _lockObject.lock()
        let value = _dictionary.count
        _lockObject.unlock()
        return value
    }

    public func get(_ key: UUID) -> T?
    {
        _lockObject.lock()
        let value = _dictionary[key]
        _lockObject.unlock()
        return value
    }

    
    func ForEach(_ function: (T) -> Void)
    {
        _lockObject.lock()
        
        var currentIndex = _dictionary.startIndex
        while currentIndex < _dictionary.endIndex {
            function(_dictionary[currentIndex].value)
            currentIndex = _dictionary.index(after: currentIndex)
        }
        
        _lockObject.unlock()
    }
    
    public func put(_ uuid : UUID, _ value: T)
    {
        _lockObject.lock()
        if (_dictionary.keys.contains(uuid))
        {
            _dictionary.removeValue(forKey: uuid)
        }
        _dictionary[uuid] = value
        _lockObject.unlock()
    }
    
    public func remove(_ uuid : UUID)
    {
        _lockObject.lock()
        _dictionary.removeValue(forKey: uuid)
        _lockObject.unlock()
    }
    
    public func containsKey(_ uuid : UUID) -> Bool
    {
        _lockObject.lock()
        let result = _dictionary.keys.contains(uuid)
        _lockObject.unlock()
        return result
    }
    
    public func keys() -> [UUID]
    {
        _lockObject.lock()
        let keys = _dictionary.map { (key, value) in return key }
        _lockObject.unlock()
        return keys
    }

    public func values() -> [T]
    {
        _lockObject.lock()
        let values = _dictionary.map { (key, value) in return value }
        _lockObject.unlock()
        return values
    }
    
    public func clear()
    {
        _lockObject.lock()
        _dictionary.removeAll()
        _lockObject.unlock()
    }
    
    subscript(key: UUID) -> T
    {
        _lockObject.lock()
        let value = _dictionary[key]!
        _lockObject.unlock()
        return value
    }
    
}

public class ConcurrentContainer<K, V>
{
    private var _lockObject = NSRecursiveLock()

    public func Contains(_ key : K) -> Bool
    {
        var result : Bool
        
        _lockObject.lock()

        result = OnContains(key)

        _lockObject.unlock()
        
        return result
    }
    
    public func Create(_ key : K, _ data : V) -> K
    {
        var result : K
    
        _lockObject.lock()
        
        result = OnCreate(key, data)!

        _lockObject.unlock()
        
        return result
    }
    
    public func CreateFromFile(_ file : URL) -> K
    {
        var result : K
        
        _lockObject.lock()
        
        result = OnCreateFromFile(file)!

        _lockObject.unlock()
        
        return result
    }
    
    public func Update(_ key : K, _ data : V) -> Void
    {
        _lockObject.lock()
        
        OnUpdate(key, data)
        
        _lockObject.unlock()
    }
    
    public func Read(_ key : K) -> V
    {
        var result : V
        
        _lockObject.lock()
        
        result = OnRead(key)!
        
        _lockObject.unlock()
        
        return result
    }
    
    public func OnContains(_ key : K) -> Bool
    {
        return false
    }
    
    public func OnCreate(_ key : K, _ data : V) -> K?
    {
        return nil
    }
    
    public func OnCreateFromFile(_ file : URL) -> K?
    {
        return nil
    }
    
    public func OnUpdate(_ key : K, _ data : V) -> Void
    {
    }
    
    public func OnRead(_ key : K) -> V?
    {
        return nil
    }
}

public struct Queue<T>
{
    private var array = [T?]()
    
    public var isEmpty: Bool
    {
        return count == 0
    }
    
    public var count: Int
    {
        return array.count
    }
    
    public mutating func enqueue(_ element: T)
    {
        array.append(element)
    }
    
    public mutating func dequeue() -> T?
    {
        var element : T?
        if (array.count > 0)
        {
            element = array[0]!
            array.removeFirst(1)
        }
        
        return element
    }
    
    public mutating func remove() -> Void
    {
        _ = dequeue()
    }
    
    public mutating func clear() -> Void
    {
        array.removeAll()
    }
    
    public var peek: T?
    {
        if isEmpty {
            return nil
        } else {
            return array[0]
        }
    }
}
