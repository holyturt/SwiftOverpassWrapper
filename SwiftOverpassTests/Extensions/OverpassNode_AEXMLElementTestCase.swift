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
        guard let xmlElement = xmlRootElementInFile("SingleNode") else {
            XCTFail("Unable to load the test XML element from file.")
            return
        }
        
        let response = OverpassResponse(response: DataResponse<String>(request: nil, response: nil, data: Data(), result: Result<String>.success("")),
                                        requestQuery: "")
        
        guard let node = OverpassNode(xmlElement: xmlElement, response: response) else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertEqual(node.id, "2306343684")
        XCTAssertEqual(node.latitude, 47.5575606)
        XCTAssertEqual(node.longitude, 10.7497321)
        
        XCTAssertEqual(node.tags["historic"], "castle")
        XCTAssertEqual(node.tags["name"], "Schloss Neuschwanstein")
        XCTAssertEqual(node.tags["name:ar"], "قصر نويشفانشتاين")
    }
    
}
