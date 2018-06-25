//
//  OverpassResponseElementProviderMock.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 6/23/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

import SwiftOverpass

class OverpassResponseElementsProviderMock: OverpassResponseElementsProviding {
    var nodes: [OverpassNode]?
    var ways: [OverpassWay]?
    var relations: [OverpassRelation]?
}
