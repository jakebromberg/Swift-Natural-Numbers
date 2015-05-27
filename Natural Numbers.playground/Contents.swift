//
//  Natural Numbers.swift
//  Swift Playground
//
//  Created by Jake Bromberg on 5/25/15.
//  Copyright (c) 2015 Flat Cap. All rights reserved.
//

import Foundation

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

func ==(a : Natural, b : Natural) -> Bool {
	return !(a < b || a > b)
}

func <(a : Natural, b : Natural) -> Bool {
	switch (a, b) {
	case (.Zero, .Zero): return false
	case (.Zero, _): return true
	case let (.Successor(predOfA), .Successor(predOfB)): return predOfA.unbox < predOfB.unbox
	default: return false
	}
}

func <=(a : Natural, b : Natural) -> Bool {
	return a == b || a < b
}

func >(a : Natural, b : Natural) -> Bool {
	return b < a
}

//println(Natural.Zero + One == One)
println(One + One == Two)
println(One == Two)
println(One < Two)
println(Two > One)

//println(Natural.Zero <= .Zero)
//println((Two - One) == One)
//println((.Zero - .Zero) == .Zero)
