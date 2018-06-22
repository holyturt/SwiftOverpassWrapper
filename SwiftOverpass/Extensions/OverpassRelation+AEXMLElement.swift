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
    ///   - responseElementProvider: An object that is used to look up related elements
    ///                              that were received with the same response.
    convenience init?(xmlElement: AEXMLElement, responseElementProvider: OverpassResponseElementsProviding? = nil) {
        
        // Basic element properties
        guard let id = OverpassElement.parseId(from: xmlElement) else {
            return nil
        }
        let tags = OverpassElement.parseTags(from: xmlElement)
        let meta = OverpassElement.parseMeta(from: xmlElement)
        
        let members: [OverpassRelation.Member]
        if let memberXMLElements = xmlElement["member"].all {
            
            // A mapping of the XML attribute "type" to the cases of `OverpassQueryType`
            let typeAttributeToTypeEnum: [String: OverpassQueryType] = ["node": .node,
                                                                        "way": .way,
                                                                        "relation": .relation]
            
            members = memberXMLElements.compactMap {
                guard
                    let typeAttribute = $0.attributes["type"],
                    let type = typeAttributeToTypeEnum[typeAttribute]
                else {
                    // The member is of an unexpected type; ignore it.
                    return nil
                }
                
                guard
                    let idAsString = $0.attributes["ref"],
                    let id = Int(idAsString)
                else {
                    // Members must have an ID.
                    return nil
                }
                
                let role = $0.attributes["role"]
                return OverpassRelation.Member(type: type, id: id, role: role)
            }
        } else {
            members = []
        }
        
        self.init(id: id, tags: tags, meta: meta, members: members, responseElementProvider: responseElementProvider)
    }
    
}
