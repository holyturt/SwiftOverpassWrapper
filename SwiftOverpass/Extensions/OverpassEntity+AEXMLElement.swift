//
//  OverpassElement+AEXMLElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/16/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import AEXML

extension OverpassElement {
    
    static func parseId(from xmlElement: AEXMLElement) -> Int? {
        guard
            let idAsString = xmlElement.attributes["id"],
            let id = Int(idAsString)
        else {
            return nil
        }
        
        return id
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
    
    static func parseMeta(from xmlElement: AEXMLElement) -> Meta? {
        guard
            let versionAsString = xmlElement.attributes["version"],
            let version = Int(versionAsString),
            let changesetIdAsString = xmlElement.attributes["changeset"],
            let changesetId = Int(changesetIdAsString),
            let timestampAsString = xmlElement.attributes["timestamp"],
            let userIdAsString = xmlElement.attributes["uid"],
            let userId = Int(userIdAsString),
            let username = xmlElement.attributes["user"]
        else {
            return nil
        }
        
        return Meta(version: version,
                    changesetId: changesetId,
                    timestamp: timestampAsString,
                    userId: userId,
                    username: username)
    }
    
}

