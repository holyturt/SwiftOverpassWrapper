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
    
    /// The response which made the relation
    public fileprivate(set) weak var response: OverpassResponse?
    /// List of member the relation has
    public let members: [Member]?
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassRelation`
    */
    internal init(id: Int, tags: [String : String], meta: Meta?, members: [Member]?, response: OverpassResponse) {
        self.members = members
        self.response = response
        
        super.init(id: id, tags: tags, meta: meta)
    }
    
    // MARK: - Public
    
    /**
     Returns nodes that related to the relation after load from response
     */
    public func loadRelatedNodes() -> [OverpassNode]? {
        if let response = response, let allNodes = response.nodes, let members = members {
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
        if let response = response, let allWays = response.ways, let members = members {
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
        if let response = response, let allRels = response.relations, let members = members {
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
