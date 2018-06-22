//
//  OverpassElement.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 5/16/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

/// The basic components of OpenStreetMap's conceptual data model of the physical world.
/// See: https://wiki.openstreetmap.org/wiki/Elements
public class OverpassElement {
    
    public struct Meta {
        public let version: Int
        public let changesetId: Int
        public let timestamp: String
        public let userId: Int
        public let username: String
    }

    /// The id of the element
    public let id: String
    
    /// List of tag the element has
    public let tags: [String: String]
    
    public let meta: Meta?
    
    public init(id: String, tags: [String: String], meta: Meta? = nil) {
        self.id = id
        self.tags = tags
        self.meta = meta
    }
    
}
