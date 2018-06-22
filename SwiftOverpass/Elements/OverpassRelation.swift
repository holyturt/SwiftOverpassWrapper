//
//  OverpassRelation.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

/// An OpenStreetMap element that consists of one or more tags and also an ordered list of one or more nodes,
/// ways and/or relations as members which is used to define logical or geographic relationships between other elements.
/// See: https://wiki.openstreetmap.org/wiki/Relation
public final class OverpassRelation: OverpassElement {
    
    // MARK: - Constants
    
    /// Represents a <member> element
    public struct Member: Equatable {
        let type: OverpassQueryType
        let id: Int
        let role: String?
    }
    
    // MARK: - Properties
    
    /// List of member the relation has
    public let members: [Member]?
    
    /// An object that is used to look up related elements that were received with the same response.
    private weak var responseElementProvider: OverpassResponseElementsProviding?
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassRelation`
    */
    internal init(id: Int,
                  tags: [String : String],
                  meta: Meta?,
                  members: [Member]?,
                  responseElementProvider: OverpassResponseElementsProviding?) {
        self.members = members
        self.responseElementProvider = responseElementProvider
        
        super.init(id: id, tags: tags, meta: meta)
    }
    
    // MARK: - Public
    
    /**
     Returns nodes that related to the relation after load from response
     */
    public func loadRelatedNodes() -> [OverpassNode]? {
        if let allNodes = responseElementProvider?.nodes, let members = members {
            let nodeIds = members.filter { $0.type == .node }
                .map { $0.id }
            
            var filtered = [OverpassNode]()
            nodeIds.forEach { id in
                if let index = allNodes.index(where: { $0.id == id }) {
                    filtered.append(allNodes[index])
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
     Return ways that related to the relation after load from response
    */
    public func loadRelatedWays() -> [OverpassWay]? {
        if let allWays = responseElementProvider?.ways, let members = members {
            let wayIds = members.filter { $0.type == .way }
                .map { $0.id }
            
            var filtered = [OverpassWay]()
            wayIds.forEach { id in
                if let index = allWays.index(where: { $0.id == id }) {
                    filtered.append(allWays[index])
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
     Return another relations that related to the relation after load from response
    */
    public func loadRelatedRelations() -> [OverpassRelation]? {
        if let allRels = responseElementProvider?.relations, let members = members {
            let relIds = members.filter { $0.type == .relation }
                .map { $0.id }
            
            var filtered = [OverpassRelation]()
            relIds.forEach { id in
                if let index = allRels.index(where: { $0.id == id }) {
                    filtered.append(allRels[index])
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
}
