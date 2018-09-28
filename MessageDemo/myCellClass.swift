//
//  myCellClass.swift
//  MessageDemo
//
//  Created by macOS on 13.08.2018.
//  Copyright © 2018 erdogan. All rights reserved.
//

import UIKit

class myCellClass: UITableViewCell {
    var audio: Item2?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    //slider {
    // Formatting time for display
    let timeFormatter = NumberFormatter()

    var audioTimer: Timer?            // holds a timer instance
    var isDraggingTimeSlider = false    // Keep track of when the time slide is being dragged
    
    var isPlaying = false {             // keep track of when the player is playing
        didSet {                        // This is a computed property. Changing the value
//            setButtonState()            // invokes the didSet block
            AudioManager.sharedInstance.stopPlaying()
        }
    }

     // MARK: IBOutlets
    @IBOutlet weak var timeSlider: UISlider!

      // MARK: IBActions
    // Update time when dragging the slider
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        // Working on this
        // TODO: Implement Time Slider
        guard let audioPlayer = AudioManager.sharedInstance.audioPlayer else {
            return
    }

    audioPlayer.currentTime = audioPlayer.duration * Double(sender.value)
}
    // The time slider is tricky since we want it to update while the player is playing
    // but it can't be updated while we dragging it!
    @IBAction func timeSliderTouchDown(sender: UISlider) {
        isDraggingTimeSlider = true
    }

    @IBAction func timeSliderTouchUp(sender: UISlider) {
        isDraggingTimeSlider = false
    }

    @IBAction func timeSliderTouchUpOutside(sender: UISlider) {
        isDraggingTimeSlider = false
    }
    //}

    func makeTimer() {
        // This function sets up the timer.
        if audioTimer != nil {
            audioTimer!.invalidate()
        }

        // audioTimer = Timer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.onTimer(_:)), userInfo: nil, repeats: true)

        audioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.onTimer(timer:)), userInfo: nil, repeats: true)
    }
    @objc func onTimer(timer: Timer) {
        // Check the audioPlayer, it's optinal remember. Get the current time and duration
        guard let currentTime = AudioManager.sharedInstance.audioPlayer?.currentTime, let duration = AudioManager.sharedInstance.audioPlayer?.duration else {
            return
        }
        
        switch AudioManager.sharedInstance.state{
        case .idle:
            if audioTimer != nil {
                audioTimer!.invalidate()
            }
            break
        case .recording:
//            print("recording")
            break
        case .playing:
//            print("playing")
            break
        case .paused:
//            print("stoping")
            break
        }

        // Calculate minutes, seconds, and percent completed
        let mins = currentTime / 60
        // let secs = currentTime % 60
        let secs = currentTime.truncatingRemainder(dividingBy: 60)
        let percentCompleted = currentTime / duration

        // Use the number formatter, it might return nil so guard
        //    guard let minsStr = timeFormatter.stringFromNumber(NSNumber(mins)), let secsStr = timeFormatter.stringFromNumber(NSNumber(secs)) else {
        //      return
        //    }

        guard let minsStr = timeFormatter.string(from: NSNumber(value: mins)), let secsStr = timeFormatter.string(from: NSNumber(value: secs)) else {
            return
        }


//        // Everything is cool so update the timeLabel and progress bar
//        timeLabel.text = "\(minsStr):\(secsStr)"
//        progressBar.progress = Float(percentCompleted)
        // Check that we aren't dragging the time slider before updating it
        if !isDraggingTimeSlider {
            timeSlider.value = Float(percentCompleted)
        }
    }
    //}
    
    

    
    
    @IBOutlet weak var cellPlyBtnO: NSLayoutConstraint!

    
    var player = AudioManager.sharedInstance.audioPlayer


    @IBAction func cellPlyBtnA(_ sender: UIButton) {
        
        switch AudioManager.sharedInstance.state{
        case .idle:
            let myimage = UIImage(named: "stop-50.png")
            sender.setImage(myimage, for: UIControl.State.normal)
            let audio = self.audio
            let name = audio?.name
            makeTimer()
            let filePath = AudioManager.sharedInstance.getDirectory().appendingPathComponent("\(name)")
            AudioManager.sharedInstance.play(from: (audio?.name)!)
            break
        case .recording:
            break
        case .playing:
            let myimage2 = UIImage(named: "play-50.png")
            sender.setImage(myimage2, for: UIControl.State.normal)
            AudioManager.sharedInstance.stopPlaying()
            break
        case .paused:
            let myimage = UIImage(named: "play-50.png")
            sender.setImage(myimage, for: UIControl.State.normal)
            AudioManager.sharedInstance.continueplay()
            break
        }
       
    }
    
}
