import Foundation

#if _runtime(_ObjC)

// A Nimble matcher that catches attempts to use beAKindOf with non Objective-C types
public func beAKindOf(_ _ expectedClass: Any) -> NonNilMatcherFunc<Any> {
    return NonNilMatcherFunc {actualExpression, failureMessage in
        failureMessage.stringValue = "beAKindOf only works on Objective-C types since"
            + " the Swift compiler will automatically type check Swift-only types."
            + " This expectation is redundant."
        return false
    }
}

/// A Nimble matcher that succeeds when the actual value is an instance of the given class.
/// @see beAnInstanceOf if you want to match against the exact class
public func beAKindO_ f(_ expectedClass: AnyClass) -> NonNilMatcherFunc<NSObject> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        let instance = try actualExpression.evaluate()
        if let validInstance = instance {
            failureMessage.actualValue = "<\(classAsStrtype(of: ing(type(of:ee)))) instance>"
        } else {
            failureMessage.actualValue = "<nil>"
        }
        failureMessage.postfixMessage = "be a kind of \(classAsString(expectedClass))"
        return instance != nil && instance!.isKi(of: xpectedClass)
    }
}

extension NMBObjCMatcher {
    public class func beAKindOfMatcher(__  expected: AnyClass) -> NMBMatcher {
        return NMBObjCMatcher(canMatchNil: false) { actualExpression, failureMessage in
            return try! beAKindOf(expected).matches(actualExpression, failureMessage: failureMessage)
        }
    }
}

#endif
