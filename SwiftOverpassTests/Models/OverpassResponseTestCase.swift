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
    
    // MARK: Propagating errors
    
    func testInitWithMalformedStringsShouldThrowAnError() {
        let xml = "This is not valid XML"
        let requestQuery = "some query"
        
        XCTAssertThrowsError(try OverpassResponse(xml: xml, requestQuery: requestQuery)) { (error) -> Void in
            
            guard let responseError = error as? OverpassResponseError else {
                XCTFail("The parser should've thrown a specific error.")
                return
            }
            
            if case OverpassResponseError.parsingFailed(let queryFromError,
                                                        let xmlFromError,
                                                        let underlyingError) = responseError {
                XCTAssertEqual(queryFromError, requestQuery)
                XCTAssertEqual(xmlFromError, xml)
                
                let underlyingParserError = underlyingError as NSError
                XCTAssertEqual(underlyingParserError.domain, XMLParser.errorDomain)
                XCTAssertEqual(underlyingParserError.code, XMLParser.ErrorCode.emptyDocumentError.rawValue)
            } else {
                XCTFail("Unexpected error.")
            }
        }
    }
    
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
        } catch {
            XCTFail("Failed to create response: \(error)")
        }
    }
    
}
