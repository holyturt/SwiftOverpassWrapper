//
//  XCTestCase+XMLFromFile.swift
//  SwiftOverpassTests
//
//  Created by Wolfgang Timme on 5/17/18.
//  Copyright © 2018 Sho Kamei. All rights reserved.
//

import XCTest

import AEXML

extension XCTestCase {
    
    func xmlRootElementInFile(_ name: String) -> AEXMLElement? {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: "xml") else {
            return nil
        }
        
        let rootElement: AEXMLElement?
        do {
            let data = try Data(contentsOf: fileURL)
            let xmlDocument = try AEXMLDocument(xml: data)
            
            rootElement = xmlDocument.root
        } catch {
            rootElement = nil
        }
        
        return rootElement
    }
    
}
