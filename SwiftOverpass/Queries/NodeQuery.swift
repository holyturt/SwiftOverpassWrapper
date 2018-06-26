//
//  NodeQuery.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation

/**
 Class for creating node query
 */
public final class NodeQuery: OverpassQuery, WayReferable, RelationReferable {
    
    // MARK: OverpassQuery
    
    public var type: OverpassQueryType = .node
    public private(set) weak var parent: OverpassQuery?
    public var tags: [String : OverpassTag] = [:]
    public var boundingBox: BoudingBox?
    
    public init(parent: OverpassQuery? = nil) {
        self.parent = parent
    }
}
