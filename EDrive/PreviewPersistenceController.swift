//
//  PreviewPersistenceController.swift
//  EDrive
//
//  Created by Andy Yu on 2023/3/29.
//

import CoreData

final class PreviewPersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newTrip = Trip(context: viewContext)
            newTrip.startDate = Date().addingTimeInterval(TimeInterval(-(i * 3600)))
            newTrip.distance = Double.random(in: 1000...10000)
            newTrip.duration = Double.random(in: 1800...7200)
            newTrip.drivingType = DrivingType.allCases.randomElement()!.rawValue
            let locations = try! viewContext.fetch(LocationEntity.fetchRequest())
            let locationsArray = locations as! [LocationEntity]
            newTrip.addToLocations(NSSet(array: Array(locationsArray[i*10...(i+1)*10])))
        }
        try! viewContext.save()
        return result
    }()
}

