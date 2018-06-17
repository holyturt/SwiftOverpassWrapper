//
//  OverpassNode+AEXMLElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/3/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import AEXML

extension OverpassNode {
    
    /// Attempts to create an Overpass node from the given XML element.
    ///
    /// - Parameters:
    ///   - xmlElement: The XML element to create the node from.
    ///   - response: Overpass response object that can be used to lookup related features.
    convenience init?(xmlElement: AEXMLElement, response: OverpassResponse) {
        
        // Basic entity properties
        guard let id = OverpassEntity.parseEntityId(from: xmlElement) else {
            return nil
        }
        let tags = OverpassEntity.parseTags(from: xmlElement)
        let meta = OverpassEntity.parseMeta(from: xmlElement)
        
        guard
            let latitudeAsString = xmlElement.attributes["lat"],
            let latitude = Double(latitudeAsString),
            let longitudeAsString = xmlElement.attributes["lon"],
            let longitude = Double(longitudeAsString)
        else {
            return nil
        }
        
        self.init(id: id,
                  lat: latitude,
                  lon: longitude,
                  tags: tags,
                  meta: meta,
                  response: response)
    }
    
}

