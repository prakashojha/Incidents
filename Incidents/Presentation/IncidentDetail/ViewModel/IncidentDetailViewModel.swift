//
//  IncidentDetailViewModel.swift
//  Incidents
//
//  Created by bindu.ojha on 16/10/22.
//

import Foundation



/*
 IncidentCellModel(title: Optional("Ambulance Response - GORDON"), lastUpdateFormatted: Optional("Jul 06, 2022 at 12:47:17 PM"), lastUpdatedDateTime: Optional("2022-07-06T12:47:17"), status: Optional("On Scene"), type: Optional("Ambulance Response"), image: Optional("https://i.imgur.com/MQ189HE.png"))
 */

class IncidentDetailViewModel{
    
    var incidentDetailModelTable: [IncidentDetailModelTable] = []
    var incidentDetailModelMap: IncidentDetailModelMap = IncidentDetailModelMap()
    
    private func removeSpaceFrom(text: String?)->String?{
        var trimmedString: String?
        
        if let text = text, let subStr = text.components(separatedBy: "-").last{
            trimmedString = subStr.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        }
        return trimmedString
    }
    
    func createModelForTable(with data: IncidentCellModel){
        incidentDetailModelTable = []
        incidentDetailModelTable.append(createLocationData(from: data))
        incidentDetailModelTable.append(createStatusData(from: data))
        incidentDetailModelTable.append(createType(from: data))
        incidentDetailModelTable.append(createCallTime(from: data))
        incidentDetailModelTable.append(createDescription(from: data))
        
    }
    
    func createModelForMap(with data: IncidentCellModel){
        //incidentDetailModelMap = nil
        incidentDetailModelMap.latitude = data.latitude
        incidentDetailModelMap.longitude = data.longitude
        incidentDetailModelMap.title =  removeSpaceFrom(text: data.title)
        incidentDetailModelMap.image = data.imageData
    }
    
    func createLocationData(from model: IncidentCellModel)->IncidentDetailModelTable{
        var incidentDetail = IncidentDetailModelTable()
        incidentDetail.contentTile = "Location"
        incidentDetail.contentDescription = removeSpaceFrom(text: model.title)
        
        return incidentDetail
    }
    
    func createStatusData(from model: IncidentCellModel)->IncidentDetailModelTable{
        var incidentDetail = IncidentDetailModelTable()
        incidentDetail.contentTile = "Status"
        incidentDetail.contentDescription = model.status
        
        return incidentDetail
    }
    
    func createType(from model: IncidentCellModel)->IncidentDetailModelTable{
        var incidentDetail = IncidentDetailModelTable()
        incidentDetail.contentTile = "Type"
        incidentDetail.contentDescription = model.type
        
        return incidentDetail
    }
    
    
    func createCallTime(from model: IncidentCellModel)->IncidentDetailModelTable{
        var incidentDetail = IncidentDetailModelTable()
        incidentDetail.contentTile = "Call Time"
        incidentDetail.contentDescription = model.lastUpdateFormatted
        
        return incidentDetail
    }
    
    func createDescription(from model: IncidentCellModel)->IncidentDetailModelTable{
        var incidentDetail = IncidentDetailModelTable()
        incidentDetail.contentTile = "Description"
        incidentDetail.contentDescription = model.description ?? "Not Available"
        
        return incidentDetail
    }
    
    
    func cellForAtRow(index: Int)->IncidentDetailModelTable{
        if index >= 0 && index < incidentDetailModelTable.count {
            return incidentDetailModelTable[index]
        }
        return IncidentDetailModelTable()
    }
    
}
