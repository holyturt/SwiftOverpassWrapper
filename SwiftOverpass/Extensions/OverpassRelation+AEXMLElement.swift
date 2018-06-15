//
//  OverpassRelation+AEXMLElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/17/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import AEXML

extension OverpassRelation {
    
    /// Attempts to create an Overpass relation from the given XML element.
    ///
    /// - Parameters:
    ///   - xmlElement: The XML element to create the relation from.
    ///   - response: Overpass response object that can be used to lookup related features.
    convenience init?(xmlElement: AEXMLElement, response: OverpassResponse) {
        
        // Basic entity properties
        guard let id = OverpassEntity.parseEntityId(from: xmlElement) else {
            return nil
        }
        let tags = OverpassEntity.parseTags(from: xmlElement)
        
        let members: [OverpassRelation.Member]
        if let memberXMLElements = xmlElement["member"].all {
            members = memberXMLElements.map {
                var type: OverpassQueryType!
                switch $0.attributes["type"]! {
                case "node": type = .node
                case "way": type = .way
                case "relation": type = .relation
                default: break // TODO: shouldn't be reach here, throw error
                }
                
                let ref = $0.attributes["ref"]!
                let role = $0.attributes["role"]
                return OverpassRelation.Member(type: type, id: ref, role: role)
            }
        } else {
            members = []
        }
        
        self.init(id: id, members: members, tags: tags, response: response)
    }
    
}
