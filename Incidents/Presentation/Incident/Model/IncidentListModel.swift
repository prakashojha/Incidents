//
//  IncidentListModel.swift
//  Incidents
//
//  Created by bindu.ojha on 15/10/22.
//

import Foundation

struct IncidentListModel{
    
    var isSortAscending: Bool = false
    var incidents: [IncidentEntity] = []
    /// Used while searching
    var searchIncidentList: [IncidentCellModel] = []
    var incidentList: [IncidentCellModel] = []
    
    var numberOfSections: Int = 1
    var numberOfRowsInSection: Int = 1
    var heightForRowAt: Float = 100
    
    var dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss"
}
