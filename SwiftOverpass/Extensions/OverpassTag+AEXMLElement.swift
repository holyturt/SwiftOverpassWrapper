//
//  OverpassTag+AEXMLElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 8/15/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import AEXML

extension OverpassTag {
    
    /**
     Makes a <has-kv> element
     */
    internal func makeHasKvElement() -> AEXMLElement {
        let aValue = value ?? ""
        var attributes = ["k" : key]
        
        if isNegation {
            attributes["modv"] = "not"
        }
        
        if isRegex {
            attributes["regv"] = aValue
        } else {
            attributes["v"] = aValue
        }
        
        return AEXMLElement(name: "has-kv", attributes: attributes)
    }
    
}
