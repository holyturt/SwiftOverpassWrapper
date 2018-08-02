//
//  SwiftOverpass.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation
import AEXML
import Alamofire

/**
 Class that manages this library
 */
public final class SwiftOverpass: NSObject {
    
    /**
     Creates a `OverpassApi`
     
     - parameter endpoint: URL of the Overpass api server
     - parameter timeout: Time to wait between tries
     - parameter elementLimit: Max number of output
    */
    public static func api(endpoint: String, timeout: Int? = nil, elementLimit: Int? = nil) -> OverpassApi {
        return OverpassApi(endpoint: endpoint, timeout: timeout, elementLimit: elementLimit)
    }
}

/**
 Class for fetching data from Overpass api server
 */
public final class OverpassApi {
    
    // MARK: - Closures
    
    public typealias CompletionClosure = (OverpassResponse) -> Void
    
    // MARK: - Constants
    
    /// Represents types of Verbosities
    public enum OutputVerbosity {
        case
            /// The normal print mode
            body,
            /// The skeleton print mode is somewhat shorter than the usual print mode:
            /// No tags are printed in this mode, only ids, child elements, and coordinates of nodes
            skeleton,
            /// ds_only is the shortest print mode; only ids are printed
            idsOnly,
            /// meta is the most complete mode
            meta
        
        /// The string to creat a XML attribute.
        public var stringValue: String {
            return OutputVerbosity.stringMapping[self]!
        }
        
        fileprivate static let stringMapping = [
            body: "body",
            skeleton: "skeleton",
            idsOnly: "ids_only",
            meta: "meta"
        ]
    }
    
    /// Represents types of order
    public enum OutputOrder {
        case
            /// To be ordered by their location
            qt,
            /// To be ordered by their id
            id
        
        /// The string to creat a XML attribute.
        public var stringValue: String {
            return OutputOrder.stringMapping[self]!
        }
        
        fileprivate static let stringMapping = [
            qt: "quadtile",
            id: "id"
        ]
    }
    
    // MARK: - Properties
    
    /// The endpoint to access
    public fileprivate(set) var endpoint: String
    /// The time to wait between tries
    public fileprivate(set) var timeout: Int?
    /// Max number of output (m)
    public fileprivate(set) var elementLimit: Int?
    
    // MARK: - Initializers
    
    /**
     Creates a `OverpassApi`
     
     - parameter endpoint: URL of the Overpass server
     - parameter timeout: Time to wait between tries (m)
     - parameter elementLimit: Max number of output
     */
    internal init(endpoint: String, timeout: Int? = nil, elementLimit: Int? = nil) {
        self.endpoint = endpoint
        self.timeout = timeout
        self.elementLimit = elementLimit
    }
    
    // MARK: - Public
    
    /**
     Fetches from Overpass API
     
     - parameter queries: List of query
     - parameter verbosity: Degrees of verbosity. Defaults to `.body`
     - parameter order: Order of output. `.qt` is faster.
     - parameter completion: A completion handler.
     */
    public func fetch(_ queries: [OverpassQuery], verbosity: OutputVerbosity? = nil, order: OutputOrder? = nil, completion: @escaping CompletionClosure) {
        let builder = XMLQueryBuilder(queries: queries, verbosity: verbosity, order: order, timeout: timeout, elementLimit: elementLimit)
        
        let parameters: [String : String] = ["data" : builder.makeQuery()]
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8"
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString { (response) in
            completion(OverpassResponse(response: response, requestQuery: builder.makeQuery()))
        }
    }
    
    /**
     Fetches from Overpass API
     
     - parameter query: A query to get data
     - parameter verbosity: Degrees of verbosity. Defaults to `.body`
     - parameter order: Order of output. `.qt` is faster.
     - parameter completion: A completion handler.
    */
    public func fetch(_ query: OverpassQuery, verbosity: OutputVerbosity? = nil, order: OutputOrder? = nil, completion: @escaping CompletionClosure) {
        fetch([query], verbosity: verbosity, order: order, completion: completion)
    }
    
}
