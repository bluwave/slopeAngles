//
//  SlopeAngleFormatterTests.swift
//  slopes
//
//  Created by Garrett Richards on 11/17/15.
//  Copyright © 2015 Acme. All rights reserved.
//

import XCTest


class SlopeAngleFormatterTests: XCTestCase {

    var angleFormatter: SlopeAngleFormatter?

    override func setUp() {
        super.setUp()
        angleFormatter = SlopeAngleFormatter()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOver90Degrees() {
        //  Given
        let angle: Double = 91

        //  When
        let result = angleFormatter?.formatAngle(angle)

        //  Then
        XCTAssertEqual("89°", result!)
    }

    func testOver90DegreesCloseTo180() {
        //  Given
        let angle: Double = 179

        //  When
        let result = angleFormatter?.formatAngle(angle)

        //  Then
        XCTAssertEqual("1°", result!)
    }


    func testUnder90Degrees() {
        //  Given
        let angle: Double = 45

        //  When
        let result = angleFormatter?.formatAngle(angle)

        //  Then
        XCTAssertEqual("45°", result!)
    }

    func testZeroDegrees() {
        //  Given
        let angle: Double = 0.0002222200021

        //  When
        let result = angleFormatter?.formatAngle(angle)

        //  Then
        XCTAssertEqual("0°", result!)
    }

    func testLessThanZero() {
        //  Given
        let angle: Double = -10

        //  When
        let result = angleFormatter?.formatAngle(angle)

        //  Then
        XCTAssertEqual("0°", result!)
    }

    func testLessThanZero2() {
        //  Given
        let angle: Double = -179
        
        //  When
        let result = angleFormatter?.formatAngle(angle)
        
        //  Then
        XCTAssertEqual("0°", result!)
    }

}
