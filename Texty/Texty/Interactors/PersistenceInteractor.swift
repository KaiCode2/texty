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

        case unimplemented(String?)
    }

    private var persistentContainer: NSPersistentContainer
    private var managedObjectContext: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: Constants.CoreData.DocumentsModel)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }

        guard let modelURL = Bundle.main.url(forResource: Constants.CoreData.DocumentsModel, withExtension:"momd") else {
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
            let storeURL = docURL.appendingPathComponent(Constants.CoreData.DocumentsModel + ".sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }

    func loadDocumentMetadatas() throws -> [Document.MetaData] {
        let managedContext = persistentContainer.viewContext

        let documentsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.DocumentsModel)

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
            return metaDatas
        } catch let error {
            print(error)
            throw error
        }
    }

    func loadDocumentPages(forDocument metaData: Document.MetaData, maxPagesPerFetch: Int? = nil) throws -> [Document.Page] {
        let managedContext = persistentContainer.viewContext

        let pagesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.PageModel)
        pagesFetch.predicate = NSPredicate(format: "document.id == %@", argumentArray: [metaData.id])

        if let maxPagesPerFetch = maxPagesPerFetch {
            pagesFetch.fetchLimit = maxPagesPerFetch
        }

        do {
            guard let fetched = try managedContext.fetch(pagesFetch) as? [NSManagedObject] else {
                throw CoreDataError.fetchFailed
            }

            let fetchedDicts = fetched.map { (managedObject) -> [String: Any] in
                return managedObject.committedValues(forKeys: Document.Page.propertyKeys)
            }

            let pages = fetchedDicts.compactMap({ (dict) -> Document.Page? in
                return try? Document.Page.fromDict(dict: dict)
            })
            return pages
        } catch let error {
            print(error)
            throw error
        }
    }

    mutating func loadDocuments(withEmptyMetadatas: Bool = false, thresholdForMaxPages: Int? = nil) throws -> [Document] {
        do {
            let metas = try loadDocumentMetadatas()
            var documents: [Document]
            if !withEmptyMetadatas { // load pages
                documents = try metas.map({ (meta) -> Document in
                    let pages = try loadDocumentPages(forDocument: meta, maxPagesPerFetch: thresholdForMaxPages)
                    return Document(pages: pages, metaData: meta)
                })
                return documents
            } else { // return empty pages
                return metas.map { (meta) -> Document in
                    return Document(pages: [], metaData: meta)
                }
            }
        } catch let error {
            throw error
        }
    }

    mutating func save(document: Document) throws {
        let managedContext = persistentContainer.viewContext

        let model = document.makeEntity(inContext: managedContext)

        do {
            try managedContext.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
}
