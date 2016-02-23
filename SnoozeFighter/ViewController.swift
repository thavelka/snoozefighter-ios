//
//  ViewController.swift
//  SnoozeFighter
//
//  Created by Tim Havelka on 2/22/16.
//  Copyright © 2016 Tim Havelka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer = NSTimer()

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func editButtonPressed(sender: AnyObject) {
        if timePicker.hidden == true {
            editButton.enabled = false
            editButton.title = ""
            saveButton.enabled = true
            saveButton.title = "Save"
            timer.invalidate()
            timePicker.hidden = false
            statusLabel.text = "No alarm set"
        }
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if timePicker.hidden == false {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            timeLabel.text = formatter.stringFromDate(timePicker.date)
            timePicker.hidden = true
            let timeInterval = timePicker.date.timeIntervalSinceNow
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerDidEnd:",userInfo: nil, repeats: false)
            statusLabel.text = "Alarm is set"
            saveButton.enabled = false
            saveButton.title = ""
            editButton.enabled = true
            editButton.title = "Edit"
        }
    }
    
    
    
    func timerDidEnd(timer: NSTimer) {
        statusLabel.text = "Alarm Triggered!"
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveButton.enabled = false
        saveButton.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

