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
    enum CoreDataError: Error {
        case fetchFailed
    }

    private var persistentContainer: NSPersistentContainer
    private var managedObjectContext: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: Constants.DocumentsModel)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        guard let modelURL = Bundle.main.url(forResource: Constants.DocumentsModel, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc

        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent(Constants.DocumentsModel + ".sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }

    func loadDocumentMetadatas(completion: ([Document.MetaData]) -> Void) {
        let managedContext = persistentContainer.viewContext

        let documentsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DocumentsModel)

        do {

            guard let fetched = try managedContext.fetch(documentsFetch) as? [NSManagedObject] else {
                throw CoreDataError.fetchFailed
            }

            let fetchedDicts = fetched.map { (managedObject) -> [String: Any] in
                return managedObject.committedValues(forKeys: Document.propertyKeys)
            }

            let metaDatas = fetchedDicts.compactMap({ (dict) -> Document.MetaData? in
                return try? Document.MetaData.fromDict(dict: dict)
            })
            completion(metaDatas)
        } catch let error {
            print(error)
        }
    }

    func loadDocumentPages(completion: ([Document.Page]) -> Void) {

    }

    mutating func loadDocuments(completion: ([Document]) -> Void) {

    }

    mutating func save(document: Document) {
        let managedContext = persistentContainer.viewContext

        let documentEntity = NSEntityDescription.insertNewObject(forEntityName: Constants.DocumentsModel,
                                                           into: managedContext)

        let metadataDict = document.metaData.toDict()

        documentEntity.setValuesForKeys(metadataDict)
        do {
            try managedContext.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
