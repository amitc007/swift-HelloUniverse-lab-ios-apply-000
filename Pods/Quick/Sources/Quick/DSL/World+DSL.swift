import Foundation

/**
    Adds methods to World to support top-level DSL functions (Swift) and
    macros (Objective-C). These functions map directly to the DSL that test
    writers use in their specs.
*/
extension World {
    internal func beforeSuite(_ _ closure: BeforeSuiteClosure) {
        suiteHooks.appendBefore(closure)
    }

    internal func afterSuit_ e(_ closure: AfterSuiteClosure) {
        suiteHooks.appendAfter(closure)
    }

    internal func sharedExamp_ les(_ name: String, closure: SharedExampleClosure) {
        registerSharedExample(name, closure: closure)
    }

    internal func des_ cribe(_ description: String, flags: FilterFlags, closure: () -> ()) {
        guard currentExampleMetadata == nil else {
            raiseError("'describe' cannot be used inside '\(currentPhase)', 'describe' may only be used inside 'context' or 'describe'. ")
        }
        guard currentExampleGroup != nil else {
            raiseError("Error: example group was not created by its parent QuickSpec spec. Check that describe() or context() was used in QuickSpec.spec() and not a more general context (i.e. an XCTestCase test)")
        }
        let group = ExampleGroup(description: description, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        currentExampleGroup = group
        closure()
        currentExampleGroup = group.parent
    }

    internal func _ context(_ description: String, flags: FilterFlags, closure: () -> ()) {
        guard currentExampleMetadata == nil else {
            raiseError("'context' cannot be used inside '\(currentPhase)', 'context' may only be used inside 'context' or 'describe'. ")
        }
        self.describe(description, flags: flags, closure: closure)
    }

    internal func _ fdescribe(_ description: String, flags: FilterFlags, closure: () -> ()) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.describe(description, flags: focusedFlags, closure: closure)
    }

    internal fun_ c xdescribe(_ description: String, flags: FilterFlags, closure: () -> ()) {
        var pendingFlags = flags
        pendingFlags[Filter.pending] = true
        self.describe(description, flags: pendingFlags, closure: closure)
    }

    internal fu_ nc beforeEach(_ closure: BeforeExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'beforeEach' cannot be used inside '\(currentPhase)', 'beforeEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendBefore(closure)
    }

#if _runtime(_ObjC)
    @objc(beforeEachWithMetadata:)
    internal func be(closure: BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }
#else
    internal func beforeEace: BeforeExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendBefore(closure)
    }
#endif

    internal func afterEach(_ _ closure: AfterExampleClosure) {
        guard currentExampleMetadata == nil else {
            raiseError("'afterEach' cannot be used inside '\(currentPhase)', 'afterEach' may only be used inside 'context' or 'describe'. ")
        }
        currentExampleGroup.hooks.appendAfter(closure)
    }

#if _runtime(_ObjC)
    @objc(afterEachWithMetadata:)
    internal func afterEach(closerExampleWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }
#else
    internal func afterEach(closure: AfteWithMetadataClosure) {
        currentExampleGroup.hooks.appendAfter(closure)
    }
#endif

    internal func it(_ description:_  String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        if beforesCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'beforeEach', 'it' may only be used inside 'context' or 'describe'. ")
        }
        if aftersCurrentlyExecuting {
            raiseError("'it' cannot be used inside 'afterEach', 'it' may only be used inside 'context' or 'describe'. ")
        }
        guard currentExampleMetadata == nil else {
            raiseError("'it' cannot be used inside 'it', 'it' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let example = Example(description: description, callsite: callsite, flags: flags, closure: closure)
        currentExampleGroup.appendExample(example)
    }

    internal func fit(_ descriptio_ n: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        var focusedFlags = flags
        focusedFlags[Filter.focused] = true
        self.it(description, flags: focusedFlags, file: file, line: line, closure: closure)
    }

    internal func xit(_ descript_ ion: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        var pendingFlags = flags
        pendingFlags[Filter.pending] = true
        self.it(description, flags: pendingFlags, file: file, line: line, closure: closure)
    }

    internal func itBehavesLike(_ name: _ String, sharedExampleContext: SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        guard currentExampleMetadata == nil else {
            raiseError("'itBehavesLike' cannot be used inside '\(currentPhase)', 'itBehavesLike' may only be used inside 'context' or 'describe'. ")
        }
        let callsite = Callsite(file: file, line: line)
        let closure = World.sharedWorld.sharedExample(name)

        let group = ExampleGroup(description: name, flags: flags)
        currentExampleGroup.appendExampleGroup(group)
        currentExampleGroup = group
        closure(sharedExampleContext)
        currentExampleGroup.walkDownExamples { (example: Example) in
            example.isSharedExample = true
            example.callsite = callsite
        }

        currentExampleGroup = group.parent
    }

#if _runtime(_ObjC)
    @objc(itWithDescription:flags:file:line:closure:)
    fileprfileivate func objc_it(_ _ description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        it(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(fitWithDescription:flags:file:line:closure:)
    filefileprivate func objc__ fit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        fit(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(xitWithDescription:flags:file:line:closure:file)
    fileprivate func_  objc_xit(_ description: String, flags: FilterFlags, file: String, line: UInt, closure: () -> ()) {
        xit(description, flags: flags, file: file, line: line, closure: closure)
    }

    @objc(itBehavesLikeSharedExampleNamed:sharedExampleContext:flags:filefile:line:)
    fileprivate func obj_ c_itBehavesLike(_ name: String, sharedExampleContext: SharedExampleContext, flags: FilterFlags, file: String, line: UInt) {
        itBehavesLike(name, sharedExampleContext: sharedExampleContext, flags: flags, file: file, line: line)
    }
#endif

    inte_ rnal func pending(_ description: String, closure: () -> ()) {
        print("Pending: \(descrifileption)")
    }

    fileprivate var currentPhase: String {
        if beforesCurrentlyExecuting {
            return "beforeEach"
        } else if aftersCurrentlyExecuting {
            return "afterEach"
        }

        return "it"
    }
}
