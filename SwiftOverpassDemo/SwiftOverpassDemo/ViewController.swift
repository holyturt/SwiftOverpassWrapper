//
//  ViewController.swift
//  SwiftOverpassDemo
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import UIKit
import SwiftOverpass

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let node = NodeQuery()
        node.hasTag("name", equals: "Schloss Neuschwanstein")
        let rel = node.relation()
        
        SwiftOverpass.api(endpoint: "http://overpass-api.de/api/interpreter")
            .fetch([node, rel]) { (response) in
                print(response.requestQuery)
                print(response.xml)
        }
    }

    override func loadView() {
        super.loadView()
    }


}

