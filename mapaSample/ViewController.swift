//
//  ViewController.swift
//  mapaSample
//
//  Created by Telecomunicaciones Abiertas de México on 2/24/16.
//  Copyright © 2016 Telecomunicaciones Abiertas de México. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    var sumatoria: Double = 0
    var starMark: Bool = false
    var zoom: CLLocationDegrees = 0.0036
    var center = CLLocationCoordinate2D()
    var diferenceStartValue = CLLocation()
    var diferenceEndValue = CLLocation()
    var mapType: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
                mapa.mapType = MKMapType.Satellite
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if(!starMark){
            self.marcar(true, lng: manager.location!.coordinate.longitude, lat: manager.location!.coordinate.latitude, meters: 0)
            diferenceStartValue = CLLocation (latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
            starMark = true
        }
        
        diferenceEndValue = CLLocation (latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        
        center = CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        
        let difern = diferenceStartValue.distanceFromLocation(diferenceEndValue)
        
        if ( difern >= 50 ){
            diferenceStartValue = CLLocation (latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
            self.marcar(false, lng: manager.location!.coordinate.longitude, lat: manager.location!.coordinate.latitude, meters: difern)
        }

        actualizarPosition()
    }
    
    
    func marcar(inicio: Bool, lng: CLLocationDistance, lat: CLLocationDistance, meters: Double){
        
        var punto = CLLocationCoordinate2D()
        punto.latitude = lat
        punto.longitude = lng
        sumatoria += meters
    
        let pin = MKPointAnnotation()
        if(inicio){
            pin.title = "Inico de Recorrido"
            pin.subtitle = "\(sumatoria)"
        } else {
            pin.title = "\(lat), \(lng)"
            pin.subtitle = "\(sumatoria)"
        }
        
        pin.coordinate = punto
        mapa.addAnnotation(pin)
    }
    
    @IBAction func zoomUpdating(sender: UISlider) {
        let zoomPlus = sender.value * sender.value
        zoom = CLLocationDegrees(zoomPlus)
        print("valor: \(zoomPlus)")
        
        actualizarPosition()
    }
    
    @IBAction func startNavigation(sender: AnyObject) {
        manejador.startUpdatingLocation()
        sumatoria = 0
    }

    @IBAction func pararNavigation(sender: AnyObject) {
        manejador.stopUpdatingLocation()
        sumatoria = 0
        starMark = false
    }
    
    func actualizarPosition(){

        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        
        self.mapa.setRegion(region, animated: true)

    }
    
    @IBAction func typeNormal(sender: AnyObject) {
        mapa.mapType = MKMapType.Standard
        print("Standar")
        mapType = 2
    }
    
    @IBAction func typeSatelite(sender: AnyObject) {
        mapa.mapType = MKMapType.Satellite
        print("Satelite")
        mapType = 2
    }
    
    @IBAction func typeHibrido(sender: AnyObject) {
        mapa.mapType = MKMapType.Hybrid
        print("Hibrido")
        mapType = 3
    }

}

