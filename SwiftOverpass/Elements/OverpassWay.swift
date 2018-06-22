//
//  OverpassWay.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

public final class OverpassWay: OverpassElement {
    
    // MARK: - Properties
    
    /// The response which made the way
    public fileprivate(set) weak var response: OverpassResponse?
    /// List of id of the nodes which belong to the way
    public let nodeIds: [String]?
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassWay`
    */
    internal init(id: String, tags: [String : String], meta: Meta?, nodeIds: [String]?, response: OverpassResponse) {
        self.nodeIds = nodeIds
        self.response = response
        
        super.init(id: id, tags: tags, meta: meta)
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
