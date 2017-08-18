//
//  FavoriteManager.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-18.
//  Copyright © 2017 Kemin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteManager: NSObject {

    static let sharedInstance = FavoriteManager()
    private var managedContext: NSManagedObjectContext?
    
    override init() {
        super.init()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    func save(business: Business) {
        guard let managedContext = managedContext, !alreadyInFavoriteFor(business: business) else {
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "BusinessEntity",
                                       in: managedContext)!
        let businessObject = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        businessObject.setValue(business.name, forKeyPath: "name")
        businessObject.setValue(business.id, forKeyPath: "id")
        businessObject.setValue(business.imageUrl, forKeyPath: "imageURL")
        businessObject.setValue(business.address.streetName, forKeyPath: "street")
        businessObject.setValue(business.address.cityName, forKeyPath: "city")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func remove(business: Business) {
        guard let managedContext = managedContext, let id = business.id else {
            return
        }
        let fetchRequest: NSFetchRequest<BusinessEntity> = BusinessEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        do {
            let fetchedBusiness = try managedContext.fetch(fetchRequest)
            for item in fetchedBusiness {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllFavorites() -> [Business] {
        guard let managedContext = managedContext else {
            return []
        }
        let fetchRequest: NSFetchRequest<BusinessEntity> = BusinessEntity.fetchRequest()
        var businesses = [Business]()
        do {
            let fetchedBusinesses = try managedContext.fetch(fetchRequest)
            for fetchedBusiness in fetchedBusinesses {
                businesses.append(Business().getObjectFrom(entity: fetchedBusiness))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return businesses
    }
    
    func alreadyInFavoriteFor(business: Business) -> Bool {
        guard let managedContext = managedContext, let id = business.id else {
            return false
        }
        let fetchRequest: NSFetchRequest<BusinessEntity> = BusinessEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        do {
            let fetchedBusiness = try managedContext.fetch(fetchRequest)
            return fetchedBusiness.count > 0
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}
