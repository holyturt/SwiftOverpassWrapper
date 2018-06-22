//
//  OverpassRelation_AEXMLElementTestCase.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 5/3/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import AEXML
@testable import SwiftOverpass

class OverpassRelation_AEXMLElementTestCase: XCTestCase {
    
    func testInitWithXMLElementShouldParseSingleRelationXMLFile() {
        guard let relation = singleRelationFromXMLFile("SingleRelation") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertEqual(relation.id, 2674373)
        
        let firstWayMember = OverpassRelation.Member(type: .way,
                                                     id: 363580156,
                                                     role: "outer")
        let secondWayMember = OverpassRelation.Member(type: .way,
                                                      id: 142678633,
                                                      role: "outer")
        
        XCTAssertEqual(relation.members, [firstWayMember, secondWayMember])
        
        XCTAssertEqual(relation.tags["addr:street"], "Mönckebergstraße")
        XCTAssertEqual(relation.tags["addr:housenumber"], "16")
        XCTAssertEqual(relation.tags["addr:city"], "Hamburg")
        
    }
    
    func testInitWithXMLElementThatContainsASingleRelationWithMemberOfUnexpectedTypeShouldContinueParsing() {
        guard let relation = singleRelationFromXMLFile("SingleRelationWithMemberOfUnexpectedType") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        // The file contains two types, but the first of them has a bogus type that the parser
        // will not be able to recognize. It should just skip that member and continue parsing,
        // resulting in one member.
        let way = OverpassRelation.Member(type: .way, id: 142678633, role: "outer")
        XCTAssertEqual(relation.members, [way])
    }
    
    func testInitWithXMLElementShouldIgnoreMembersThatAreMissingTheirID() {
        guard let relation = singleRelationFromXMLFile("SingleRelationWithMemberThatIsMissingItsID") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        XCTAssertTrue(relation.members.isEmpty)
    }
    
    func testInitWithSingleRelationWithMetaPropertiesShouldParseTheMetaPropertiesCorrectly() {
        guard let relation = singleRelationFromXMLFile("SingleRelationWithMetaProperties") else {
            XCTFail("The XML should properly initialize the model.")
            return
        }
        
        guard let meta = relation.meta else {
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
    
    private func singleRelationFromXMLFile(_ name: String) -> OverpassRelation? {
        guard let xmlElement = xmlRootElementInFile(name) else {
            XCTFail("Unable to load the test XML element from file.")
            return nil
        }
        
        return OverpassRelation(xmlElement: xmlElement)
    }
    
}
