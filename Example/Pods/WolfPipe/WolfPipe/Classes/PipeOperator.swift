//
//  PipeOperator.swift
//  WolfPipe
//
//  Created by Wolf McNally on 09/05/2018.
//  Copyright © 2018 Wolf McNally.
//

import Foundation

infix operator |> : PipeForwardPrecedence

precedencegroup PipeForwardPrecedence {
    associativity: left
    higherThan: ComparisonPrecedence
    lowerThan: NilCoalescingPrecedence
}

public func |> <A, B>(lhs: A, rhs: (A) throws -> B) rethrows -> B {
    return try rhs(lhs)
}
