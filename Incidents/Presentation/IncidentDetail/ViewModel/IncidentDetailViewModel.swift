//
//  IncidentDetailViewModel.swift
//  Incidents
//
//  Created by bindu.ojha on 16/10/22.
//

import Foundation


//MARK: ViewModel to provide data for IncidentDetailViewController(Secondary in SplitViewController)
class IncidentDetailViewModel{
    
    // Model to get data from. Contains static data as well
    private var incidentDetailModel: IncidentDetailModel
    
    init(model: IncidentDetailModel){
        self.incidentDetailModel = model
    }
    
    var incidentDetailModelTable: [IncidentDetailModelTable]{
        get { return incidentDetailModel.incidentDetailModelTable }
        set { incidentDetailModel.incidentDetailModelTable = newValue}
    }
    
    var incidentDetailModelMap: IncidentDetailModelMap{
        get { return incidentDetailModel.incidentDetailModelMap }
        set { incidentDetailModel.incidentDetailModelMap = newValue }
    }
    
    var mapIconImage: String{
        get { incidentDetailModel.mapDirectionIcon }
    }
    
    var cellIdentifier: String{
        return incidentDetailModel.cellIdentifier
    }
    
    var numberOfRowsInSection: Int{
        return incidentDetailModel.numberOfRowsInSection
    }
    
    var numberOfSections: Int{
        return incidentDetailModel.numberOfSections
    }
    
    var annotationViewIdentifier: String{
        return incidentDetailModel.annotationViewIdentifier
    }
    
    private func removeSpaceFrom(text: String?)->String?{
        var trimmedString: String?
        if let text = text, let subStr = text.components(separatedBy: "-").last{
            trimmedString = subStr.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        }
        return trimmedString
    }
    
    // Detail View contains only 5 row. Every row has different title and description
    func createModelForTable(with data: IncidentCellModel){
        self.incidentDetailModelTable = []
        incidentDetailModelTable.append(createLocationData(from: data))
        incidentDetailModelTable.append(createStatusData(from: data))
        incidentDetailModelTable.append(createType(from: data))
        incidentDetailModelTable.append(createCallTime(from: data))
        incidentDetailModelTable.append(createDescription(from: data))
        
    }
    
    // Data for map is populated separately. Image can take time to load
    func createModelForMap(with data: IncidentCellModel){
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
    
    // Provide data for cell for a table row display view
    func cellForAtRow(index: Int)->IncidentDetailModelTable{
        if index >= 0 && index < incidentDetailModelTable.count {
            return incidentDetailModelTable[index]
        }
        return IncidentDetailModelTable()
    }
    
}
