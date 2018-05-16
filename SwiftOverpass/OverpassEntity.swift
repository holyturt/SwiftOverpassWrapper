//
//  OverpassEntity.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/16/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public class OverpassEntity {

    /// The id of the entity
    public let id: String
    
    /// List of tag the entity has
    public let tags: [String: String]
    
    public init(id: String, tags: [String: String]) {
        self.id = id
        self.tags = tags
    }
    
}
