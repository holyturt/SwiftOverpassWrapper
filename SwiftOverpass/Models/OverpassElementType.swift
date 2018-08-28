//
//  OverpassElementType.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 8/23/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public enum ElementType: String {
    /// Specifies the member is a node
    case node
    /// Specifies the member is a way
    case way
    /// Specifies the member is a relation
    case relation
}
