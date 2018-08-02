//
//  QueryBuilder.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 6/26/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import Foundation

public protocol QueryBuilder {
    func makeQuery() -> String
}
