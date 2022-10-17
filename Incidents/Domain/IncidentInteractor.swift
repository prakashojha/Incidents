//
//  IncidentInteractor.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

protocol IncidentInteractorInterface {
        
    func getIncidents(handler: @escaping ([IncidentEntity]) -> Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?) -> Void)
}


class IncidentInteractor: IncidentInteractorInterface {
    
    var incidentDomainRepoInterface: IncidentDomainRepoInterface
    
    init(incidentDomainRepoInterface: IncidentDomainRepoInterface){
        self.incidentDomainRepoInterface = incidentDomainRepoInterface
    }
    
    // Use Case executed by Presenter(ViewModel)
    func getIncidents(handler: @escaping ([IncidentEntity]) -> Void) {
        incidentDomainRepoInterface.getIncidents(handler: { (incidentEntities) in
            handler(incidentEntities)
        })
    }
    
    
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?) -> Void) {
        incidentDomainRepoInterface.getIncidentImage(imageUrl: imageUrl, handler: { (data) in
            handler(data)
        })
    }
}
