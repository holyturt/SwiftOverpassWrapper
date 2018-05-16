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
    
    convenience init?(xmlElement: AEXMLElement, response: OverpassResponse) {
        guard
            let id = xmlElement.attributes["id"],
            let latitudeAsString = xmlElement.attributes["lat"],
            let latitude = Double(latitudeAsString),
            let longitudeAsString = xmlElement.attributes["lon"],
            let longitude = Double(longitudeAsString)
        else {
            return nil
        }
        
        let tags = OverpassNode.parseTags(from: xmlElement)
        
        self.init(id: id,
                  lat: latitude,
                  lon: longitude,
                  tags: tags,
                  response: response)
    }
    
    static private func parseTags(from nodeXMLElement: AEXMLElement) -> [String: String] {
        var tags = [String : String]()
        
        if let tagElems = nodeXMLElement["tag"].all {
            tagElems.forEach {
                if let k = $0.attributes["k"], let v = $0.attributes["v"] {
                    tags[k] = v
                }
            }
        }
        return tags
    }
    
}

