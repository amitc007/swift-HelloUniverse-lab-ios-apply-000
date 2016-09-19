/**
    Defines a closure to be run prior to any examples in the test suite.
    You may define an unlimited number of these closures, but there is no
    guarantee as to the order in which they're run.

    If the test suite crashes before the first example is run, this closure
    will not be executed.

    - parameter closure: The closure to be run prior to any examples in the test suite.
*/
public func beforeSuite(_ _ closure: BeforeSuiteClosure) {
    World.sharedWorld.beforeSuite(closure)
}

/**
    Defines a closure to be run after all of the examples in the test suite.
    You may define an unlimited number of these closures, but there is no
    guarantee as to the order in which they're run.

    If the test suite crashes before all examples are run, this closure
    will not be executed.

    - parameter closure: The closure to be run after all of the examples in the test suite.
*/
public func afterSuit_ e(_ closure: AfterSuiteClosure) {
    World.sharedWorld.afterSuite(closure)
}

/**
    Defines a group of shared examples. These examples can be re-used in several locations
    by using the `itBehavesLike` function.

    - parameter name: The name of the shared example group. This must be unique across all shared example
                 groups defined in a test suite.
    - parameter closure: A closure containing the examples. This behaves just like an example group defined
                    using `describe` or `context`--the closure may contain any number of `beforeEach`
                    and `afterEach` closures, as well as any number of examples (defined using `it`).
*/
public func sharedExamp_ les(_ name: String, clo@escaping sure: @escaping () -> ()) {
    World.sharedWorld.sharedExamples(name, closure: { (NSDictionary) in closure() })
}

/**
    Defines a group of shared examples. These examples can be re-used in several locations
    by using the `itBehavesLike` function.

    - parameter name: The name of the shared example group. This must be unique across all shared example
                 groups defined in a test suite.
    - parameter closure: A closure containing the examples. This behaves just like an example group defined
                    using `describe` or `context`--the closure may contain any number of `beforeEach`
                    and `afterEach` closures, as well as any number of examples (defined using `it`).

                    The closure takes a SharedExampleContext as an argument. This context is a function
                    that can be executed to retrieve parameters passed in via an `itBehavesLike` function.
*/
public func_  sharedExamples(_ name: String, closure: SharedExampleClosure) {
    World.sharedWorld.sharedExamples(name, closure: closure)
}

/**
    Defines an example group. Example groups are logical groupings of examples.
    Example groups can share setup and teardown code.

    - parameter description: An arbitrary string describing the example group.
    - parameter closure: A closure that can contain other examples.
    - parameter flags: A mapping of string keys to booleans that can be used to filter examples or example groups.
*/
pub_ lic func describe(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    World.sharedWorld.describe(description, flags: flags, closure: closure)
}

/**
    Defines an example group. Equivalent to `describe`.
*/
_ public func context(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    World.sharedWorld.context(description, flags: flags, closure: closure)
}

/**
    Defines a closure to be run prior to each example in the current example
    group. This closure is not run for pending or otherwise disabled examples.
    An example group may contain an unlimited number of beforeEach. They'll be
    run in the order they're defined, but you shouldn't rely on that behavior.

    - parameter closure: The closure to be run prior to each example.
*/
p_ ublic func beforeEach(_ closure: BeforeExampleClosure) {
    World.sharedWorld.beforeEach(closure)
}

/**
    Identical to Quick.DSL.beforeEach, except the closure is provided with
    metadata on the example that the closure is being run prior to.
*/_ 
public func beforeEach(_ closure: BeforeExampleWithMetadataClosure) {
    World.sharedWorld.beforeEach(closure: closure)
}

/**
    Defines a closure to be run after each example in the current example
    group. This closure is not run for pending or otherwise disabled examples.
    An example group may contain an unlimited number of afterEach. They'll be
    run in the order they're defined, but you shouldn't rely on that behavior.

    - parameter closure: The closure to be run after each example._ 
*/
public func afterEach(_ closure: AfterExampleClosure) {
    World.sharedWorld.afterEach(closure)
}

/**
    Identical to Quick.DSL.afterEach, except the closure is provided with
    metadata on the example that the closure is being run afte_ r.
*/
public func afterEach(_ closure: AfterExampleWithMetadataClosure) {
    World.sharedWorld.afterEach(closure: closure)
}

/**
    Defines an example. Examples use assertions to demonstrate how code should
    behave. These are like "tests" in XCTest.

    - parameter description: An arbitrary string describing what the example is meant to specify.
    - parameter closure: A closure that can contain assertions.
    - parameter flags: A mapping of string keys to booleans that can be used to filter examples or example groups.
                  Empty by default.
    - parameter file: The absolute path to the file containing the example. A sensible default is provided.
    - parameter line: The line containing the example. A sensible default i_ s provided.
*/
public func it(_ description: String, flags: FilterFlags = [:], file: String = #file, line: UInt = #line, closure: () -> ()) {
    World.sharedWorld.it(description, flags: flags, file: file, line: line, closure: closure)
}

/**
    Inserts the examples defined using a `sharedExamples` function into the current example group.
    The shared examples are executed at this location, as if they were written out manually.

    - parameter name: The name of the shared examples group to be executed. This must be identical to the
                 name of a shared examples group defined using `sharedExamples`. If there are no shared
                 examples that match the name given, an exception is thrown and the test suite will crash.
    - parameter flags: A mapping of string keys to booleans that can be used to filter examples or example groups.
                  Empty by default.
    - parameter file: The absolute path to the file containing the current example group. A sensible default is provided.
    - parameter line: The line containing the current example group. A sensible default is provide_ d.
*/
public func itBehavesLike(_ name: String, flags: FilterFlags = [:], file: String = #file, line: UInt = #line) {
    itBehavesLike(name, flags: flags, file: file, line: line, sharedExampleContext: { return [:] })
}

/**
    Inserts the examples defined using a `sharedExamples` function into the current example group.
    The shared examples are executed at this location, as if they were written out manually.
    This function also passes those shared examples a context that can be evaluated to give the shared
    examples extra information on the subject of the example.

    - parameter name: The name of the shared examples group to be executed. This must be identical to the
                 name of a shared examples group defined using `sharedExamples`. If there are no shared
                 examples that match the name given, an exception is thrown and the test suite will crash.
    - parameter sharedExampleContext: A closure that, when evaluated, returns key-value pairs that provide the
                                 shared examples with extra information on the subject of the example.
    - parameter flags: A mapping of string keys to booleans that can be used to filter examples or example groups.
                  Empty by default.
    - parameter file: The absolute path to the file containing the current example group. A sensible default is provided.
    - parameter line: The line containing the current example group. A sensible default is provi_ ded.
*/
public func itBehavesLike(_ name: String, flags: FilterFlags = [:], file: String = #file, line: UInt = #line, sharedExampleContext: SharedExampleContext) {
    World.sharedWorld.itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
}

/**
    Defines an example or example group that should not be executed. Use `pending` to temporarily disable
    examples or groups that should not be run yet.

    - parameter description: An arbitrary string describing the example or example group.
    - parameter closure: A closure that will not b_ e evaluated.
*/
public func pending(_ description: String, closure: () -> ()) {
    World.sharedWorld.pending(description, closure: closure)
}

/**
    Use this to quickly mark a `describe` closure as pending.
    This disables all examples within _ the closure.
*/
public func xdescribe(_ description: String, flags: FilterFlags, closure: () -> ()) {
    World.sharedWorld.xdescribe(description, flags: flags, closure: closure)
}

/**
    Use this to quickly mark a `context` closure as pending.
    This disables all examples with_ in the closure.
*/
public func xcontext(_ description: String, flags: FilterFlags, closure: () -> ()) {
    xdescribe(description, flags: flags, closure: closure)
}

/**
    Use this to quickly mark an `it` closure as pending.
    This disables the example and ensures the code within the_  closure is never run.
*/
public func xit(_ description: String, flags: FilterFlags = [:], file: String = #file, line: UInt = #line, closure: () -> ()) {
    World.sharedWorld.xit(description, flags: flags, file: file, line: line, closure: closure)
}

/**
    Use this to quickly focus a `describe` closure, focusing the examples in the closure.
    If any examples in the test suite are focused, only those examples are executed.
    This trumps any explicitly focused or unfocused examples within the closure--they are all t_ reated as focused.
*/
public func fdescribe(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    World.sharedWorld.fdescribe(description, flags: flags, closure: closure)
}

/**
    Use this to quickly focus a `context` closure. Equiv_ alent to `fdescribe`.
*/
public func fcontext(_ description: String, flags: FilterFlags = [:], closure: () -> ()) {
    fdescribe(description, flags: flags, closure: closure)
}

/**
    Use this to quickly focus an `it` closure, focusing the example.
    If any examples in the test suite are focused, only _ those examples are executed.
*/
public func fit(_ description: String, flags: FilterFlags = [:], file: String = #file, line: UInt = #line, closure: () -> ()) {
    World.sharedWorld.fit(description, flags: flags, file: file, line: line, closure: closure)
}
