//
//  Zotes.swift
//  C0763588_Assignmet2_iOS
//
//  Created by Vivek Madishetty on 2020-01-21.
//  Copyright © 2020 Vivek Madishetty. All rights reserved.
//

import Foundation

class Zotes {
    private(set) var noteId        : UUID
    private(set) var noteTitle     : String
    private(set) var noteText      : String
    private(set) var noteTimeStamp : Int64
    private(set) var dayworked : Int64
    private(set) var totalday : Int64
    
    init(noteTitle:String, noteText:String, noteTimeStamp:Int64, dayworked:Int64, totalday:Int64) {
        self.noteId        = UUID()
        self.noteTitle     = noteTitle
        self.noteText      = noteText
        self.noteTimeStamp = noteTimeStamp
        self.dayworked = dayworked
        self.totalday = totalday
    }

    init(noteId: UUID, noteTitle:String, noteText:String, noteTimeStamp:Int64, dayworked:Int64, totalday:Int64) {
        self.noteId        = noteId
        self.noteTitle     = noteTitle
        self.noteText      = noteText
        self.noteTimeStamp = noteTimeStamp
        self.dayworked = dayworked
        self.totalday = totalday
    }
}
