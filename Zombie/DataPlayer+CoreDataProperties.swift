//
//  DataPlayer+CoreDataProperties.swift
//  Zombie
//
//  Created by William JEHANNE on 11/12/2015.
//  Copyright © 2015 Pierre Kopaczewski. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DataPlayer {

    @NSManaged var name: String?
    @NSManaged var scores: NSSet?

}
