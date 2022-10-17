//
//  Utils.swift
//  Incidents
//
//  Created by bindu.ojha on 14/10/22.
//

import Foundation

class Utils{
    private init() {}
    
    static let shared = Utils()
    
    func getDateTime(from dateTime: String, inFormat: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var formattedString: String = ""
        if let date = formatter.date(from: dateTime) {
            formatter.dateFormat = inFormat
            formattedString = formatter.string(from: date)
        }
        return formattedString
    }
    

    func removeTimeZone(from dateTime: String, withCharacter: Character)->String{
        var dateTimeString: String
        if let timeZoneIndex = dateTime.firstIndex(of: withCharacter){
            let dateTimeSubstring = dateTime[dateTime.startIndex..<timeZoneIndex]
            dateTimeString = String(dateTimeSubstring)
        }
        else{
            dateTimeString = dateTime
        }
        return dateTimeString
    }
    
    
    func formattedDateTime(dateTime: String?)->String{
        guard let dateTime = dateTime else { return " " }
        //let dateTimeString: String = removeTimeZone(from: dateTime, withCharacter: "+")
        let dateString = getDateTime(from: dateTime, inFormat: "MMM dd, yyyy")
        let timeString = getDateTime(from: dateTime, inFormat: "hh:mm:ss a")
        return dateString + " at " + timeString
    }

}


