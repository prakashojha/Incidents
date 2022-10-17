//
//  IncidentModel.swift
//  Incidents
//
//  Created by bindu.ojha on 15/10/22.
//

import Foundation

//MARK: Model for Primary View Controller
/// Contains data for table row in IncidentListController. Contains additional data to be passed to DetailView
struct IncidentCellModel{
    var title: String?
    var lastUpdateFormatted: String?
    var lastUpdatedDateTime: String?
    var status: String?
    var type: String?
    var imageUrl: String?
    var latitude: Double?
    var longitude: Double?
    var imageData: Data?
    var description: String?
}

