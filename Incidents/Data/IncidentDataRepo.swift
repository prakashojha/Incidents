//
//  IncidentDataRepo.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation


/* Interface exposed by Domain layer.-> IncidentRemoteDataSourceInterface. Data layer implements interface to provide data to the Domain layer
 Act as a bridge between Data and Domain layer*/

class IncidentDataRepo: IncidentDomainRepoInterface{
    
    /// Used to make network call.
    let incidentRemoteDataSource: IncidentRemoteDataSourceInterface 
    
    init(incidentRemoteDataSource: IncidentRemoteDataSourceInterface){
        self.incidentRemoteDataSource = incidentRemoteDataSource
    }
    
    
    func getIncidents(handler: @escaping ([IncidentEntity]) -> Void) {
        self.incidentRemoteDataSource.getIncidents { result in
            switch(result){
            case .success(let incidentModelArray):
                var incidentEntity: [IncidentEntity] = []
                incidentModelArray.forEach { model in
                    incidentEntity.append(model.getIncidentEntity())
                }
                handler(incidentEntity)
                
            case .failure(let error):
                print(error.localizedDescription)
                handler([])
            }
        }
    }
    
    
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?) -> Void) {
        self.incidentRemoteDataSource.getIncidentImage(imageUrl: imageUrl) { result in
            switch(result){
            case .success(let data):
                handler(data)
            case .failure(let error):
                print(error.localizedDescription)
                handler(nil)
            }
        }
    }
}
