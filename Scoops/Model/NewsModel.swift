//
//  NewsModel.swift
//  Scoops
//
//  Created by Vicente de Miguel on 24/2/16.
//  Copyright © 2016 Vicente de Miguel. All rights reserved.
//

import Foundation
import CoreLocation

struct NewsModel {
    var titulo : String
    var texto : String
    var autor : String
    var estado: String
    var valoracion : Float
    //var foto :
    var localizacion : CLLocationCoordinate2D
    
    init(titulo: String, texto: String, autor: String, estado: String, valoracion:Float, localizacion:CLLocationCoordinate2D) {
        self.titulo = titulo
        self.texto = texto
        self.autor = autor
        self.estado = estado
        self.valoracion = valoracion
        self.localizacion = localizacion
        
    }
    
}
