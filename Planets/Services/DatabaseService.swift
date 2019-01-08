//
//  DatabaseService.swift
//  Planets
//
//  Created by Sanjay Kumar on 08/01/19.
//  Copyright © 2019 Sanjay Kumar. All rights reserved.
//

import Foundation
import CoreData
import UIKit


/// Core Data Manager service
class DatabaseService {
    static let shared = DatabaseService()
    var delegate:AppDelegate!
    var refreshTableView:(([Planet]) -> ())!
    private init() {}
   
    
    /// Persitant Store CO-Ordinator MOC
    lazy var writerMOC:NSManagedObjectContext = {
        let wmoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        DispatchQueue.main.async { [weak self] in
            self?.delegate = UIApplication.shared.delegate as? AppDelegate
            wmoc.persistentStoreCoordinator = self?.delegate.persistentContainer.persistentStoreCoordinator
        }
        return wmoc
    }()
    
    
    /// Reading MOC
    lazy var mainContext:NSManagedObjectContext = {
        let mc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mc.parent = self.writerMOC
    //    mc.automaticallyMergesChangesFromParent = true
        return mc
    }()
    
    
    /// Thread Handling Temporary MOC
    lazy var  tempMOC:NSManagedObjectContext = {
        let tmoc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        tmoc.parent = mainContext
        return tmoc
    }()
    
    
    /// Create Entity For Planet
    ///
    /// - Parameter feedViewModel: PlanetViewModel
    func storePlanet(with feedViewModel:PlanetViewModel) {
    
        let planet:Planet = Planet(context: tempMOC)
        planet.name = feedViewModel.name
        planet.period = feedViewModel.period
        planet.terrain = feedViewModel.terrain
        
        // Create
        tempMOC.perform { [weak self] in
            do {
                try self?.tempMOC.save()
                
                // Read
                self?.mainContext.perform {
                    
                    do {
                        let array:[Planet] = try self?.mainContext.fetch(Planet.fetchRequest()) ?? [Planet]()
                        
                        self?.refreshTableView(array)
                        try self?.mainContext.save()
                        
                        // Push to DB
                        self?.writerMOC.perform({
                            do {
                                try self?.writerMOC.save()
                            }catch {
                                fatalError("\(error)")
                            }
                        })
                    } catch  {
                        fatalError("Fetching Error \(error.localizedDescription)")
                    }
                }
            }catch{
                fatalError("tempContextNot Saved")
            }
        }
    }
}

