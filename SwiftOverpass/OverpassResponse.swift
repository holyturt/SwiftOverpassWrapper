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
                self.ways = ways.map {
                    let id = $0.attributes["id"]!
                    
                    var nodeIds: [String]?
                    if let nodes = $0["nd"].all {
                        nodeIds = nodes.map { $0.attributes["ref"]! }
                    }
                    
                    let tags = getTags($0)
                    
                    return OverpassWay(id: id, nodeIds: nodeIds, tags: tags, response: self)
                }
            }
            
            // Parses xml to create `OverpassRelation`
            if let rels = xmlDoc.root["relation"].all {
                self.relations = rels.map {
                    let id = $0.attributes["id"]!
                    
                    var relMembers: [OverpassRelation.Member]?
                    if let members = $0["member"].all {
                        relMembers = members.map {
                            var type: OverpassQueryType!
                            switch $0.attributes["type"]! {
                            case "node": type = .node
                            case "way": type = .way
                            case "relation": type = .relation
                            default: break // TODO: shouldn't be reach here, throw error
                            }
                            
                            let ref = $0.attributes["ref"]!
                            let role = $0.attributes["role"]
                            return OverpassRelation.Member(type: type, id: ref, role: role)
                        }
                    }
                    
                    let tags = getTags($0)
                    
                    return OverpassRelation(id: id, members: relMembers, tags: tags, response: self)
                }
            }
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: - Private
    
    private func getTags(_ element: AEXMLElement) -> [String : String] {
        var tags = [String : String]()
        if let tagElems = element["tag"].all {
            tagElems.forEach {
                if let k = $0.attributes["k"], let v = $0.attributes["v"] {
                    tags[k] = v
                }
            }
        }
        return tags
    }
}
