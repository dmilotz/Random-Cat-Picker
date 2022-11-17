//
//  RandomCat.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import Foundation
import RealmSwift

//public enum ImageType: String {
//    case gif, jpeg, png, unknown
//}

class RandomCat: Object, Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageUrl = "url"
    }
    
    static let error = RandomCat(
      id: "error",
      imageUrl: "error"
    )
    
    public var catImageUrl: URL? {
        RandomCatApi.baseUrl.appending(path: self.imageUrl)
    }
  
    @Persisted var id: String
    @Persisted var imageUrl: String
    
    override init() {
        super.init()
    }
    
    init(id: String, imageUrl: String) {
        self.id = id
        self.imageUrl = imageUrl
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
}
