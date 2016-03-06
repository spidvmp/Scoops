//
//  Position.swift
//  MyCar
//
//  Created by Vicente de Miguel on 18/12/15.
//  Copyright © 2015 Nicatec Software. All rights reserved.
//

import UIKit
import CoreLocation


/*
pintar la ruta en el mapa
http://stackoverflow.com/questions/28723490/display-route-on-map-in-swift
http://studyswift.blogspot.com.es/2014/10/mkdirections-draw-route-from-location.html
*/

/*

esto lo utilizo en otra app, he quitado lo que no necesito para esta, lo mismo se me queda algo que no necesito al igual que los comentarios

*/

class Position : NSObject , CLLocationManagerDelegate {
    
    //genero un deelgado con el controlador para que le envie los cambios de ubicacion
    var delegate: MyLocationManagerDelegate? = nil
    
    var myPosition : CLLocation? = nil

    //defino el locstionManager
    private var locationManager: CLLocationManager!
    
  
    class var sharedInstance : Position {
        struct Static {
            static let instance : Position = Position()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
    }
    


    //MARK: - Manipulacion de GPS
    
    func getPosition() {
        
        // App might be unreliable if someone changes autoupdate status in between and stops it
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let Device = UIDevice.currentDevice()
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        let iOS8 = iosVersion >= 8
        if iOS8{
            
            locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
            locationManager.requestWhenInUseAuthorization() // add in plist NSLocationWhenInUseUsageDescription
        }
        //Accedo a la posicion
        self.locationManager.startUpdatingLocation()
        //hago que saque posiciones y lo paro en unos 6 segundos
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(6 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.locationManager.stopUpdatingLocation()

            //si tengo delegate, le paso los parametros que tengo
            if ((self.delegate != nil) && (self.delegate?.respondsToSelector(Selector("newLocationFound:")))!){
                //si peta aqui, pon unalocalizacion en el simulador
                self.delegate?.newLocationFound(self.myPosition!)
            }
            

        }
        
    }
    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        let arrayOfLocation = locations as NSArray
        //guardo mi posicion
        //currentPosition = arrayOfLocation.lastObject as? CLLocation
        //saco la posicion del coche
        myPosition = arrayOfLocation.lastObject as? CLLocation
        print(myPosition)

    }

    internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //print("Error en GPS ",error.description)
        //comunico al controlador que no hay conexiond e GPS, posiblemente esta en un garage
        self.locationManager.stopUpdatingLocation()
        if ((self.delegate != nil) && (self.delegate?.respondsToSelector(Selector("locationManagerFail")))!){
            self.delegate?.locationManagerFail()
        }
    }
    

}

//MARK: - Protocolo comunicacion con el controlador
protocol MyLocationManagerDelegate : NSObjectProtocol
{
    //cuando tengo la ubicacion definida
    func newLocationFound(location: CLLocation)
    //cuando uso la brujula y tengo nuevo angulo
    //func newHeadingFound(location : CLLocation, angle : Float)
    //en caso de que no tengamos coordenadas xq no funciona GPS por el motivo que sea
    func locationManagerFail()
    
}

    