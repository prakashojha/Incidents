//
//  IncidentInteractor.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

/* Presenter(ViewModel) calls this method to execute use cases in Domain layer. */
protocol IncidentInteractorInterface {
    func getIncidents(handler: @escaping ([IncidentEntity]) -> Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?) -> Void)
}

/* Act as bridge between ViewModel and Domain Layer */

class IncidentInteractor: IncidentInteractorInterface {
    
    var incidentDomainRepoInterface: IncidentDomainRepoInterface
    
    init(incidentDomainRepoInterface: IncidentDomainRepoInterface){
        self.incidentDomainRepoInterface = incidentDomainRepoInterface
    }
    
    // Use Case executed by Presenter(ListViewModel)
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
