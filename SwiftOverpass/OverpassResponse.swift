//
//  OverpassResponse.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation
import Alamofire
import AEXML

/// Provides the elements that were received with an response.
public protocol OverpassResponseElementsProviding: class {
    /// All node elements that came with the response.
    var nodes: [OverpassNode]? { get }
    
    /// All way elements that came with the response.
    var ways: [OverpassWay]? { get }
    
    /// All relation elements that came with the response.
    var relations: [OverpassRelation]? { get }
}

public final class OverpassResponse: OverpassResponseElementsProviding {
    
    // MARK: - Properties
    
    /// The request query which was used to fetch from api
    public let requestQuery: String
    /// The xml string of output
    public let xml: String
    
    // MARK: Initializers
    
    public init(xml: String, requestQuery: String) {
        self.xml = xml
        self.requestQuery = requestQuery
        
        do {
            let xmlDoc = try AEXMLDocument(xml: self.xml)
            
            // Parses xml to create `OverpassNode`
            if let nodes = xmlDoc.root["node"].all {
                self.nodes = nodes.compactMap { nodeXMLElement in
                    return OverpassNode(xmlElement: nodeXMLElement, responseElementProvider: self)
                }
            }
            
            // Parses xml to create `OverpassWay`
            if let ways = xmlDoc.root["way"].all {
                self.ways = ways.compactMap { wayXMLElement in
                    return OverpassWay(xmlElement: wayXMLElement, responseElementProvider: self)
                }
            }
            
            // Parses xml to create `OverpassRelation`
            if let rels = xmlDoc.root["relation"].all {
                self.relations = rels.compactMap { relationXMLElement in
                    return OverpassRelation(xmlElement: relationXMLElement, responseElementProvider: self)
                }
            }
        } catch {
            print("\(error)")
        }
    }
    
    /**
     Creates a `OverpassResponse`
    */
    internal convenience init(response: DataResponse<String>, requestQuery: String) {
        let xml = String(data: response.data!, encoding: String.Encoding.utf8)!
        
        self.init(xml: xml, requestQuery: requestQuery)
    }
    
    // MARK: OverpassResponseElementsProviding
    
    public private(set) var nodes: [OverpassNode]?
    public private(set) var ways: [OverpassWay]?
    public private(set) var relations: [OverpassRelation]?
}
