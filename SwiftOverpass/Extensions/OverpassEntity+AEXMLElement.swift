//
//  OverpassEntity+AEXMLElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/16/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import AEXML

extension OverpassEntity {
    
    static func parseEntityId(from xmlElement: AEXMLElement) -> String? {
        return xmlElement.attributes["id"]
    }
    
    static func parseTags(from xmlElement: AEXMLElement) -> [String: String] {
        var tags = [String : String]()
        
        if let tagElems = xmlElement["tag"].all {
            tagElems.forEach {
                if let k = $0.attributes["k"], let v = $0.attributes["v"] {
                    tags[k] = v
                }
            }
        }
        
        return tags
    }
    
}

