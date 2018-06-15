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
        guard let relation = singleRelationFromXMLFile("SingleRelation") else {
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
    
    // MARK: Helper
    
    private func singleRelationFromXMLFile(_ name: String) -> OverpassRelation? {
        guard let xmlElement = xmlRootElementInFile(name) else {
            XCTFail("Unable to load the test XML element from file.")
            return nil
        }
        
        let response = OverpassResponse(response: DataResponse<String>(request: nil, response: nil, data: Data(), result: Result<String>.success("")),
                                        requestQuery: "")
        
        return OverpassRelation(xmlElement: xmlElement, response: response)
    }
    
}
