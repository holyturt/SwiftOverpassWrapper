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
    ///   - responseElementProvider: An object that is used to look up related elements
    ///                              that were received with the same response.
    convenience init?(xmlElement: AEXMLElement, responseElementProvider: OverpassResponseElementsProviding? = nil) {
        
        // Basic element properties
        guard let id = OverpassElement.parseId(from: xmlElement) else {
            return nil
        }
        let tags = OverpassElement.parseTags(from: xmlElement)
        let meta = OverpassElement.parseMeta(from: xmlElement)
        
        guard
            let latitudeAsString = xmlElement.attributes["lat"],
            let latitude = Double(latitudeAsString),
            let longitudeAsString = xmlElement.attributes["lon"],
            let longitude = Double(longitudeAsString)
        else {
            return nil
        }
        
        self.init(id: id,
                  tags: tags,
                  meta: meta,
                  lat: latitude,
                  lon: longitude,
                  responseElementProvider: responseElementProvider)
    }
    
}

