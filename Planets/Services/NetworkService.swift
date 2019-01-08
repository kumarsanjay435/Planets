//
//  NetworkService.swift
//  Planets
//
//  Created by Sanjay Kumar on 07/01/19.
//  Copyright © 2019 Sanjay Kumar. All rights reserved.
//

import Foundation


/// Endpoints for URL
enum EndPoint {
    private static let baseURL = "https://swapi.co/api"
    static let listPlanets = EndPoint.baseURL + "/planets"
}


/// Generic error defined as Enum
///
/// - success: Result
/// - error: Failiure
enum Result<T> {
    case success(T)
    case error(Error)
}



/// Network Servicew as Struct
struct  NetworkService {
    
    
    /// Fetch the Planets response from server and return the response as a closure of PlanetViewModel array type.
    ///
    /// - Parameters:
    ///   - urlString: inputURL
    ///   - callBack: Planet ViewModel Array
    func getPlanets(with urlString:String, completion callBack:@escaping (Result<[PlanetViewModel]>) -> ()) {
        
        let getURL = URL(string: urlString)
        
        URLSession.shared.dataTask(with: getURL!) { (responseData, responseURL, responseError) in
            
            guard let httpResponse = responseURL as? HTTPURLResponse else {
                
                return
            }
            
            switch  httpResponse.statusCode {
            case 200...299:
                
                do{
                    guard let data = responseData else {
                        return
                    }
                    let response:Response = try JSONDecoder().decode(Response.self, from: data)
                    
                    var planetFeedArray = [PlanetViewModel]()
                    response.results?.forEach { feed in
                        let feedViewModel = PlanetViewModel(with: feed)
                        planetFeedArray.append(feedViewModel)
                    }
                    
                    callBack(.success(planetFeedArray))
                    
                }catch {
                    callBack(.error(error))
                }
                
                break
            case 400...499:
                debugPrint("inputError")
                break
            case 500...599:
                debugPrint("ServerSide Error")
                break
            default: break
            }
        }.resume()
        
    }
    
}
