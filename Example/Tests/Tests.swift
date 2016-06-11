import UIKit
import XCTest
import SGauge

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValueLessThanMin() {
        let gauge = SGauge()
        gauge.minValue = 10
        gauge.value = -10
        XCTAssert(gauge.value == gauge.minValue)
    }
    
    func testValueGreaterThenMax() {
        let gauge = SGauge()
        gauge.maxValue = 10
        gauge.value = 100
        XCTAssert(gauge.value == gauge.maxValue)
    }
    
    func testNegativeAnimationDuration() {
        let gauge = SGauge()
        let originalDuration = gauge.animationDuration
        gauge.animationDuration = -10
        XCTAssert(gauge.animationDuration == originalDuration)
    }
    
    func testNegativeArcWidth() {
        let gauge = SGauge()
        let originalArcWidth = gauge.arcWidth
        gauge.arcWidth = -10
        XCTAssert(gauge.arcWidth == originalArcWidth)
    }
    
    func testNegativeArcOutlineWidth() {
        let gauge = SGauge()
        let originalArcOutlineWidth = gauge.arcOutlineWidth
        gauge.arcOutlineWidth = -10
        XCTAssert(gauge.arcOutlineWidth == originalArcOutlineWidth)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
