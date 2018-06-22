//
//  OverpassWay_AEXMLElementTestCase.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 5/17/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import AEXML
import Alamofire
@testable import SwiftOverpass

class OverpassWay_AEXMLElementTestCase: XCTestCase {
    
    func testInitWithXMLElementShouldParseSingleNodeXMLFile() {
        guard let way = singleWayFromXMLFile("SingleWay") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertEqual(way.id, "587898625")
        XCTAssertEqual(way.tags["highway"], "secondary")
        
        let expectedNodeIds = ["292831593", "292831592"]
        XCTAssertEqual(way.nodeIds, expectedNodeIds)
    }
    
    func testInitWithXMLElementShouldIgnoreNodesThatAreLackingAnID() {
        guard let way = singleWayFromXMLFile("SingleWayWithNodeThatIsMissingItsID") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertEqual(way.nodeIds, ["292831592"])
    }
    
    func testInitWithSingleWayWithMetaPropertiesShouldParseTheMetaPropertiesCorrectly() {
        guard let way = singleWayFromXMLFile("SingleWayWithMetaProperties") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        guard let meta = way.meta else {
            XCTFail("The meta information should've been parsed.")
            return
        }
        
        XCTAssertEqual(meta.version, 4)
        XCTAssertEqual(meta.changesetId, 42)
        XCTAssertEqual(meta.timestamp, "2012-11-30T09:52:43Z")
        XCTAssertEqual(meta.userId, 1337)
        XCTAssertEqual(meta.username, "john.doe")
    }
    
    // MARK: Helper
    
    private func singleWayFromXMLFile(_ name: String) -> OverpassWay? {
        guard let xmlElement = xmlRootElementInFile(name) else {
            XCTFail("Unable to load the test XML element from file.")
            return nil
        }
        
        let response = OverpassResponse(response: DataResponse<String>(request: nil, response: nil, data: Data(), result: Result<String>.success("")),
                                        requestQuery: "")
        
        return OverpassWay(xmlElement: xmlElement, response: response)
    }
    
}
