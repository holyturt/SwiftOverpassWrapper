//
//  NodeQuery.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation
import AEXML

/**
 Class for creating <query type="node"> or <recurse type="***-node"> element
 */
public final class NodeQuery: OverpassQuery {
    
    // MARK: - Properties
    
    /// The type of the query
    public fileprivate(set) var type: OverpassQueryType = .node
    /// The parent query of the query
    public fileprivate(set) weak var parent: OverpassQuery?
    /// List of tag. Defaults to empty
    public var tags: [String : OverpassTag] = [String: OverpassTag]()
    /// The bouding box to filter
    public var boundingBox: BoudingBox?
    
    // MARK: - Initializers
    
    /**
     Creates a `NodeQuery`
     */
    internal init(parent: OverpassQuery? = nil) {
        self.parent = parent
    }
    
    // MARK: - Public
    
    /**
     Makes a <recurse> element as `AEXMLElement`
     */
    public func makeRecurseElement() -> AEXMLElement {
        var typeValue: String!
        
        switch parent!.type {
        case .way:
            typeValue = "way-node"
        case .relation:
            typeValue = "relation-node"
        default:
            // TODO: inform some errors
            break
        }
        
        return AEXMLElement(name: "recurse", attributes: ["type" : typeValue])
    }
    
    /**
     Makes a <query> element of the query
     */
    public func makeXmlQuery() -> AEXMLElement {
        return makeCommonXmlQuery()
    }
}
