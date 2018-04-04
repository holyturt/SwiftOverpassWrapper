//
//  OverpassQuery.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation
import AEXML

// Represents types of queries.
public enum OverpassQueryType {
    case
    /// Specifies the query is node
    node,
    /// Specifies the query is way
    way,
    /// Specifies the query is relation
    relation,
    /// Specifies the query is down
    down,
    /// Specifies the query is up
    up

    // TODO: Implement another query types.
    //    /// Specifies the query is backwards
    //    backwards,
    //    /// Specifies the query is down-rel
    //    downRel,
    //    /// Specifies the query is up-rel
    //    upRel
    
    /// The string to creat a XML line.
    public var stringValue: String {
        return OverpassQueryType.stringMapping[self]!
    }
    
    fileprivate static let stringMapping = [
        node: "node",
        way: "way",
        relation: "relation",
        down: "down",
        up: "up"
        //        backwards: "backwords",
        //        downRel: "down-rel",
        //        upRel: "up-rel"
    ]
}

/**
 */
public protocol OverpassQuery: class {
    /// The type of the query
    var type: OverpassQueryType { get }
    /// The parent query of the query
    var parent: OverpassQuery? { get }
    /// The bounding box to filter
    var boundingBox: BoudingBox? { get set }
    /// The tags to filter
    var tags: [String: OverpassTag] { get set }
    
    /// Makes a <query> element
    func makeXmlQuery() -> AEXMLElement
    /// Makes a <recurse> element
    func makeRecurseElement() -> AEXMLElement
}

/**
 Provides helper methods for `OverpassQuery`
*/
extension OverpassQuery {
    
    /**
     Creates a related query. This function works like <recurse> elements
     
     - parameter type: A query type
     */
    public func related(_ type: OverpassQueryType) -> OverpassQuery {
        switch type {
        case .node:
            return NodeQuery(parent: self)
        case .way:
            return WayQuery(parent: self)
        case .relation:
            return RelationQuery(parent: self)
        case .down:
            return DownQuery(parent: self)
        case .up:
            return UpQuery(parent: self)
            //        case .backwards:
            //            <#code#>
            //        case .downRel:
            //            <#code#>
            //        case .upRel:
            //            <#code#>
        }
    }
    
    /**
     Makes relations
     */
    internal func recurse(_ xmlDocument: AEXMLDocument) -> AEXMLDocument {
        var xmlDocument = xmlDocument
        
        if let aParent = parent {
            // If the query has a parent query, add <recurse> element to the query
            xmlDocument = aParent.recurse(xmlDocument)
            xmlDocument.addChild(makeRecurseElement())
        } else {
            // Otherwise add <query> element to the query
            xmlDocument.addChild(makeXmlQuery())
        }
        
        return xmlDocument
    }
    
    /**
     Makes a xml document to request to api
     */
    public func makeXmlDocument() -> AEXMLDocument {
        var xmlDoc = AEXMLDocument()
        
        if let aParent = parent {
            // If the query has a parent query, add <recurse> element to the query
            xmlDoc = aParent.recurse(xmlDoc)
            
            let union = xmlDoc.addChild(name: "union")
            union.addChild(name: "item")
            union.addChild(makeRecurseElement())
        } else {
            // Otherwise add <query> element to the query
            let union = xmlDoc.addChild(name: "union")
            union.addChild(name: "item")
            union.addChild(makeXmlQuery())
        }
        
        return xmlDoc
    }
    
    /**
     Sets a bbox to retrieve from specific location
     
     - parameter bbox: A bouding box to set
     */
    public func setBoudingBox(_ bbox: BoudingBox) {
        boundingBox = bbox
    }
    
    /**
     Sets a bbox to retrieve from specific location
     
     - parameter s: Lowest latitude
     - parameter n: Lowest longitude
     - parameter w: Highest latitude
     - parameter e: Highest longitude
     */
    public func setBoudingBox(s: Double, n: Double, w: Double, e: Double) {
        boundingBox = BoudingBox(s: s, n: n, w: w, e: e)
    }
    
    /**
     Sets a tag to the query
     
     - parameter key: A key of the <has-kv> element
     - parameter value: A value of the <has-kv> element
     */
    public func hasTag(_ key: String, equals value: String) {
        tags[key] = OverpassTag(key: key, value: value)
    }
    
    /**
     Sets a tag to the query as negation tag
     
     - parameter key: A key of the <has-kv> element
     - parameter value: A value which represents negation of the <has-kv> element
     */
    public func hasTag(_ key: String, notEquals value: String) {
        tags[key] = OverpassTag(key: key, value: value, isNegation: true)
    }
    
    public func doesNotHaveTag(_ key: String) {
        tags[key] = OverpassTag(key: key, value: ".", isNegation: true, isRegex: true)
    }
    
    /**
     Sets a tag to the query as regex tag
     
     - parameter key: A key of the <has-kv> element
     - parameter regexString: A regex value of the <has-kv> element
     */
    public func hasRegexTag(_ key: String, equals regexString: String) {
        tags[key] = OverpassTag(key: key, value: regexString, isRegex: true)
    }
    
    /**
     Makes a common <query> element
     */
    public func makeCommonXmlQuery() -> AEXMLElement {
        let query = AEXMLElement(name: "query", attributes: ["type" : type.stringValue])
        
        // Add <has-kv> elements to <query> element as children
        query.addChildren(tags.map { $1.makeHasKvElement() })
        
        // Add <bbox-query> element to <query> element as child
        if let aBbox = boundingBox {
            query.addChild(aBbox.makeBboxQueryElement())
        }
        return query
    }
}
