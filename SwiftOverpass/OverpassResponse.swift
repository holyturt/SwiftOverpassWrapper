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

public enum OverpassResponseError: Error {
    case parsingFailed(query: String, xml: String, underlyingError: Error)
}

public final class OverpassResponse: OverpassResponseElementsProviding {
    
    // MARK: Initializers
    
    public init(xml: String, requestQuery: String) throws {
        
        let xmlDoc: AEXMLDocument
        do {
            xmlDoc = try AEXMLDocument(xml: xml)
        } catch {
            throw OverpassResponseError.parsingFailed(query: requestQuery,
                                                      xml: xml,
                                                      underlyingError: error)
        }
        
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
    }
    
    /**
     Creates a `OverpassResponse`
    */
    internal convenience init(response: DataResponse<String>, requestQuery: String) throws {
        let xml = String(data: response.data!, encoding: String.Encoding.utf8)!
        
        try self.init(xml: xml, requestQuery: requestQuery)
    }
    
    // MARK: OverpassResponseElementsProviding
    
    public private(set) var nodes: [OverpassNode]?
    public private(set) var ways: [OverpassWay]?
    public private(set) var relations: [OverpassRelation]?
}
