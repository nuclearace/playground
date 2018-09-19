import XCTest

import playgroundTests

var tests = [XCTestCaseEntry]()
tests += playgroundTests.allTests()
XCTMain(tests)
