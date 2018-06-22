//
//  OverpassNode.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

public final class OverpassNode: OverpassElement {
    
    // MARK: - Properties
    
    /// The response which made the node
    public fileprivate(set) weak var response: OverpassResponse?
    /// The latitude of the node
    public let latitude: Double
    /// The longitude of the node
    public let longitude: Double
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassNode`
    */
    internal init(id: String, tags: [String : String], meta: Meta?, lat: Double, lon: Double, response: OverpassResponse) {
        
        self.latitude = lat
        self.longitude = lon
        self.response = response
        
        super.init(id: id, tags: tags, meta: meta)
    }
    
    // MARK: Public
    
    /**
     Returns ways that related to the node after load from response
    */
    public func loadRelatedWays() -> [OverpassWay]? {
        if let response = response, let ways = response.ways {
            let filtered = ways.filter { $0.id == id }
            
            // Returns if it has some ways.
            if filtered.count != 0 {
                return filtered
            }
        }
        
        return nil
    }
    
    /**
     Returns another relations that related to the node after load from response
     */
    public func loadRelatedRelations() -> [OverpassRelation]? {
        if let response = response, let allRels = response.relations {
            var filtered = [OverpassRelation]()
            
            allRels.forEach { relation in
                if let members = relation.members {
                    members.forEach { member in
                        if member.type == .node && member.id == self.id {
                            filtered.append(relation)
                        }
                    }
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
