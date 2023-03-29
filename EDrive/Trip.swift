//
//  Trip.swift
//  EDrive
//
//  Created by Andy Yu on 2023/3/29.
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date?
    @NSManaged public var distance: Double
    @NSManaged public var duration: Double
    @NSManaged public var drivingType: Int16
    @NSManaged public var locations: NSSet?
}

extension Trip {
    static func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }
    
    var speed: Double {
        if duration == 0 {
            return 0
        } else {
            return distance / duration
        }
        
        var formattedDistance: String {
            return String(format: "%.2f km", distance / 1000)
        }
        
        var formattedDuration: String {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = .pad
            return formatter.string(from: duration)!
        }
        
        var formattedSpeed: String {
            return String(format: "%.0f km/h", speed * 3.6)
        }
        
        var drivingTypeString: String {
            switch DrivingType(rawValue: drivingType)! {
            case .eco:
                return "Eco"
            case .normal:
                return "Normal"
            case .sport:
                return "Sport"
            }
        }
    }
}

enum DrivingType: Int16, CaseIterable {
    case eco
    case normal
    case sport
}
