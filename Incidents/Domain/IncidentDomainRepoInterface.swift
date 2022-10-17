//
//  IncidentDomainRepoInterface.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

protocol IncidentDomainRepoInterface {
    func getIncidents(handler: @escaping ([IncidentEntity])->Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?)->Void)
}
