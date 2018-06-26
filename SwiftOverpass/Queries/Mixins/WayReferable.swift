//
//  WayReferable.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 6/26/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public protocol WayReferable {
    func way() -> WayQuery
}

extension WayReferable where Self: OverpassQuery {
    public func way() -> WayQuery {
        let way = WayQuery(parent: self)
        return way
    }
}
