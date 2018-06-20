//
//  OverpassEntity.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/16/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public class OverpassEntity {
    
    public struct Meta {
        public let version: Int
        public let changesetId: Int
        public let timestamp: String
        public let userId: Int
        public let username: String
    }

    /// The id of the entity
    public let id: String
    
    /// List of tag the entity has
    public let tags: [String: String]
    
    public let meta: Meta?
    
    public init(id: String, tags: [String: String], meta: Meta? = nil) {
        self.id = id
        self.tags = tags
        self.meta = meta
    }
    
}
