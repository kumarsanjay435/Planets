//
//  PlanetModel.swift
//  Planets
//
//  Created by Sanjay Kumar on 07/01/19.
//  Copyright © 2019 Sanjay Kumar. All rights reserved.
//

import Foundation

// Base Response Model
struct PlanetModel:Codable {
    let name:String?
    let rotation_period:String?
    let orbital_period:String?
    let terrain:String?
}

// Get Response Model
struct Response:Codable {
    let count:Int?
    let next:String?
    let previous:String?
    let results:[PlanetModel]?
}


/// PlanetViewModel - Display UI
struct PlanetViewModel {
    var name:String
    var period:String
    var terrain:String
    init(with feedModel:PlanetModel) {
        name = feedModel.name ?? "empty"
        period = "Orbital Period - \(feedModel.orbital_period ?? ""), Rotation Period - \(feedModel.rotation_period ?? "")"
        terrain = feedModel.terrain ?? "No Terrain"
    }
    
}
