//
//  Document+ManagedObject.swift
//  Texty
//
//  Created by Kai Aldag on 2020-04-04.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import CoreData
import TextyKit

extension Document {
    func makeEntity(inContext context: NSManagedObjectContext) -> DocumentModel {
        let documentEntity = NSEntityDescription.insertNewObject(forEntityName: Constants.CoreData.DocumentsModel,
                                                           into: context)

        let documentModel = DocumentModel(entity: documentEntity.entity,
                                          insertInto: context)

        documentModel.setValuesForKeys(metaData.toDict())

        pages.forEach { page in
            let pageEntity = NSEntityDescription.insertNewObject(forEntityName: Constants.CoreData.PageModel,
                                                                 into: context)

            let pageModel = PageModel(entity: pageEntity.entity, insertInto: context)
            pageModel.setValuesForKeys(page.toDict())
            pageModel.setValue(documentModel, forKey: "document")
        }


        return documentModel
    }
}
