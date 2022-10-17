//
//  IncidentRemoteDataSource.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import Foundation

enum NetworkError: Error{
    case InvalidUrl
    case NoDataFound
    case DecodingIssue
}

extension NetworkError: LocalizedError{
    var errorDescription: String?{
        switch(self){
        case .InvalidUrl: return "Invalid URL string"
        case .NoDataFound: return "Data not available"
        case .DecodingIssue: return "Issue found while decoding data to respective format"
        }
    }
}


// Protocol requirement for any entity fetching data form Remote.
protocol IncidentRemoteDataSourceInterface {
    init(urlString: String, urlSession: URLSession)
    func getIncidents(handler: @escaping (Result<[IncidentDataModel], Error>) -> Void)
    func getIncidentImage(imageUrl: String, handler: @escaping (Result<Data?, Error>) -> Void)
}


/*
 An implementation of abstract network service. Used by data layer to make network call
 */
class IncidentRemoteDataSource: IncidentRemoteDataSourceInterface {
    
    private let urlString: String
    private var urlSession: URLSession
    
    required init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    /// Retrieve Incident data from API call
    /// - Parameter handler: Return data in required format. ->`IncidentDataModel`
    func getIncidents(handler: @escaping (Result<[IncidentDataModel], Error>) -> Void) {
        guard let url = URL(string: self.urlString) else{
            print("INVALID URL")
            handler(.failure(NetworkError.InvalidUrl))
            return
        }
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                handler(.failure(NetworkError.NoDataFound))
                return
            }
            guard let model = try? JSONDecoder().decode([IncidentDataModel].self, from: data) else {
                handler(.failure(NetworkError.DecodingIssue))
                return
            }
            handler(.success(model))
        }
        dataTask.resume()
    }
    
    /// Fetch image from server
    func getIncidentImage(imageUrl: String, handler: @escaping (Result<Data?, Error>) -> Void){
        guard let url = URL(string: imageUrl) else {
            handler(.failure(NetworkError.InvalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                handler(.failure(NetworkError.NoDataFound))
                return
            }
            handler(.success(data))
            
        }.resume()
    }
}
