//
//  BoudingBox.swift
//  SwiftOverpass
//
//  Created by Sho Kamei on 2017/12/03.
//  Copyright © 2017年 Sho Kamei. All rights reserved.
//

import Foundation
import MapKit
import AEXML

/// Represents a Bouding box
public struct BoudingBox {
    
    // MARK: - Properties
    
    /// Lowest latitude
    let s: Double
    /// Lowest longitude
    let n: Double
    /// Highest latitude
    let w: Double
    /// Highest longitude
    let e: Double
    
    /**
     Creates a bbox from coordinates
     
     - parameter s: Lowest latitude
     - parameter n: Lowest longitude
     - parameter w: Highest latitude
     - parameter e: Highest longitude
     */
    public init(s: Double, n: Double, w: Double, e: Double) {
        self.s = s
        self.n = n
        self.w = w
        self.e = e
    }
    
    /**
     Creates a bbox from `MKMapView`
     */
    public init(mapView: MKMapView) {
        let span: MKCoordinateSpan = mapView.region.span
        let center: CLLocationCoordinate2D = mapView.region.center
        
        // This is the farthest Lat point to the left
        s = center.latitude - span.latitudeDelta * 0.5
        // This is the farthest Lat point to the Right
        n = center.latitude + span.latitudeDelta * 0.5
        // This is the farthest Long point in the Upward direction
        w = center.longitude - span.longitudeDelta * 0.5
        // This is the farthest Long point in the Downward direction
        e = center.longitude + span.longitudeDelta * 0.5
    }
    
    internal func makeBboxQueryElement() -> AEXMLElement {
        return AEXMLElement(name: "bbox-query", attributes: ["s" : "\(s)", "n" : "\(n)", "w" : "\(w)", "e" : "\(e)"])
    }
}
