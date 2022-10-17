//
//  IncidentDomainRepoInterface.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

/* Any Entity wish to provide data to domain must implement this interface. Adopted and confirmed by Data layer */

protocol IncidentDomainRepoInterface {
    func getIncidents(handler: @escaping ([IncidentEntity])->Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?)->Void)
}
