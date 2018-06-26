//
//  RelationReferable.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 6/26/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public protocol RelationReferable {
    func relation() -> RelationQuery
}

extension RelationReferable where Self: OverpassQuery {
    public func relation() -> RelationQuery {
        let relation = RelationQuery(parent: self)
        return relation
    }
}
