//
//  ViewController.swift
//  SnoozeFighter
//
//  Created by Tim Havelka on 2/22/16.
//  Copyright © 2016 Tim Havelka. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var timer = NSTimer()
    var alarm: AVAudioPlayer?
    var editMode: Bool = false
    var timerSet: Bool = false

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIButton!
    @IBAction func stopButtonPressed(sender: AnyObject) {
        resetClock()
    }
    @IBAction func editButtonPressed(sender: AnyObject) {
        editMode ? closeEditMode() : openEditMode()
        
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        setAlarm()
        closeEditMode()
    }
    
    // Update time, update status, set timer
    func setAlarm() {
        timer.invalidate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        timeLabel.text = formatter.stringFromDate(timePicker.date)
        var timeInterval = timePicker.date.timeIntervalSinceNow
        if timeInterval.isSignMinus {
            timeInterval += 86400 // Add 24h if time interval is negative
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerDidEnd:",userInfo: nil, repeats: false)
        timerSet = true
        statusLabel.text = "Alarm is set"
        stopButton.setTitle("Disable Alarm", forState: .Normal)
    }
    
    // Stop audio, invalidate timer
    // Hide stop button, update time, update status, show edit button
    func resetClock() {
        if alarm != nil {
            alarm?.stop()
        }
        timer.invalidate()
        timerSet = false
        stopButton.hidden = true
        timeLabel.text = "--:--"
        statusLabel.textColor = UIColor.blackColor()
        statusLabel.text = "No alarm set"
        editButton.enabled = true
        editButton.title = "Edit"
    }
    
    // Show time picker, edit -> cancel, show save button
    func openEditMode() {
        editMode = true
        stopButton.hidden = true
        editButton.title = "Cancel"
        timePicker.hidden = false
        saveButton.enabled = true
        saveButton.title = "Save"
    }
    
    // Hide time picker, show edit button, hide save button
    func closeEditMode() {
        editMode = false
        editButton.title = "Edit"
        timePicker.hidden = true
        saveButton.title = ""
        saveButton.enabled = false
        if timerSet { stopButton.hidden = false }
    }
    
    // Play audio
    // Disable edit button, show stop button, update status
    func timerDidEnd(timer: NSTimer) {
        if editMode { closeEditMode() }
        if alarm != nil {
            alarm?.numberOfLoops = 8
            alarm?.play()
        }
        statusLabel.textColor = UIColor.redColor()
        statusLabel.text = "Alarm Triggered!"
        stopButton.setTitle("Stop Alarm", forState: .Normal)
        stopButton.hidden = false
        editButton.enabled = false
    }
    
    func setupAlarmAudio(file: NSString, type:NSString){
        let path = NSBundle.mainBundle().pathForResource(file as String!, ofType: type as String!)
        let url = NSURL.fileURLWithPath(path!)
        do {
            try alarm = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("player not available")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetClock()
        setupAlarmAudio("AlarmClockBeep", type: "wav")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

