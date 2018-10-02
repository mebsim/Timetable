//
//  ScheduleViewController.swift
//  TimetableMenuBar
//
//  Created by Mohamed Ebsim on 2017-10-26.
//  Copyright © 2017 Mohamed Ebsim. All rights reserved.
//

import Cocoa

class ScheduleViewController: NSViewController {
    
    @IBOutlet var d11: NSTextField!
    @IBOutlet var d12: NSTextField!
    @IBOutlet var d13: NSTextField!
    @IBOutlet var d14: NSTextField!
    
    @IBOutlet var d21: NSTextField!
    @IBOutlet var d22: NSTextField!
    @IBOutlet var d23: NSTextField!
    @IBOutlet var d24: NSTextField!
    
    var timetable = ["","","","","","","",""]
    
    /*
     Learnt reading and writing: https://stackoverflow.com/a/24098149
     
     Simple:
     
     When opened: find all the labels information
                    AKA read file
     
     When closed: save all the labels information
                    AKA write file
     
     Added: save button for simplicity sake.
     
    */
    
    func readFile() -> String {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = dir!.appendingPathComponent("schedule.txt")
        
        //reading
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            return text2
        }
        catch {/* error handling here */}
        return ""
    }
    
    func writeFile(toWrite: String) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = dir!.appendingPathComponent("schedule.txt")
        
        //writing
        do {
            try toWrite.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
    
    func updateTimetable() {
        let x = readFile().components(separatedBy: "\n")
        for i in 0 ..< x.count {
            timetable[i] = x[i]
        }
        d11.stringValue = timetable[0]
        d12.stringValue = timetable[1]
        d13.stringValue = timetable[2]
        d14.stringValue = timetable[3]
        d21.stringValue = timetable[4]
        d22.stringValue = timetable[5]
        d23.stringValue = timetable[6]
        d24.stringValue = timetable[7]
    }
    
    func saveTimetable() {
        writeFile(toWrite: d11.stringValue + "\n" + d12.stringValue + "\n" + d13.stringValue + "\n" + d14.stringValue + "\n" + d21.stringValue + "\n" + d22.stringValue + "\n" + d23.stringValue + "\n" + d24.stringValue)
    }
    
    override func viewDidLoad() {
        updateTimetable()
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear() {
        //saveTimetable()
        super.viewWillDisappear()
    }
    
    @IBAction func save(_ sender: NSButton) {
        saveTimetable()
    }
    
}
