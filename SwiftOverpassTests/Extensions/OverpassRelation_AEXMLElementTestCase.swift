//
//  OverpassRelation_AEXMLElementTestCase.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 5/3/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import AEXML
import Alamofire
@testable import SwiftOverpass

class OverpassRelation_AEXMLElementTestCase: XCTestCase {
    
    func testInitWithXMLElementShouldParseSingleRelationXMLFile() {
        guard let xmlElement = xmlRootElementInFile("SingleRelation") else {
            XCTFail("Unable to load the test XML element from file.")
            return
        }
        
        let response = OverpassResponse(response: DataResponse<String>(request: nil, response: nil, data: Data(), result: Result<String>.success("")),
                                        requestQuery: "")
        
        guard let relation = OverpassRelation(xmlElement: xmlElement, response: response) else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertEqual(relation.id, "2674373")
        
        let firstWayMember = OverpassRelation.Member(type: .way,
                                                     id: "363580156",
                                                     role: "outer")
        let secondWayMember = OverpassRelation.Member(type: .way,
                                                      id: "142678633",
                                                      role: "outer")
        
        XCTAssertEqual(relation.members, [firstWayMember, secondWayMember])
        
        XCTAssertEqual(relation.tags["addr:street"], "Mönckebergstraße")
        XCTAssertEqual(relation.tags["addr:housenumber"], "16")
        XCTAssertEqual(relation.tags["addr:city"], "Hamburg")
        
    }
    
}
