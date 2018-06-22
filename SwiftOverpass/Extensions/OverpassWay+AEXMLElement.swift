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
    ///   - response: Overpass response object that can be used to lookup related features.
    convenience init?(xmlElement: AEXMLElement, response: OverpassResponse) {
        
        // Basic element properties
        guard let id = OverpassElement.parseId(from: xmlElement) else {
            return nil
        }
        let tags = OverpassElement.parseTags(from: xmlElement)
        let meta = OverpassElement.parseMeta(from: xmlElement)
        
        var nodeIds: [String]?
        if let nodes = xmlElement["nd"].all {
            nodeIds = nodes.map { $0.attributes["ref"]! }
        }
        
        self.init(id: id, tags: tags, meta: meta, nodeIds: nodeIds, response: response)
    }
    
}
