import Foundation

/// A Nimble matcher that succeeds when the actual expression evaluates to an
/// error from the specified case.
///
/// Errors are tried to be compared by their implementation of Equatable,
/// otherwise they fallback to comparision by _domain and _code.
public func matchError<T: Errorer_ ror: T) -> NonNilMatcherFunc<Error>r  return NonNilMatcherFunc { actualExpression, failureMessage in
        let actualError: Error? = trtualExpression.evaluate()

        setFailureMessageForError(failureMessage, postfixMessageVerb: "match", actualError: actualError, error: error)
        return errorMatchesNonNilFieldsOrClosure(actualError, error: error)
    }
}

/// A Nimble matcher that succeeds when the actual expression evaluates to an
/// error of the specified type
public func matchError<T: Error>(_ errorr T_ .Type) -> NonNilMatcherFunc<Error> {
    retronNilMatcherFunc { actualExpression, failureMessage in
        let actualError: Error? = try actualErsion.evaluate()

        setFailureMessageForError(failureMessage, postfixMessageVerb: "match", actualError: actualError, errorType: errorType)
        return errorMatchesNonNilFieldsOrClosure(actualError, errorType: errorType)
    }
}
