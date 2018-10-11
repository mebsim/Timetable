//
//  TimetableViewController.swift
//  TimetableMenuBar
//
//  Created by Mohamed Ebsim on 2017-10-23.
//  Copyright © 2017 Mohamed Ebsim. All rights reserved.
//

import Cocoa

class TimetableViewController: NSViewController {
    
    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var textLabel: NSTextField!
    @IBOutlet var dayLabel: NSTextField!
    
    let daysInMonths: [Int] = [31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]
    let nameOfMonths: [String] = ["December", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "Novemeber"]
    let nameOfWeekdays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let holidaysByDate: [Int] = [1008, 1109, 1112, 022, 023, 024, 025, 026, 027, 028, 029, 030, 031, 101, 102, 103, 104, 105, 106, 215, 218, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 419, 422, 520]
    
    var daySchedules:[[Int]] = [[0,1,2,3],[3,0,1,2],[2,3,0,1],[1,2,3,0]]
    
    var dayOneSchedule: [String] = ["", "", "", ""]
    var dayTwoSchedule: [String] = ["", "", "", ""]
    
    var day: Int?
    var month: Int?
    var dayOfWeek: Int = 4
    
    var timetable = ["","","","","","","",""]
    
    /*
     
     TODO: Simplify and optimize the method of calculating the day of the cycle
     IDEAS:
        Count from the beginning of each month?
        Calculate 4 points even throughout the year and calculate from them
     
     TODO: Sreamline the updating of the popover, without having to call the getDayOfCycle method too often
     
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
    
    var dayOffSet: Int = 0 {
        didSet {
            updateDay()
        }
    }
    
    func updateTimetable() {
        let x = readFile().components(separatedBy: "\n")
        for i in 0 ..< x.count {
            timetable[i] = x[i]
        }
        dayOneSchedule = [timetable[0],timetable[1],timetable[2],timetable[3]]
        dayTwoSchedule = [timetable[4],timetable[5],timetable[6],timetable[7]]
    }
    
    func changeWithOffSet(day2: Int, month2: Int) -> Int {
        var day = day2
        var month = month2
        if(dayOffSet > 0) {
            while(true) {
                if(day > daysInMonths[month]) {
                    day = day - daysInMonths[(month)%12];
                    month = (month + 1)%12;
                } else {
                    break;
                }
            }
        } else if(dayOffSet < 0) {
            while(true) {
                if(day <= 0) {
                    day = daysInMonths[(month-1)%12] + day;
                    month = (month - 1)%12;
                } else {
                    break;
                }
            }
        }
        return day
    }
    
    func getDayOfCycle() -> Int {

        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        day = (Int)(dateFormatter.string(from: now as Date)) // Returns day as 1-31
        dateFormatter.dateFormat = "MM"
        month = (Int)(dateFormatter.string(from: now as Date)) // Returns month as 1-12
        
        // Change day based off offset
        day = day! + dayOffSet
        //day = 9
        month = month!%12
        
        if(dayOffSet > 0) {
            while(true) {
                if(day! > daysInMonths[month!]) {
                    day = day! - daysInMonths[(month!)%12];
                    month = (month! + 1)%12;
                } else {
                    break;
                }
            }
        } else if(dayOffSet < 0) {
            while(true) {
                if(day! <= 0) {
                    day = daysInMonths[(month!-1)%12] + day!;
                    month = (month! - 1)%12;
                } else {
                    break;
                }
            }
        }
        
        month = month!%12
        
        // Getting the day of the week
        var dayAtDay: Int = 0
        var dayOfCycle: Int = 1 // Day of cycle
        var cycle: Int = 1 // cycle number
        var countMonth: Int = 9 // month for counting
        var countDay: Int = 5 // day of month for counting
        dayOfWeek = 4 // Day of week
        var isHoliday: Bool = false // Is it a holiday?
        var isNoSchool: Bool = false // Is there no school?
        
        while !((countMonth%12) == month! && countDay == day!) {
            dayOfCycle = dayOfCycle + 1
            isNoSchool = false
            isHoliday = false
            if(countDay < daysInMonths[(countMonth)%12]) {
                countDay = countDay + 1
            } else {
                countDay = 1
                countMonth = countMonth + 1
            }
            /*for i in holidays {
                if(totalDayCount == i) {
                    // System.out.println("It's a holiday on the " + dayOfMonth2 + ". It's index is: " + i + ". Overall date = " + dayOfMonth3);
                    //isNoSchool = true;
                    break;
                }
            }*/
            for i in holidaysByDate {
                //print("Holiday on?",countMonth%12)
                //print("Holiday on?",countDay)
                //print(i/100)
                //print(i%100)
                if(countDay == (i%100) && countMonth%12 == (i/100)) {
                    isHoliday = true;
                    break;
                }
                
            }
            //print("Day:", dayOfCycle)
            if(dayOfWeek == 6 || dayOfWeek == 7){
                isNoSchool = true;
            }
            if(isNoSchool || isHoliday) {
                dayOfCycle = dayOfCycle - 1;
            }
            if(dayOfCycle > 8) {
                dayOfCycle = 1;
                cycle = cycle + 1;
            }
            //print("Day:", dayOfCycle)
            if(((countMonth%12) == month! && countDay == day!)) {
                //print(day!)
                //print(month!)
                //print("Total:",totalDayCount)
                //print("Day:", dayOfCycle)
                if(isHoliday) {
                    dayAtDay = 11;
                    break;
                }
                if(isNoSchool) {
                    dayAtDay = 10;
                    break;
                }
                dayAtDay = dayOfCycle;
                break;
            }
            //print("Day:", dayOfCycle)
            dayOfWeek = dayOfWeek + 1;
            if(dayOfWeek > 7) {
                dayOfWeek = 1;
            }
        }
        
        return dayAtDay
    }
    
    func popoverOpened() {
        dayOffSet = 0
        updateTimetable()
    }
    
    func getTimetable () -> String {
        var timetable:String = ""
        let t = getDayOfCycle()
        if(t == 10) {
            timetable = "Weekend. No school on this day."
        } else if(t == 11) {
            timetable = "Holiday. No school on this day."
        } else {
            if(t%2 == 0) {
                let x = daySchedules[t/2 - 1]
                timetable = dayTwoSchedule[x[0]] + "\n"
                timetable = timetable + dayTwoSchedule[x[1]] + "\n"
                timetable = timetable + dayTwoSchedule[x[2]] + "\n"
                timetable = timetable + dayTwoSchedule[x[3]]
            } else {
                let x = daySchedules[t/2]
                timetable = dayOneSchedule[x[0]] + "\n"
                timetable = timetable + dayOneSchedule[x[1]] + "\n"
                timetable = timetable + dayOneSchedule[x[2]] + "\n"
                timetable = timetable + dayOneSchedule[x[3]]
            }
        }
        return timetable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayOffSet = 0
        updateTimetable()
    }
    
    func updateDay() {
        let a = getTimetable()
        titleLabel.stringValue = String(nameOfWeekdays[dayOfWeek-1] + " " + nameOfMonths[month!] + " " + String(describing: day!))
        let dayOf = getDayOfCycle()
        if (dayOf != 10) {
            dayLabel.stringValue = "Day " + String(getDayOfCycle())
        } else {
            dayLabel.stringValue = ""
        }
        textLabel.stringValue = String(a)
    }
    
}

extension TimetableViewController {
    @IBAction func previous(_ sender: NSButton) {
        dayOffSet = dayOffSet - 1
    }
    
    @IBAction func next(_ sender: NSButton) {
        dayOffSet = dayOffSet + 1
    }
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
}

extension TimetableViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> TimetableViewController {
        //1.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        //2.
        let identifier = "TimetableViewController"
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TimetableViewController else {
            fatalError("Why cant i find TimetableViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
