//
//  LocationEntity.swift
//  EDrive
//
//  Created by Andy Yu on 2023/3/29.
//

import Foundation
import CoreData

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date
    @NSManaged public var trip: Trip?
}

extension LocationEntity {
    static func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }
}
