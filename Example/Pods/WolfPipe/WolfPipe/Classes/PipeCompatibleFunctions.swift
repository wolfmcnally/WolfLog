//
//  PipeCompatibleFunctions.swift
//  WolfPipe
//
//  Created by Wolf McNally on 09/05/2018.
//  Copyright © 2018 Wolf McNally.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// Curried version of `append`.
public func append<E, C>(_ e: E) -> (C) -> C where C: RangeReplaceableCollection, C.Element == E {
    return { c in
        var d = c
        d.append(e)
        return d
    }
}

/// Curried version of `filter`.
public func filter<E, C>(_ isIncluded: @escaping (E) -> Bool) -> (C) -> C where C: RangeReplaceableCollection, C.Element == E {
    return { $0.filter(isIncluded) }
}

/// Curried version of `filter`, taking a throwing closure.
public func filter<E, C>(_ isIncluded: @escaping (E) throws -> Bool) rethrows -> (C) throws -> C where C: RangeReplaceableCollection, C.Element == E {
    return { try $0.filter(isIncluded) }
}

/// Curried version of `sorted` for `Array` with `Comparable` elements.
public func sorted<E>(_ a: [E]) -> [E] where E: Comparable {
    return a.sorted()
}

/// Curried version of `sorted` for `Array`, taking a custom compare closure.
public func sorted<E>(_ by: @escaping (E, E) -> Bool) -> ([E]) -> [E] {
    return { $0.sorted(by: by) }
}

/// Curried version or `sorted` for `Array`, taking a custom throwing compare closure.
public func sorted<E>(_ by: @escaping (E, E) throws -> Bool) rethrows -> ([E]) throws -> [E] {
    return { try $0.sorted(by: by) }
}

/// Curried version of `map`.
public func map<S: Sequence, T>(_ transform: @escaping (S.Element) -> T) -> (S) -> [T] {
    return { $0.map(transform) }
}

/// Curried version of `map`, taking a throwing closure.
public func map<S: Sequence, T>(_ transform: @escaping (S.Element) throws -> T) rethrows -> (S) throws -> [T] {
    return { try $0.map(transform) }
}

/// Curried version of `reduce`
public func reduce<S: Sequence, T>(_ initialResult: T, _ nextPartialResult: @escaping (T, S.Element) -> T) -> (S) -> T {
    return { $0.reduce(initialResult, nextPartialResult) }
}

/// Curried version of `reduce`, taking a throwing closure
public func reduce<S: Sequence, T>(_ initialResult: T, _ nextPartialResult: @escaping (T, S.Element) throws -> T) rethrows -> (S) throws -> T {
    return { try $0.reduce(initialResult, nextPartialResult) }
}
