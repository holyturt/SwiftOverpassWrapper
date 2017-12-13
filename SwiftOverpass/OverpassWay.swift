//
//  OverpassWay.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

public final class OverpassWay {
    
    // MARK: - Properties
    
    /// The response which made the way
    public fileprivate(set) weak var response: OverpassResponse?
    /// The id of the way
    public let id: String
    /// List of id of the nodes which belong to the way
    public let nodeIds: [String]?
    /// List of tag the node has
    public let tags: [String : String]
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassWay`
    */
    internal init(id: String, nodeIds: [String]?, tags: [String : String], response: OverpassResponse) {
        self.id = id
        self.nodeIds = nodeIds
        self.tags = tags
        self.response = response
    }
    
    // MARK: - Public
    
    /**
     Returns nodes that related to the way after load from response
    */
    public func loadRelatedNodes() -> [OverpassNode]? {
        if let response = response, let nodes = response.nodes, let ids = nodeIds {
            
            var filtered = [OverpassNode]()
            ids.forEach { id in
                if let index = nodes.index(where: { $0.id == id }) {
                    filtered.append(nodes[index])
                    return
                }
            }

            // Returns if it has some nodes.
            if filtered.count > 0 {
                return filtered
            }
        }
        
        return nil
    }
    
    /**
     Returns another relations that related to the way after load from response
     */
    public func loadRelatedRelations() -> [OverpassRelation]? {
        if let response = response, let allRels = response.relations {
            var filtered = [OverpassRelation]()
            
            allRels.forEach { relation in
                if let members = relation.members {
                    members.forEach { member in
                        if member.type == .way && member.id == self.id {
                            filtered.append(relation)
                        }
                    }
                }
            }
            
            // Returns if it has some nodes.
            if filtered.count != 0 {
                return filtered
            }
        }
        
        return nil
    }
}
