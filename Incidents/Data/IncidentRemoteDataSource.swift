//
//  IncidentRemoteDataSource.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

class IncidentRemoteDataSource: IncidentRemoteDataSourceInterface {
    
    let urlString: String
    
    required init(urlString: String) {
        self.urlString = urlString
    }
    
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
            //print(model)
            handler(model)
        }
        task.resume()
    }
    
    /// Fetch image from server and store in local cache. Make network call only when image is not found in local cache
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
