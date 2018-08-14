//
//  OverpassWay.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

/// An ordered list of nodes which normally also has at least one tag or is included within a `OverpassRelation`.
/// See: https://wiki.openstreetmap.org/wiki/Way
public final class OverpassWay: OverpassElement {
    
    // MARK: - Properties
    
    /// List of id of the nodes which belong to the way
    public let nodeIds: [Int]
    
    /// An object that is used to look up related elements that were received with the same response.
    private weak var responseElementProvider: OverpassResponseElementsProviding?
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassWay`
    */
    public init(id: Int,
                  tags: [String : String],
                  meta: Meta?,
                  nodeIds: [Int] = [],
                  responseElementProvider: OverpassResponseElementsProviding?) {
        self.nodeIds = nodeIds
        self.responseElementProvider = responseElementProvider
        
        super.init(id: id, tags: tags, meta: meta)
    }
    
    // MARK: - Public
    
    /**
     Returns nodes that related to the way after load from response
    */
    public func loadRelatedNodes() -> [OverpassNode]? {
        if let nodes = responseElementProvider?.nodes {
            
            var filtered = [OverpassNode]()
            nodeIds.forEach { id in
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
        if let allRels = responseElementProvider?.relations {
            var filtered = [OverpassRelation]()
            
            allRels.forEach { relation in
                relation.members.forEach { member in
                    if member.type == .way && member.id == self.id {
                        filtered.append(relation)
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
