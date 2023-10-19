//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Alex Bonder on 10/18/23.
//

import Foundation

class Favorites: ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites.txt"
    
    init() {
        resorts = []
        do {
            let url = getDocumentsDirectory().appendingPathComponent(saveKey)
            let data = try Data(contentsOf: url)
            resorts = try JSONDecoder().decode(Set<String>.self, from: data)
        } catch {
            print("Failed to load favorites: \(error.localizedDescription)")
        }
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        let url = getDocumentsDirectory().appendingPathComponent(saveKey)
        do {
            let data = try JSONEncoder().encode(resorts)
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
