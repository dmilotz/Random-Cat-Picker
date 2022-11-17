//
//  RandomCatService.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import Foundation
import Combine

enum RandomCatApi {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://cataas.com")!
    static let randomCatPath = "/cat"
    static let jsonQuery = URLQueryItem(name: "json", value: "true")
}


enum ApiPath: String {
    case cute = "/cat/cute"
}

extension RandomCatApi {
    
    static func requestRandomCat() -> AnyPublisher<RandomCat, Error> {
  
        guard let components =  URLComponents(url: baseUrl.appendingPathComponent(randomCatPath).appending(queryItems: [jsonQuery]), resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLComponents")
        }
        
        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
