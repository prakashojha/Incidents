//
//  IncidentModel.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

// Model for data retrieved from remote server.

struct IncidentDataModel: Codable{
    var title: String?
    var callTime: String?
    var lastUpdated: String?
    var id: String?
    var latitude: Double?
    var longitude: Double?
    var description: String?
    var location: String?
    var status: String?
    var type: String?
    var image: String?
    
    // Its job of the Data layer to provide Domain with expected data
    func getIncidentEntity() -> IncidentEntity {
        return IncidentEntity(title: title, callTime: callTime, lastUpdated: lastUpdated, id: id,
                              latitude: latitude, longitude: longitude, description: description,
                              location: location, status: status, type: type, image: image)
    }
}

extension IncidentDataModel{
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case callTime = "callTime"
        case lastUpdated = "lastUpdated"
        case id = "id"
        case latitude = "latitude"
        case longitude = "longitude"
        case description = "description"
        case location = "location"
        case status = "status"
        case type = "type"
        case image = "typeIcon"
        
    }
}
