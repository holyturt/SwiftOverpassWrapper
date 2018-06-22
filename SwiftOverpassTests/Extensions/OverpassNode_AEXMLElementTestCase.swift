//
//  OverpassNode_AEXMLElementTestCase.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 5/3/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import AEXML
import Alamofire
@testable import SwiftOverpass

class OverpassNode_AEXMLElementTestCase: XCTestCase {
    
    func testInitWithXMLElementShouldParseSingleNodeXMLFile() {
        guard let node = singleNodeFromXMLFile("SingleNode") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertEqual(node.id, 2306343684)
        XCTAssertEqual(node.latitude, 47.5575606)
        XCTAssertEqual(node.longitude, 10.7497321)
        
        XCTAssertEqual(node.tags["historic"], "castle")
        XCTAssertEqual(node.tags["name"], "Schloss Neuschwanstein")
        XCTAssertEqual(node.tags["name:ar"], "قصر نويشفانشتاين")
    }
    
    func testInitWithSingleNodeWithMetaPropertiesShouldParseTheMetaPropertiesCorrectly() {
        guard let node = singleNodeFromXMLFile("SingleNodeWithMetaProperties") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        guard let meta = node.meta else {
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
    
    private func singleNodeFromXMLFile(_ name: String) -> OverpassNode? {
        guard let xmlElement = xmlRootElementInFile(name) else {
            XCTFail("Unable to load the test XML element from file.")
            return nil
        }
        
        let response = OverpassResponse(response: DataResponse<String>(request: nil, response: nil, data: Data(), result: Result<String>.success("")),
                                        requestQuery: "")
        
        return OverpassNode(xmlElement: xmlElement, response: response)
    }
    
}
