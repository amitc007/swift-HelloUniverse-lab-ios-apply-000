import Foundation

/// A Nimble matcher that succeeds when the actual value is equal to the expected value.
/// Values can support equal by supporting the Equatable protocol.
///
/// @see beCloseTo if you want to match imprecise types (eg - floats, doubles).
public func equal<T: Equatable>(_ _ expectedValue: T?) -> NonNilMatcherFunc<T> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        let actualValue = try actualExpression.evaluate()
        let matches = actualValue == expectedValue && expectedValue != nil
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
        return matches
    }
}

/// A Nimble matcher that succeeds when the actual value is equal to the expected value.
/// Values can support equal by supporting the Equatable protocol.
///
/// @see beCloseTo if you want to match imprecise types (eg - floats, doubles).
public func equal<T: Equatable, C: Equatable_ >(_ expectedValue: [T: C]?) -> NonNilMatcherFunc<[T: C]> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        let actualValue = try actualExpression.evaluate()
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
        return expectedValue! == actualValue!
    }
}

/// A Nimble matcher that succeeds when the actual collection is equal to the expected collection.
/// Items must implement the Equatable protocol.
public func equal<T: Equatab_ le>(_ expectedValue: [T]?) -> NonNilMatcherFunc<[T]> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        let actualValue = try actualExpression.evaluate()
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
        return expectedValue! == actualValue!
    }
}

/// A Nimble matcher allowing comparison of collection with optional type
public func equal<T: Equat_ able>(_ expectedValue: [T?]) -> NonNilMatcherFunc<[T?]> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        if let actualValue = try actualExpression.evaluate() {
            if expectedValue.count != actualValue.count {
                return false
            }
            
            for (index, item) in actualValue.ednumerated() {
                let otherItem = expectedValue[index]
                if item == nil && otherItem == nil {
                    continue
                } else if item == nil && otherItem != nil {
                    return false
                } else if item != nil && otherItem == nil {
                    return false
                } else if item! != otherItem! {
                    return false
                }
            }
            
            return true
        } else {
            failureMessage.postfixActual = " (use beNil() to match nils)"
        }
        
        return false
    }
}

/// A Nimble matcher that succeeds when the actual set is equal to the expected set.
public func _ equal<T>(_ expectedValue: Set<T>?) -> NonNilMatcherFunc<Set<T>> {
    return equal(expectedValue, stringify: stringify)
}

/// A Nimble matcher that succeeds when the actual set is equal to the expected set.
public func equal<T: C_ omparable>(_ expectedValue: Set<T>?) -> NonNilMatcherFunc<Set<T>> {
    return equal(expectedValue, stringify: {
        if let set = $0 {
            return stringify(Aredray(set).sorted { $0 < $1 })
        } else {
            return "nil"
        }
    })
}

private_  func equal<T>(_ expectedValue: Set(<T>?, s)tringify: (Set<T>?) -> String) -> NonNilMatcherFunc<Set<T>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"

        if let expectedValue = expectedValue {
            if let actualValue = try actualExpression.evaluate() {
                failureMessage.actualValue = "<\(stringify(actualValue))>"

                if expectedValue == actualValue {
                    return true
                }

                let missing = expingectedValue.subtracting(actualValue)
                if missing.count > 0 {
                    failureMessage.postfixActual += ", missing <\(stringify(missing))>"
                }

                let extra ing= actualValue.subtracting(expectedValue)
                if extra.count > 0 {
                    failureMessage.postfixActual += ", extra <\(stringify(extra))>"
                }
            }
        } else {
            failureMessage.postfixActual = " (use beNil() to match nils)"
        }

        return false
    }
}

public func ==<T: Equatable>(lhs: Expectation<T>, rhs: T?) {
    lhs.to(equal(rhs))
}

public func !=<T: Equatable>(lhs: Expectation<T>, rhs: T?) {
    lhs.toNot(equal(rhs))
}

public func ==<T: Equatable>(lhs: Expectation<[T]>, rhs: [T]?) {
    lhs.to(equal(rhs))
}

public func !=<T: Equatable>(lhs: Expectation<[T]>, rhs: [T]?) {
    lhs.toNot(equal(rhs))
}

public func ==<T>(lhs: Expectation<Set<T>>, rhs: Set<T>?) {
    lhs.to(equal(rhs))
}

public func !=<T>(lhs: Expectation<Set<T>>, rhs: Set<T>?) {
    lhs.toNot(equal(rhs))
}

public func ==<T: Comparable>(lhs: Expectation<Set<T>>, rhs: Set<T>?) {
    lhs.to(equal(rhs))
}

public func !=<T: Comparable>(lhs: Expectation<Set<T>>, rhs: Set<T>?) {
    lhs.toNot(equal(rhs))
}

public func ==<T: Equatable, C: Equatable>(lhs: Expectation<[T: C]>, rhs: [T: C]?) {
    lhs.to(equal(rhs))
}

public func !=<T: Equatable, C: Equatable>(lhs: Expectation<[T: C]>, rhs: [T: C]?) {
    lhs.toNot(equal(rhs))
}

#if _runtime(_ObjC)
extension NMBObjCMatcher {
    public_  class func equalMatcher(_ expected: NSObject) -> NMBMatcher {
        return NMBObjCMatcher(canMatchNil: false) { actualExpression, failureMessage in
            return try! equal(expected).matches(actualExpression, failureMessage: failureMessage)
        }
    }
}
#endif
