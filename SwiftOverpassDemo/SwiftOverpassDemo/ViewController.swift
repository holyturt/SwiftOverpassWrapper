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
        
        let query = SwiftOverpass.query(type: .node)
        query.hasTag("name", equals: "Schloss Neuschwanstein")
        
        SwiftOverpass.api(endpoint: "http://overpass-api.de/api/interpreter")
            .fetch([query]) { (response, error) in
                guard nil == error else {
                    print("\(error!)")
                    return
                }
                
                guard let response = response else {
                    print("Failed to process the response.")
                    return
                }
                
                print(response.requestQuery)
                print(response.xml)
        }
    }

    override func loadView() {
        super.loadView()
    }


}

