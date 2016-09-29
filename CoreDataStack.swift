//
//  Copyright © 2015 Big Nerd Ranch
//

import Foundation
import CoreData

class CoreDataStack {
    
    let managedObjectModelName: String
    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL =
        Bundle.main.url(forResource: self.managedObjectModelName,
            withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        }()
    
    fileprivate var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory,
            in: .userDomainMask)
        return urls.first!
        }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        var coordinator =
        NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url =
        self.applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        
        let store = try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
            configurationName: nil,
            at: url,
            options: nil)
        
        return coordinator
        }()
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        return moc
        }()
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    }
    
    func saveChanges() throws {
        var error: Error?
        mainQueueContext.performAndWait() {
            
            if self.mainQueueContext.hasChanges {
                do {
                    try self.mainQueueContext.save()
                }
                catch let saveError {
                    error = saveError
                }
            }
        }
        if let error = error {
            throw error
        }
    }
    
}
