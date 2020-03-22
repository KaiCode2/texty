//
//  PersistenceInteractor.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import TextyKit
import CoreData

struct PersistenceInteractor {

    lazy var persistentContainer: NSPersistentContainer = {
     let container = NSPersistentContainer(name: Constants.DocumentsModel)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    mutating func loadDocuments(completion: ([Document]) -> Void) {
        let managedContext = persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: Constants.DocumentObject,
                                     in: managedContext)!

        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: Constants.DocumentObject)

        do {
            let documents = try managedContext.fetch(fetchRequest)
            completion(convertToDocuments(documents: documents))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

//        person.setValue(name, forKeyPath: "name")

//        do {
//          try managedContext.save()
//          people.append(person)
//        } catch let error as NSError {
//          print("Could not save. \(error), \(error.userInfo)")
//        }
    }

    mutating func save(document: Document) {
        let managedContext = persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: Constants.DocumentObject,
                                       in: managedContext)!

        let documents = NSManagedObject(entity: entity,
                                        insertInto: managedContext)

        let dictDocument = document.toDict()

        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    private func convertToDocuments(documents: [NSManagedObject]) -> [Document] {
        return documents.compactMap { (managedObject) -> Document? in
            guard managedObject.description == Constants.DocumentObject else { return nil }

            let atrributes = managedObject.committedValues(forKeys: Document.propertyKey)
            return try? Document.fromDict(dict: atrributes)
        }
    }
}
