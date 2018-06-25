//
//  OverpassWay+AEXMLElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/17/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import AEXML

extension OverpassWay {
    
    /// Attempts to create an Overpass way from the given XML element.
    ///
    /// - Parameters:
    ///   - xmlElement: The XML element to create the way from.
    ///   - responseElementProvider: An object that is used to look up related elements
    ///                              that were received with the same response.
    convenience init?(xmlElement: AEXMLElement, responseElementProvider: OverpassResponseElementsProviding? = nil) {
        
        // Basic element properties
        guard let id = OverpassElement.parseId(from: xmlElement) else {
            return nil
        }
        let tags = OverpassElement.parseTags(from: xmlElement)
        let meta = OverpassElement.parseMeta(from: xmlElement)

        let nodeIds: [Int]
        if let nodeXMLElements = xmlElement["nd"].all {
            nodeIds = nodeXMLElements.compactMap { singleNodeXMLElement in
                guard
                    let idAsString = singleNodeXMLElement.attributes["ref"],
                    let id = Int(idAsString)
                else {
                    return nil
                }
                
                return id
            }
        } else {
            nodeIds = []
        }
        
        self.init(id: id, tags: tags, meta: meta, nodeIds: nodeIds, responseElementProvider: responseElementProvider)
    }
    
}
