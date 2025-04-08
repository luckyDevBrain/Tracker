//
//  TrackerCategoryCoreData.swift
//  Tracker
//
//  Created by Kirill on 08.04.2025.
//

import CoreData
import Foundation

@objc(TrackerCategoryCoreData)
public class TrackerCategoryCoreData: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCategoryCoreData> {
        return NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    }

    @nonobjc class func fetchRecord(for recordID: UUID, context: NSManagedObjectContext) -> TrackerCategoryCoreData? {

        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: ModelConstants.recordForUUIDPredicate,
            #keyPath(TrackerCategoryCoreData.categoryID),
            recordID as NSUUID
        )
        return try? context.fetch(request).first
    }

    @NSManaged public var categoryID: UUID?
    @NSManaged public var name: String?
    @NSManaged public var activeTrackers: NSSet?
}

// MARK: Generated accessors for activeTrackers
extension TrackerCategoryCoreData {

    @objc(addActiveTrackersObject:)
    @NSManaged public func addToActiveTrackers(_ value: TrackerCoreData)

    @objc(removeActiveTrackersObject:)
    @NSManaged public func removeFromActiveTrackers(_ value: TrackerCoreData)

    @objc(addActiveTrackers:)
    @NSManaged public func addToActiveTrackers(_ values: NSSet)

    @objc(removeActiveTrackers:)
    @NSManaged public func removeFromActiveTrackers(_ values: NSSet)
}
