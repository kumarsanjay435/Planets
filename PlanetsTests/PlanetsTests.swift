//
//  PlanetsTests.swift
//  PlanetsTests
//
//  Created by Sanjay Kumar on 07/01/19.
//  Copyright © 2019 Sanjay Kumar. All rights reserved.
//

import XCTest
@testable import Planets

class PlanetsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModel() {
        //GIVEN
        let model = PlanetModel(name: "Earth", rotation_period: "24", orbital_period: "365", terrain: "North Pole")
        
        // WHEN
        let viewModel = PlanetViewModel(with: model)
        
        // THEN
        XCTAssertEqual(viewModel.period, "Orbital Period - 365, Rotation Period - 24")
    }
    
    func testService() {
        // GIVEN
        NetworkService().getPlanets(with: EndPoint.listPlanets) { (result) in
            // When
            switch result {
                //THEN
            case .success(_):
                XCTAssertTrue(true)
                break
            case .error(_):
                XCTFail()
                break
            }
        }
    }

}
