//
//  NodeReferable.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 6/26/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public protocol NodeReferable {
    func node() -> NodeQuery
}

extension NodeReferable where Self: OverpassQuery {
    public func node() -> NodeQuery {
        let node = NodeQuery(parent: self)
        return node
    }
}
