//
//  OverpassTagTestCase.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 4/4/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import SwiftOverpass

class OverpassTagTestCase: XCTestCase {
    
    func testDesignatedInitializerShouldStoreParameters() {
        let key = "highway"
        let value = "bus_stop"
        let isNegation = true
        let isRegex = true
        
        let tag = OverpassTag(key: key,
                              value: value,
                              isNegation: isNegation,
                              isRegex: isRegex)
        
        XCTAssertEqual(tag.key, key)
        XCTAssertEqual(tag.value, value)
        XCTAssertEqual(tag.isNegation, isNegation)
        XCTAssertEqual(tag.isRegex, isRegex)
    }
    
}
