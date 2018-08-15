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
    /// Specifies the query is node
    case node
    /// Specifies the query is way
    case way
    /// Specifies the query is relation
    case relation
    
    /// The string to creat a XML line.
    public var stringValue: String {
        switch self {
        case .node:
            return "node"
        case .way:
            return "way"
        case .relation:
            return "relation"
        }
    }
}

/**
*/
public protocol OverpassQuery: class {
    var type: OverpassQueryType { get }
    var parent: OverpassQuery? { get }
    var tags: [String: OverpassTag] { get set }
    var boundingBox: BoudingBox? { get set }
}

extension OverpassQuery {
    
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
    
    /**
     Marks a tag as not being supposed to contain an arbitary value.
     
     - parameter key: A key of the <has-kv> element
     */
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
}
