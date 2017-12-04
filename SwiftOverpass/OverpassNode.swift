//
//  OverpassNode.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

public final class OverpassNode {
    
    // MARK: - Properties
    
    /// The response which made the node
    public fileprivate(set) weak var response: OverpassResponse?
    /// List of tag the node has
    public let tags :[String : String]
    /// The id of the node
    public let id: String
    /// The latitude of the node
    public let latitude: Double
    /// The longitude of the node
    public let longitude: Double
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassNode`
    */
    internal init(id: String, lat: Double, lon: Double, tags: [String : String], response: OverpassResponse) {
        self.id = id
        self.latitude = lat
        self.longitude = lon
        self.tags = tags
        self.response = response
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
            if filtered.count != 0 {
                return filtered
            }
        }
        
        return nil
    }
}
