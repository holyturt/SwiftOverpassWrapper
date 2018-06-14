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

public final class OverpassResponse {
    
    // MARK: - Properties
    
    /// List of output nodes
    public fileprivate(set) var nodes: [OverpassNode]?
    /// List of output ways
    public fileprivate(set) var ways: [OverpassWay]?
    /// List of output relations
    public fileprivate(set) var relations: [OverpassRelation]?
    /// The request query which was used to fetch from api
    public let requestQuery: String
    /// The xml string of output
    public let xml: String
    
    // MARK: Initializers
    
    /**
     Creates a `OverpassResponse`
    */
    internal init(response: DataResponse<String>, requestQuery: String) {
        self.requestQuery = requestQuery
        
        do {
            self.xml = String(data: response.data!, encoding: String.Encoding.utf8)!
            let xmlDoc = try AEXMLDocument(xml: self.xml)
            
            // Parses xml to create `OverpassNode`
            if let nodes = xmlDoc.root["node"].all {
                self.nodes = nodes.compactMap { nodeXMLElement in
                    return OverpassNode(xmlElement: nodeXMLElement, response: self)
                }
            }
            
            // Parses xml to create `OverpassWay`
            if let ways = xmlDoc.root["way"].all {
                self.ways = ways.compactMap { wayXMLElement in
                    return OverpassWay(xmlElement: wayXMLElement, response: self)
                }
            }
            
            // Parses xml to create `OverpassRelation`
            if let rels = xmlDoc.root["relation"].all {
                self.relations = rels.compactMap { relationXMLElement in
                    return OverpassRelation(xmlElement: relationXMLElement, response: self)
                }
            }
        } catch {
            print("\(error)")
        }
    }
}
