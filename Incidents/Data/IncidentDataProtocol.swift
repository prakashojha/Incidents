//
//  IncidentDataProtocol.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

protocol IncidentRemoteDataSourceInterface {
    
    init(urlString: String)
    func getIncidents(handler: @escaping ([IncidentDataModel]) -> Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?) -> Void)
}
