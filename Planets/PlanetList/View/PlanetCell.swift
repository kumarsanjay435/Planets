//
//  PlanetCell.swift
//  Planets
//
//  Created by Sanjay Kumar on 07/01/19.
//  Copyright © 2019 Sanjay Kumar. All rights reserved.
//

import UIKit

class PlanetCell: UITableViewCell {
    
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var labelRotation:UILabel!
    @IBOutlet weak var labelTerrain:UILabel!
    
    
    /// Planet Cell Display
    ///
    /// - Parameter feed: Planet informations
    func updateDisplay(with feed:Planet) {
        labelName.text = feed.name
        labelRotation.text = feed.period
        labelTerrain.text = feed.terrain
    }

}

extension PlanetCell {
    static let kHeight:CGFloat = 80.0
    
    static let kReusableIdentifier = "planetcell"
}
