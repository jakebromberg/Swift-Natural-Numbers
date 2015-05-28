//
//  Natural Numbers.swift
//  Swift Playground
//
//  Created by Jake Bromberg on 5/25/15.
//  Copyright (c) 2015 Flat Cap. All rights reserved.
//

import Foundation
import Swift

class Box<T> {
	let unbox : T
	init(_ value : T) { unbox = value }
}

enum Natural {
	case Zero
	case Successor( Box<Natural> )
}

extension Natural : Printable {
	func toInt() -> Int {
		switch (self) {
		case .Zero: return 0
		case let .Successor(predOfSelf): return 1 + predOfSelf.unbox.toInt()
		}
	}
	
	var description : String {
		get {
			return "\(self.toInt())"
		}
	}
}

extension Natural : DebugPrintable {
	var debugDescription : String {
		get {
			return self.description
		}
	}
}

func ==(a : Natural, b : Natural) -> Bool {
	switch (a, b) {
	case (.Zero, .Zero): return true
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox == predOfB.unbox
	default: return false
	}
}

let One : Natural = .Successor(Box(.Zero))
let Two : Natural = .Successor(Box(One))

assert(Natural.Zero == Natural.Zero, "Natural.Zero == Natural.Zero")
assert(One == One, "One == One")

extension Natural : Equatable {
}

assert(One != Two, "One != Two")

func +(a : Natural, b : Natural) -> Natural {
	switch (a, b) {
	case (_, .Zero): return a
	case (.Zero, _): return b
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox + .Successor(Box(b))
	default: return .Zero
	}
}

assert(Natural.Zero + One == One, "Natural.Zero + One == One")
assert(One + One == Two, "One + One == Two")

func -(a : Natural, b : Natural) -> Natural {
	switch (a, b) {
	case let (_, .Zero): return a
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox - predOfB.unbox
	default: println("EXIT_FAILURE"); exit(EXIT_FAILURE);
	}
}

assert(.Zero - .Zero == .Zero, "(.Zero - .Zero) == .Zero")
assert((Two - One) == One, "(Two - One) == One")

func <(a : Natural, b : Natural) -> Bool {
	switch (a, b) {
	case (.Zero, .Zero): return false
	case (.Zero, _): return true
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox < predOfB.unbox
	default: return false
	}
}

assert(One < Two, "One < Two")

func min(a : Natural, b : Natural) -> Natural {
	return a < b ? a : b
}

assert(min(Two, One) == One, "min(Two, One) == One")
assert(min(One, Two) == One, "min(One, Two) == One")

func max(a : Natural, b : Natural) -> Natural {
	return min(a, b) == a ? b : a
}

assert(max(One, Two) == Two, "max(One, Two) == Two")

func isCommunicative<T : Equatable>(a : T, b : T, op : (T, T) -> T) -> Bool {
	return op(a, b) == op(b, a)
}

assert(isCommunicative(.Zero, One, min), "operationIsCommunicative(.Zero, One, min)")

func <=(a : Natural, b : Natural) -> Bool {
	return a == b || a < b
}

assert(Natural.Zero <= .Zero, "Natural.Zero <= .Zero")
assert(One <= Two, "One < Two")

func >(a : Natural, b : Natural) -> Bool {
	return b < a
}

assert(Two > One, "Two > One")

func *(a : Natural, b : Natural) -> Natural {
	switch (a, b) {
	case (.Zero, _): return .Zero
	case (_, .Zero): return .Zero
	case let (a, .Successor(predB)): return a + a * predB.unbox
	}
}

let Three : Natural = .Successor(Box(Two))
let Four : Natural = .Successor(Box(Three))

assert(.Zero * .Zero == .Zero, ".Zero * .Zero == .Zero")
assert(.Zero * Two == .Zero, ".Zero * Two == .Zero")
assert(Two * Two == Four, "Two * Two == Four")

func /(a : Natural, b : Natural) -> Natural {
	if (a < b) {
		return .Zero
	} else {
		return One + (a - b) / b
	}
}

assert(Four / Two == Two, "")

struct Integer {
	let a : Natural
	let b : Natural
}

extension Integer {
	init(_ natural : Natural) {
		a = natural
		b = .Zero
	}
}

func ==(a : Integer, b : Integer) -> Bool {
	return a.a + b.b == a.b + b.a
}

assert(Integer(One) == Integer(One), "Integer(One) == Integer(One)")

extension Integer : Equatable {
}

assert(Integer(Two) != Integer(One), "Integer(Two) != Integer(One)")

func +(a : Integer, b : Integer) -> Integer {
	return Integer(a: a.a + b.a, b: a.b + b.b)
}

assert(Integer(Two) == Integer(One) + Integer(One), "Integer(Two) == Integer(One) + Integer(One)")

prefix func -(a : Natural) -> Integer {
	return Integer(a: .Zero, b: a)
}

assert(-One + -One == -Two, "-One + -One == -Two")

prefix func -(a : Integer) -> Integer {
	return Integer(a: a.b, b: a.a)
}

assert(-Integer(One) + -Integer(One) == -Integer(Two), "-One + -One == -Two")

func -(a : Integer, b : Integer) -> Integer {
	return a + -b
}

assert(-One == -Integer(One), "-One == -Integer(One)")
assert(-(-One) == Integer(One), "-(-One) == Integer(One)")
assert(-Natural.Zero == Integer(Natural.Zero), "-Natural.Zero == Integer(Natural.Zero)")
assert(-One == Integer(One) - Integer(Two), "-One == Integer(One) - Integer(Two)")

func -(a : Natural, b : Natural) -> Integer {
	return Integer(a: a, b: b)
}

assert(-One == One - Two, "-One == One - Two")
