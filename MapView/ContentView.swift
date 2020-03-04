//
//  ContentView.swift
//  MapView
//
//  Created by Chris Eidhof on 03.03.20.
//  Copyright © 2020 Chris Eidhof. All rights reserved.
//

import SwiftUI
import MapKit
import UIKit

extension MKPointAnnotation {
    convenience init(coordinate: CLLocationCoordinate2D, title: String) {
        self.init()
        self.coordinate = coordinate
        self.title = title
    }
}

let placemarks: [MKPointAnnotation] = [
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.187240, longitude: 13.088585), title: "Gasthaus Haveleck"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.179984, longitude: 12.899209), title: "Hotel & Ferienanlage Precise Resort Marina Wolfsbruch"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 52.966637,longitude: 13.281789),  title: "Pension Lindenhof"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.091639, longitude: 13.093251), title: "Gut Zernikow"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.031421, longitude: 13.30988),  title: "Ziegeleipark Mildenberg"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.112691, longitude: 13.104139), title: "Hotel und Restaurant \"Zum Birkenhof\""),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.167976, longitude: 13.23558),  title: "Campingpark Himmelpfort"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.115591, longitude: 12.889571), title: "Maritim Hafenhotel Reinsberg"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.175714, longitude: 13.232601), title: "Ferienwohnung in der Mühle Himmelpfort"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.115685, longitude: 13.25494),  title: "Gut Boltenhof"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.053821, longitude: 13.083495), title: "Werkshof Wolfsruh"),
    MKPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.191610, longitude: 13.159954), title: "Jugendherberge Ravensbrück"),
].shuffled()

extension MKMapRect {
    static let laufpark = MKMapRect(origin:
        MKMapPoint(x: 143758507.60971117, y: 86968700.835495561),
            size: MKMapSize(width: 437860.61378830671, height: 749836.27541357279))
}

extension MKPointAnnotation {
    static func <(lhs: MKPointAnnotation, rhs: MKPointAnnotation) -> Bool {
        lhs.coordinate.latitude < rhs.coordinate.latitude
    }
}

struct MapView: UIViewRepresentable {
    var placemarks: [MKPointAnnotation]
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let v = MKMapView()
        v.visibleMapRect = .laufpark
        return v
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let existing = mapView.annotations.compactMap { $0 as? MKPointAnnotation }.sorted(by: <)
        let diff = placemarks.sorted(by: <).difference(from: existing) { $0 === $1 }
        for change in diff {
            switch change {
            case .insert(_, let element, _): mapView.addAnnotation(element)
            case .remove(_, let element, _): mapView.removeAnnotation(element)
            }
        }
    }
}

struct ContentView: View {
    @State var count = 0
    var body: some View {
        VStack {
            MapView(placemarks: Array(placemarks.prefix(count)))
            Stepper("Count \(count)", value: $count)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
