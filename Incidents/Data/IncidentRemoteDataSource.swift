//
//  IncidentRemoteDataSource.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation


// Protocol requirement for any entity fetching data form Remote.
protocol IncidentRemoteDataSourceInterface {
    init(urlString: String)
    func getIncidents(handler: @escaping ([IncidentDataModel]) -> Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?) -> Void)
}


/*
 An implementation of abstract network service. Used by data layer to make network call
 */
class IncidentRemoteDataSource: IncidentRemoteDataSourceInterface {
    
    let urlString: String
    
    required init(urlString: String) {
        self.urlString = urlString
    }
    
    
    /// Retrieve Incident data from API call
    /// - Parameter handler: Return data in required format. ->`IncidentDataModel`
    func getIncidents(handler: @escaping ([IncidentDataModel]) -> Void) {
        guard let url = URL(string: self.urlString) else{
            handler([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                handler([])
                return
            }
            
            guard let model = try? JSONDecoder().decode([IncidentDataModel].self, from: data) else {
                handler([])
                return
            }
            handler(model)
        }
        task.resume()
    }
    
    /// Fetch image from server 
    func getIncidentImage(imageUrl : String, handler completion: @escaping (Data?)->Void){
        guard let url = URL(string: imageUrl) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            
            completion(data)
            
        }.resume()
        
    }
}
