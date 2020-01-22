//
//  SimpleNoteStorage.swift
//  C0763588_Assignmet2_iOS
//
//  Created by Vivek Madishetty on 2020-01-21.
//  Copyright © 2020 Vivek Madishetty. All rights reserved.
//

import CoreData
class SimpleNoteStorage {
        static let storage : SimpleNoteStorage = SimpleNoteStorage()
        
        private var noteIndexToIdDict : [Int:UUID] = [:]
        private var currentIndex : Int = 0

        private(set) var managedObjectContext : NSManagedObjectContext
        private var managedContextHasBeenSet : Bool = false
        
        private init() {
            // we need to init our ManagedObjectContext
            // This will be overwritten when setManagedContext is called from the view controller.
            managedObjectContext = NSManagedObjectContext(
                concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        }
        
        
        
        func createNote(noteToBeAdded: Zotes) {
            if managedContextHasBeenSet {
                // add note UUID to the dictionary
                noteIndexToIdDict[currentIndex] = noteToBeAdded.noteId
                SimpleNoteCoreDataHelper.createNoteInCoreData(
                    noteToBeCreated:          noteToBeAdded,
                    intoManagedObjectContext: self.managedObjectContext)
                // increase index
                currentIndex += 1
            }
        }
    
    func changeNote(noteToBeChanged: Zotes) {
               if managedContextHasBeenSet {
                   // check if UUID is in the dictionary
                   var noteToBeChangedIndex : Int?
                   noteIndexToIdDict.forEach { (index: Int, noteId: UUID) in
                       if noteId == noteToBeChanged.noteId {
                           noteToBeChangedIndex = index
                           return
                       }
                   }
                   if noteToBeChangedIndex != nil {
                       SimpleNoteCoreDataHelper.changeNoteInCoreData(
                       noteToBeChanged: noteToBeChanged,
                       inManagedObjectContext: self.managedObjectContext)
                   } else {
                       // TODO error handling
                   }
               }
           }
        
        func removeNote(at: Int) {
            if managedContextHasBeenSet {
                // check input index
                if at < 0 || at > currentIndex-1 {
                    // TODO error handling
                    return
                }
                // get note UUID from the dictionary
                let noteUUID = noteIndexToIdDict[at]
                SimpleNoteCoreDataHelper.deleteNotesFromCoreData(
                    noteIdToBeDeleted:        noteUUID!,
                    fromManagedObjectContext: self.managedObjectContext)
                // update noteIndexToIdDict dictionary
                // the element we removed was not the last one: update GUID's
                if (at < currentIndex - 1) {
                    // currentIndex - 1 is the index of the last element
                    // but we will remove the last element, so the loop goes only
                    // until the index of the element before the last element
                    // which is currentIndex - 2
                    for i in at ... currentIndex - 2 {
                        noteIndexToIdDict[i] = noteIndexToIdDict[i+1]
                    }
                }
                // remove the last element
                noteIndexToIdDict.removeValue(forKey: currentIndex)
                // decrease current index
                currentIndex -= 1
            }
        }
        
        func readNote(at: Int) -> Zotes? {
            if managedContextHasBeenSet {
                // check input index
                if at < 0 || at > currentIndex-1 {
                    // TODO error handling
                    return nil
                }
                // get note UUID from the dictionary
                let noteUUID = noteIndexToIdDict[at]
                let noteReadFromCoreData: Zotes?
                noteReadFromCoreData = SimpleNoteCoreDataHelper.readNoteFromCoreData(
                    noteIdToBeRead:           noteUUID!,
                    fromManagedObjectContext: self.managedObjectContext)
                return noteReadFromCoreData
            }
            return nil
        }
        
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let notes = SimpleNoteCoreDataHelper.readNotesFromCoreDataa(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = SimpleNoteCoreDataHelper.count
        for (index, note) in notes.enumerated() {
            noteIndexToIdDict[index] = note.noteId
        }
    }
       

        
        func count() -> Int {
            return SimpleNoteCoreDataHelper.count
        }
    }

