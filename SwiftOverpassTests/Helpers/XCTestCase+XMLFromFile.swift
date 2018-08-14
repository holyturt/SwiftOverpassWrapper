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
    
    /// Attempts to read the file contents of the XML file with the given name into a String.
    ///
    /// - Parameter name: The name of the file to read.
    /// - Returns: The content of the file as a String. Defaults to an empty String if an error occurs.
    func stringFromXMLFile(_ name: String) -> String {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: "xml") else {
            return ""
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            let fileContentsAsString = String.init(data: data,
                                                   encoding: .utf8)
            
            return fileContentsAsString ?? ""
        } catch {
            return ""
        }
    }
    
    func xmlRootElementInFile(_ name: String) -> AEXMLElement? {
        let fileContentsAsString = stringFromXMLFile(name)
        
        let rootElement: AEXMLElement?
        do {
            let xmlDocument = try AEXMLDocument(xml: fileContentsAsString)
            
            rootElement = xmlDocument.root
        } catch {
            rootElement = nil
        }
        
        return rootElement
    }
    
}
