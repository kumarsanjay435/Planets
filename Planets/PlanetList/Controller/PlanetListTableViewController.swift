//
//  PlanetListTableViewController.swift
//  Planets
//
//  Created by Sanjay Kumar on 07/01/19.
//  Copyright © 2019 Sanjay Kumar. All rights reserved.
//

import UIKit

class PlanetListTableViewController: UITableViewController {
    
    lazy var loaderIndicator:UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        loader.style = .gray
        self.view.addSubview(loader)
        return loader
    }()
    
    var feedArray:[Planet] = [Planet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        fetchFeeds()
    }
    
    
    /// Base UI Preparation
    func prepareUI() {
        self.navigationItem.title = "Planets"
        loaderIndicator.translatesAutoresizingMaskIntoConstraints = false
        loaderIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loaderIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.view.bringSubviewToFront(self.loaderIndicator)
    }
    
    
    /// Fetch feed from DB or Cloud
    func fetchFeeds() {
        do {
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            self.feedArray = try appdelegate?.persistentContainer.viewContext.fetch(Planet.fetchRequest()) ?? [Planet]()
            if self.feedArray.isEmpty {
                callService() // FirstTimeLoad
            }else{
                callService(withLoader: false) // Syncing
            }
        } catch  {
            fatalError("Fetching Error")
        }
        
        DatabaseService.shared.refreshTableView = { [weak self] planets in
            self?.feedArray = planets
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    /// Get API Service
    ///
    /// - Parameter loader: shoe loader
    func callService(withLoader loader:Bool = true) {
        if loader {
            loaderIndicator.startAnimating()
        }
        NetworkService().getPlanets(with: EndPoint.listPlanets) { [weak self] results in
            if loader {
                DispatchQueue.main.async { [weak self] in
                    self?.loaderIndicator.stopAnimating()
                }
            }
            switch results {
            case .success(let feed):
                
                feed.forEach { planetviewmodel in
                   DatabaseService.shared.storePlanet(with: planetviewmodel)
                }
                break
                
            case .error(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}




// MARK: - Table view data source
extension PlanetListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanetCell.kReusableIdentifier, for: indexPath) as! PlanetCell
        let currentFeed = feedArray[indexPath.row]
        cell.updateDisplay(with: currentFeed)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlanetCell.kHeight
    }
}
