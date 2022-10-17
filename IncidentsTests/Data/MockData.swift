//
//  MockData.swift
//  IncidentsTests
//
//  Created by bindu.ojha on 18/10/22.
//

import Foundation

struct MockData{
    
    static let data1 = """
            {
                "title": "House Fire - WATSON",
                "callTime": "2022-07-06T12:35:12+1000",
                "lastUpdated": "2022-07-06T12:44:10+1000",
                "id": "010017-06072022",
                "latitude": -35.24175205,
                "longitude": 149.15683313,
                "description": "Structure fire - single story\n3 Crews On Scene",
                "location": "DOWLING STREET, WATSON, 2602",
                "status": "On Scene",
                "type": "House Fire",
                "typeIcon": "https://i.imgur.com/IUwhSWJ.png"
            }
    """
    
    static var response: String{
        return data1
    }
}
