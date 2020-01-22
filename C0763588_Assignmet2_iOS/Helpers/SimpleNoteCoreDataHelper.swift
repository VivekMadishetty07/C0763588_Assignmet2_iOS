//
//  SimpleNoteCoreDataHelper.swift
//  C0763588_Assignmet2_iOS
//
//  Created by Vivek Madishetty on 2020-01-21.
//  Copyright © 2020 Vivek Madishetty. All rights reserved.
//

import Foundation
import CoreData

class SimpleNoteCoreDataHelper {
    
     private(set) static var count: Int = 0
        
        static func createNoteInCoreData(
            noteToBeCreated:          Zotes,
            intoManagedObjectContext: NSManagedObjectContext) {
            
            // Let’s create an entity and new note record
            let noteEntity = NSEntityDescription.entity(
                forEntityName: "Note",
                in:            intoManagedObjectContext)!
            
            let newNoteToBeCreated = NSManagedObject(
                entity:     noteEntity,
                insertInto: intoManagedObjectContext)

            newNoteToBeCreated.setValue(
                noteToBeCreated.noteId,
                forKey: "noteId")
            
            newNoteToBeCreated.setValue(
                noteToBeCreated.noteTitle,
                forKey: "noteTitle")
            
            newNoteToBeCreated.setValue(
                noteToBeCreated.noteText,
                forKey: "noteText")
            
            newNoteToBeCreated.setValue(
                noteToBeCreated.noteTimeStamp,
                forKey: "noteTimeStamp")
            
            newNoteToBeCreated.setValue(
                       noteToBeCreated.dayworked,
                       forKey: "dayworked")
            
            newNoteToBeCreated.setValue(
                       noteToBeCreated.totalday,
                       forKey: "totalday")
            
            do {
                try intoManagedObjectContext.save()
                count += 1
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        static func changeNoteInCoreData(
            noteToBeChanged:        Zotes,
            inManagedObjectContext: NSManagedObjectContext) {
            
            // read managed object
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            let noteIdPredicate = NSPredicate(format: "noteId = %@", noteToBeChanged.noteId as CVarArg)
            
            fetchRequest.predicate = noteIdPredicate
            
            do {
                let fetchedNotesFromCoreData = try inManagedObjectContext.fetch(fetchRequest)
                let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
                
                // make the changes
                noteManagedObjectToBeChanged.setValue(
                    noteToBeChanged.noteTitle,
                    forKey: "noteTitle")

                noteManagedObjectToBeChanged.setValue(
                    noteToBeChanged.noteText,
                    forKey: "noteText")

                noteManagedObjectToBeChanged.setValue(
                    noteToBeChanged.noteTimeStamp,
                    forKey: "noteTimeStamp")
                
                noteManagedObjectToBeChanged.setValue(
                               noteToBeChanged.dayworked,
                               forKey: "dayworked")
                
                noteManagedObjectToBeChanged.setValue(
                               noteToBeChanged.totalday,
                               forKey: "totalday")

                // save
                try inManagedObjectContext.save()

            } catch let error as NSError {
                // TODO error handling
                print("Could not change. \(error), \(error.userInfo)")
            }
        }
        
    static func readNotesFromCoreDataa(fromManagedObjectContext: NSManagedObjectContext) -> [Zotes] {

        var returnedNotes = [Zotes]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                returnedNotes.append(Zotes.init(
                    noteId:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64,
                    dayworked: noteManagedObjectRead.value(forKey: "dayworked") as! Int64,
                    totalday: noteManagedObjectRead.value(forKey: "totalday") as! Int64))
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }
        
        // set note count
        self.count = returnedNotes.count
        
        return returnedNotes
    }
        
        
        static func readNoteFromCoreData(
            noteIdToBeRead:           UUID,
            fromManagedObjectContext: NSManagedObjectContext) -> Zotes? {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            let noteIdPredicate = NSPredicate(format: "noteId = %@", noteIdToBeRead as CVarArg)
            
            fetchRequest.predicate = noteIdPredicate
            
            do {
                let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
                let noteManagedObjectToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
                return Zotes.init(
                    noteId:        noteManagedObjectToBeRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectToBeRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectToBeRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectToBeRead.value(forKey: "noteTimeStamp") as! Int64,
                    dayworked: noteManagedObjectToBeRead.value(forKey: "dayworked") as! Int64,
                    
                    totalday: noteManagedObjectToBeRead.value(forKey: "totalday") as! Int64)
            } catch let error as NSError {
                // TODO error handling
                print("Could not read. \(error), \(error.userInfo)")
                return nil
            }
        }

        static func deleteNotesFromCoreData(
            noteIdToBeDeleted:        UUID,
            fromManagedObjectContext: NSManagedObjectContext) {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            let noteIdAsCVarArg: CVarArg = noteIdToBeDeleted as CVarArg
            let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdAsCVarArg)
            
            fetchRequest.predicate = noteIdPredicate
            
            do {
                let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
                let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
                fromManagedObjectContext.delete(noteManagedObjectToBeDeleted)
                
                do {
                    try fromManagedObjectContext.save()
                    self.count -= 1
                } catch let error as NSError {
                    // TODO error handling
                    print("Could not save. \(error), \(error.userInfo)")
                }
            } catch let error as NSError {
                // TODO error handling
                print("Could not delete. \(error), \(error.userInfo)")
            }
            
        }

    }

