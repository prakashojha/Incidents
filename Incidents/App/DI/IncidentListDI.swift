//
//  IncidentDI.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

class IncidentListDI {
    
    let environment: AppEnvironment
    
    init(environment: AppEnvironment){
        self.environment = environment
    }
    
    // Manage Dependencies
    func dependencies()->IncidentListViewModel {
        let baseUrl = environment.baseURL
        let incidentRemoteDataSource = IncidentRemoteDataSource(urlString: baseUrl)
        let incidentDataRepo = IncidentDataRepo(incidentRemoteDataSource: incidentRemoteDataSource)
        let incidentInteractor = IncidentInteractor(incidentDomainRepoInterface: incidentDataRepo)
        return IncidentListViewModel(model: IncidentListModel(), incidentInteractor: incidentInteractor)
    }
}
