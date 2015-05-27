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

let One : Natural = .Successor(Box(.Zero))
let Two : Natural = .Successor(Box(One))

func +(a : Natural, b : Natural) -> Natural {
	switch (a, b) {
	case (_, .Zero): return a
	case (.Zero, _): return b
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox + .Successor(Box(b))
	default: return .Zero
	}
}

func -(a : Natural, b : Natural) -> Natural {
	switch (a, b) {
	case let (_, .Zero): return a
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox - predOfB.unbox
	default: println("EXIT_FAILURE"); exit(EXIT_FAILURE);
	}
}

extension Natural : Equatable {
}

func ==(a : Natural, b : Natural) -> Bool {
	switch (a, b) {
	case (.Zero, .Zero): return true
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox == predOfB.unbox
	default: return false
	}
}

func min(a : Natural, b : Natural) -> Natural {
	switch (a, b) {
	case (.Zero, _): return b
	case (_, .Zero): return a
	case let (.Successor(predOfA), .Successor(predOfB)): return min(predOfA.unbox, predOfB.unbox)
	default: return a
	}
}

assert(min(One, Two) == One, "min(One, Two) == One")

func <(a : Natural, b : Natural) -> Bool {
	return min(a, b) == a
}

func <=(a : Natural, b : Natural) -> Bool {
	return a == b || a < b
}

func >(a : Natural, b : Natural) -> Bool {
	return b < a
}

assert(Natural.Zero + One == One, "Natural.Zero + One == One")
assert(One != Two, "One != Two")
assert(One + One == Two, "One + One == Two")
assert(One < Two, "One < Two")
assert(Two > One, "Two > One")

assert(Natural.Zero <= .Zero, "Natural.Zero <= .Zero")
assert((Two - One) == One, "(Two - One) == One")
assert((.Zero - .Zero) == .Zero, "(.Zero - .Zero) == .Zero")

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

func +(a : Integer, b : Integer) -> Integer {
	return Integer(a: a.a + b.a, b: a.b + b.b)
}

prefix func -(a : Integer) -> Integer {
	return Integer(a: a.b, b: a.a)
}

func -(a : Integer, b : Integer) -> Integer {
	return a + -b
}

prefix func -(a : Natural) -> Integer {
	return Integer(a: .Zero, b: a)
}

func -(a : Natural, b : Natural) -> Integer {
	return Integer(a: a, b: b)
}

func ==(a : Integer, b : Integer) -> Bool {
	return a.a + b.b == a.b + b.a
}

assert(Integer(Two) == Integer(One) + Integer(One), "Integer(Two) == Integer(One) + Integer(One)")
assert(-(-One) == Integer(One), "-(-One) == Integer(One)")
assert(-One == Integer(One) - Integer(Two), "-One == Integer(One) - Integer(Two)")
assert(-One == (One - Two), "-One == (One - Two)")
assert(-Natural.Zero == Integer(Natural.Zero), "-Natural.Zero == Integer(Natural.Zero)")


assert(-One + -One == -Two, "-One + -One == -Two")
