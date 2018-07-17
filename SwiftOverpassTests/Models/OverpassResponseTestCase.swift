//
//  OverpassResponseTestCase.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 7/18/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import SwiftOverpass

class OverpassResponseTestCase: XCTestCase {
    
    // MARK: Response from Overpass
    
    func testInitWithXMLStringOfOverpassResponseShouldParseTheXML() {
        let xmlString = stringFromXMLFile("ShortenedResponseFromOverpass")
        let requestQuery = "some query"
        
        do {
            let response = try OverpassResponse(xml: xmlString,
                                                requestQuery: requestQuery)
            
            XCTAssertEqual(response.nodes?.count, 1)
            XCTAssertEqual(response.nodes?.first?.id, 266318045)
            
            XCTAssertEqual(response.ways?.count, 1)
            XCTAssertEqual(response.ways?.first?.id, 107305183)
            
            XCTAssertEqual(response.relations?.count, 1)
            XCTAssertEqual(response.relations?.first?.id, 124410)
            
            XCTAssertEqual(response.requestQuery, requestQuery)
        } catch {
            XCTFail("Failed to create response: \(error)")
        }
    }
    
    // MARK: Response from OpenStreetMap API
    
    func testInitWithXMLStringOfOpenStreetMapAPIResponseShouldParseTheXML() {
        let xmlString = stringFromXMLFile("ShortenedResponseFromOpenStreetMapAPI")
        let requestQuery = "some query"
        
        do {
            let response = try OverpassResponse(xml: xmlString,
                                                requestQuery: requestQuery)
            
            XCTAssertEqual(response.nodes?.count, 1)
            XCTAssertEqual(response.nodes?.first?.id, 378292)
            
            XCTAssertEqual(response.ways?.count, 1)
            XCTAssertEqual(response.ways?.first?.id, 524734)
            
            XCTAssertEqual(response.relations?.count, 1)
            XCTAssertEqual(response.relations?.first?.id, 1978434)
            
            XCTAssertEqual(response.requestQuery, requestQuery)
        } catch {
            XCTFail("Failed to create response: \(error)")
        }
    }
    
}
