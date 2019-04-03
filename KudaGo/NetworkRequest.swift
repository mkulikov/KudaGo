//
//  NetworkRequest.swift
//  KudaGo
//
//  Created by mikhail.kulikov on 01/04/2019.
//  Copyright © 2019 mikhail.kulikov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkRequiest {
    
    private let citiesUrl = "https://kudago.com/public-api/v1.4/locations"
    private let eventsUrl = "https://kudago.com/public-api/v1.4/events"
    
    func requiest(url: String, parameters: Parameters? = nil, completion: @escaping (Result<Data>) -> Void) {
        guard let url = URL(string: url) else { return }
        request(url, method: .get, parameters: parameters).validate().responseData { (response) in
            completion(response.result)
        }
    }
    
    func deserialization<T: Decodable>(with type: T.Type,
                                         forward completion: @escaping (Result<T>) -> Void) -> (Result<Data>) -> Void {
        return { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let mappedData = try decoder.decode(type, from: data)
                    completion(.success(mappedData))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCities(completion: @escaping (Result<[City]>) -> Void) {
        requiest(url: citiesUrl, completion: deserialization(with: [City].self, forward: completion))
    }
    
    func getEvents(location: String, completion: @escaping (Result<EventsResponse>) -> Void) {
        let parameters: Parameters = ["location": location, "page_size": 10]
        requiest(url: eventsUrl, parameters: parameters, completion: deserialization(with: EventsResponse.self, forward: completion))
    }

}
