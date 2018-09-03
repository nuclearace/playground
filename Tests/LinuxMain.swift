import XCTest

import collatzTests

var tests = [XCTestCaseEntry]()
tests += collatzTests.allTests()
XCTMain(tests)