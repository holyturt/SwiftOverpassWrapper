//
//  OverpassNode.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

/// An OpenStreetMap element that consists of a single point in space defined by its latitude, longitude and node id.
/// See: https://wiki.openstreetmap.org/wiki/Node
public final class OverpassNode: OverpassElement {
    
    // MARK: - Properties
    
    /// The latitude of the node
    public let latitude: Double
    /// The longitude of the node
    public let longitude: Double
    
    /// An object that is used to look up related elements that were received with the same response.
    private weak var responseElementProvider: OverpassResponseElementsProviding?
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassNode`
    */
    public init(id: Int,
                tags: [String : String],
                meta: Meta?,
                lat: Double,
                lon: Double,
                responseElementProvider: OverpassResponseElementsProviding?) {
        
        self.latitude = lat
        self.longitude = lon
        self.responseElementProvider = responseElementProvider
        
        super.init(id: id, tags: tags, meta: meta)
    }
    
    // MARK: Public
    
    /**
     Returns ways that related to the node after load from response
    */
    public func loadRelatedWays() -> [OverpassWay]? {
        if let ways = responseElementProvider?.ways {
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
        if let allRels = responseElementProvider?.relations {
            var filtered = [OverpassRelation]()
            
            allRels.forEach { relation in
                relation.members.forEach { member in
                    if member.type == .node && member.id == self.id {
                        filtered.append(relation)
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
