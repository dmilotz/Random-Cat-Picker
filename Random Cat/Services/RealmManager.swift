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
    
    @Published var cats: [RandomCat] = []
    
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
            print("Error opening Realm", error)
        }
    }
    
    func addCat(newCat: RandomCat, imageToBeAdded: UIImage?) {
        guard let image = imageToBeAdded else {
            print("Error, no image found!")
            return
        }
        
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(newCat)
                    writeImageData(from: newCat, image: image)
                }
            } catch {
                print("Error adding cat to Realm", error)
            }
        }
    }
    
    func getCats() {
        if let localRealm = localRealm {
            let allCats = localRealm.objects(RandomCat.self)
            allCats.forEach { cat in
                    cats.append(cat)
            }
        }
    }
    
    func writeImageData(from cat: RandomCat, image: UIImage){
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let url = documents.appendingPathComponent(cat.id)
        print(url)

        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Image Data to Disk")
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
                print("Error loading image : \(error)")
            }
            return nil
    }
}
