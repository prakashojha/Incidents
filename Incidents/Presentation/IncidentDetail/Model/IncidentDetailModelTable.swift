//
//  IncidentDetailModel.swift
//  Incidents
//
//  Created by bindu.ojha on 17/10/22.
//

import Foundation

//MARK: Model for Detail views
struct IncidentDetailModelTable{
    var contentTile: String?
    var contentDescription:  String?
}

struct IncidentDetailModelMap{
    var latitude: Double?
    var longitude:  Double?
    var image: Data?
    var title: String?
}

struct IncidentDetailModel{
    var incidentDetailModelTable: [IncidentDetailModelTable] = []
    var incidentDetailModelMap: IncidentDetailModelMap = IncidentDetailModelMap()
    var mapDirectionIcon = "arrow.triangle.turn.up.right.diamond.fill"
    var cellIdentifier = "IncidentDetailCellView"
    var numberOfRowsInSection = 5
    var numberOfSections = 1
    var annotationViewIdentifier = "AnnotationViewIdentifier"
}
