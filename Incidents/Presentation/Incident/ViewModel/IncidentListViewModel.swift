//
//  IncidentViewModel.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

// MARK: Provide data and business logic to view controller 
class IncidentListViewModel{
    private let cachedImage = NSCache<NSString, NSData>()
    private var model: IncidentListModel
    private let incidentInteractor: IncidentInteractorInterface
    
    var onLoadData: (()->Void)?
    
    
    init(model: IncidentListModel, incidentInteractor: IncidentInteractorInterface){
        self.incidentInteractor = incidentInteractor
        self.model = model
    }
    
    private var isSortAscending: Bool{
        get { return model.isSortAscending}
        set { model.isSortAscending = newValue}
    }
    
    private var incidentList: [IncidentCellModel] {
        get { return model.incidentList }
        set {
            model.incidentList = newValue
            onLoadData?()
        }
    }
    
    private var incidents: [IncidentEntity]{
        get {return model.incidents }
        set { model.incidents = newValue }
    }
    
    private var searchIncidentList: [IncidentCellModel] {
        get { return model.searchIncidentList }
        set { model.searchIncidentList = newValue }
    }
    
    var numberOfSection: Int{
        get { model.numberOfSections }
    }
    
    var numberOfRowsInSection: Int{
        return model.incidentList.count
    }
    
    var heightForRowAt: Float{
        return model.heightForRowAt //Float(100)
    }
    
    var cellIdentifier: String{
        return model.cellIdentifier
    }
    
    var navigationTitle: String{
        return model.navigationTitle
    }
    
    var sortButtonImage: String{
        return model.sortButtonImage
    }
    
    func cellForAtRow(index: Int)->IncidentCellModel{
        if index >= 0 && index < model.incidentList.count{
            return model.incidentList[index]
        }
        return IncidentCellModel()
    }
    
    func prepareDataForDelegate(at index: Int)->IncidentCellModel{
        let selectedCellData = cellForAtRow(index: index)
        return selectedCellData
    }
    
    private func createIncidentCell(with incident: IncidentEntity)->IncidentCellModel{
        var cellModel = IncidentCellModel()
        let dateTime = Utils.shared.removeTimeZone(from: incident.lastUpdated!, withCharacter: "+")
        cellModel.title = incident.title
        cellModel.lastUpdateFormatted = Utils.shared.formattedDateTime(dateTime: dateTime)
        cellModel.lastUpdatedDateTime = Utils.shared.getDateTime(from: dateTime, inFormat: "YYYY-MM-dd") + "T" + Utils.shared.getDateTime(from: dateTime, inFormat: "hh:mm:ss")
        cellModel.status = incident.status
        cellModel.type = incident.type
        cellModel.imageUrl = incident.image
        cellModel.latitude = incident.latitude
        cellModel.longitude = incident.longitude
        cellModel.description = incident.description
        
        return cellModel
    }
    
    private func createIncidentList(with incidents: [IncidentEntity])->[IncidentCellModel]{
        var incidentCellArray: [IncidentCellModel] = []
        incidents.forEach { incident in
            let cellModel = createIncidentCell(with: incident)
            incidentCellArray.append(cellModel)
        }
        return incidentCellArray
    }
    
    ///  Populate array with incident data. By default data is stored in ascending order.
    func getIncidents(){
        incidentInteractor.getIncidents { [weak self] (incidentEntities) in
            if var incidentList = self?.createIncidentList(with: incidentEntities){
                self?.sortAscending(list: &incidentList)
                self?.incidentList = incidentList
                self?.incidents = incidentEntities
                self?.searchIncidentList = self!.incidentList
            }
        }
    }
    
    /// Empty incident tables and cached data
    func refreshData(){
        cachedImage.removeAllObjects()
        self.incidents = []
        self.searchIncidentList = []
        self.incidentList = []
    }
    
    /// Try to  get image data from cache. If not available,  then make network request and store it in cache .
    func getIncidentImage(imageUrl: String, handler: @escaping (Data?)->Void){
        if let imageData = getImageDataFromCache(imageUrl: imageUrl){
            handler(imageData)
        }
        else{
            incidentInteractor.getIncidentImage(imageUrl: imageUrl) { data in
                guard let data = data else {
                    handler(nil)
                    return
                }
                self.storeImageDataInCache(data: data, imageUrl: imageUrl)
                handler(data)
            }
        }
    }
    
    func getImageDataFromCache(imageUrl: String)->Data?{
        return cachedImage.object(forKey: NSString(string: imageUrl)) as? Data
    }
    
    func storeImageDataInCache(data: Data, imageUrl: String){
        self.cachedImage.setObject(data as NSData, forKey: NSString(string: imageUrl))
    }
    
    private func sortAscending(list: inout [IncidentCellModel]){
        let df = DateFormatter()
        df.dateFormat = model.dateFormat
        list.sort{
            df.date(from: $0.lastUpdatedDateTime!)! < df.date(from: $1.lastUpdatedDateTime!)!
        }
    }
    
    private func sortDescending(list: inout [IncidentCellModel]){
        let df = DateFormatter()
        df.dateFormat = model.dateFormat
        list.sort{
            df.date(from: $0.lastUpdatedDateTime!)! > df.date(from: $1.lastUpdatedDateTime!)!
        }
    }
    
    func sort(){
        if !incidentList.isEmpty{
            isSortAscending == true ? sortAscending(list: &incidentList) : sortDescending(list: &incidentList)
            isSortAscending = !isSortAscending
        }
    }
    
    func updateSearchResults(with sortItem: String){
        if !searchIncidentList.isEmpty{
            self.incidentList = searchIncidentList.filter({ item in
                return item.status!.hasPrefix(sortItem)
            })
        }
    }
    
}
