//
//  RealmManager.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/17/22.
//

import Foundation
import RealmSwift
import UIKit

class RealmManager: ObservableObject {
    private var localRealm: Realm?
   
    enum Error {
        case writeError, loadImageError, retrieveDataError
    }
    
    @Published var cats: [RandomCat] = []
    @Published var saveError: Bool = false
    @Published var error: Error?
    
    init() {
        openRealm()
        getCats()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion > 1 {
                    //TODO: handle different schemas
                }
            })

            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            self.error = .writeError
        }
    }
    
    func addCat(newCat: RandomCat, imageToBeAdded: UIImage?) {
        guard let image = imageToBeAdded else {
            error = .writeError
            return
        }
        
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(newCat)
                    writeImageData(from: newCat, image: image)
                }
            } catch {
                self.error = .writeError
            }
        }
    }
    
    func getCats() {
        if let localRealm = localRealm {
            let allCats = localRealm.objects(RandomCat.self)
            allCats.reversed().forEach { cat in
                    cats.append(cat)
            }
        }
    }
    
    func writeImageData(from cat: RandomCat, image: UIImage){
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let url = documents.appendingPathComponent(cat.id)

        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                self.error = .writeError
            }
        }
    }
    
    func getImageData(from cat: RandomCat) -> UIImage? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let url = documents.appendingPathComponent(cat.id)
            do {
                let imageData = try Data(contentsOf: url)
                return UIImage(data: imageData)
            } catch {
                self.error = .loadImageError
            }
            return nil
    }
}
