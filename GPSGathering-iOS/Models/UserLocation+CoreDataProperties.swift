//
//  UserLocation+CoreDataProperties.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//
//

import Foundation
import CoreData


extension UserLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserLocation> {
        return NSFetchRequest<UserLocation>(entityName: "UserLocation")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var time: String?

}

extension UserLocation : Identifiable {

}
