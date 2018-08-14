//
//  OverpassResponseElementsProviding.swift
//  SwiftOverpass
//
//  Created by Wolfgang Timme on 8/14/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

/// Provides the elements that were received with an response.
public protocol OverpassResponseElementsProviding: class {
    /// All node elements that came with the response.
    var nodes: [OverpassNode]? { get }
    
    /// All way elements that came with the response.
    var ways: [OverpassWay]? { get }
    
    /// All relation elements that came with the response.
    var relations: [OverpassRelation]? { get }
}
