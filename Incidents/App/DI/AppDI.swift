//
//  AppDI.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

class AppDI{
    
    let environment: AppEnvironment
    
    init(environment: AppEnvironment){
        self.environment = environment
    }
    
    static let shared = AppDI(environment: AppEnvironment())
    
    
    func incidentListDependencies() -> IncidentListViewModel {
        let incidentListDI: IncidentListDI = IncidentListDI(environment: environment)
        let incidentListViewModel = incidentListDI.dependencies()
        return incidentListViewModel
    }
    
    func incidentDetailDependencies()->IncidentDetailViewModel{
        return IncidentDetailViewModel(model: IncidentDetailModel())
    }
    
}
