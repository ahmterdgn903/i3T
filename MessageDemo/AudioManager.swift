	//
//  avMenager.swift
//  MessageDemo
//
//  Created by macOS on 13.08.2018.
//  Copyright © 2018 erdogan. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    static let sharedInstance: AudioManager = {
        let instance = AudioManager()
        return instance
    }()
    
//    var sliderr: UISlider!
    var audioPlayer: AVAudioPlayer!
    var recordinSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var filePath:URL!
    var fileName:String = ""
//    var icell:myCellClass!
    
    
    var state : AudioState = .idle
    //Recording audio requires a user's permission to stop malicious apps doing malicious things, so we need to request recording permission from the user. If they grant permission, we'll create our recording button.
    func AvSession() {
        recordinSession = AVAudioSession.sharedInstance()

        if let number:String = UserDefaults.standard.object(forKey: "myNumber") as? String
        {
            fileName = number
        }
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: .default,
            options:AVAudioSession.CategoryOptions.defaultToSpeaker);

        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermisson) in
            if hasPermisson {
                print("ACCEPTED")
            }
        }
//        recordinSession = AVAudioSession.sharedInstance()
//        do {
//            try! recordinSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try! recordinSession.setActive(true)
//            try! recordinSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
//            recordinSession.requestRecordPermission(){ [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.record()
//                    }
//                    else {
//                        // failed record
//                    }
//                }
//        }
    }
    //function thats get path to directory
    func getDirectory () -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
        
    }
    func getDocDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
//    var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
//    func getAudioDirectory(){
//        let audioPaths = paths[0].strings(byAppendingPaths: ["\(fileName).m4a"])
//        let audioUrl : NSURL =  NSURL(fileURLWithPath: audioPaths)
//        let asset = AVAsset(url: NSURL(fileURLWithPath: URL(string: audioPaths)))
//        return getAudioDirectory()
//
//    }
//    func saveAudioDocumentDirectory(){
//        let fileManager = FileManager.default
//        fileName = "\(Date().timeIntervalSince1970)"
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).strings(byAppendingPaths: ["\(fileName).m4a"])
//        let audio = audioPlayer(nemed: "\(fileName).m4a")
//    }
//    func getAudioDirectory() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentDirectory = paths[0]
//        return documentDirectory
//    }
//    func getAudio(){
//        let fileMngr = FileManager.default
//        let pths = NSSearchPathForDirectoriesInDomains()
//        let fileManager = NSFileProviderManager.default
//    }
    //    func displayAlert
    func displayAlert(title:String, message:String)
    {
        if let topController = UIApplication.topViewController() {
            let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
    //start audio recording
    func record(){
        if state == .playing {
            stopPlaying()
        }
        state = .recording
        fileName = "\(Date().timeIntervalSince1970).m4a"
        filePath = getDirectory().appendingPathComponent("\(fileName)")
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do
        {
            
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        }
        catch
        {
            print("Recording Failed")
            displayAlert(title: "Ups!", message: "Recording Failed")
        }
        
    }
    

//    //sliderbar
//    @objc func updateTime(_ timer: Timer) {
//        sliderr.value = Float(audioPlayer.currentTime)
//    }

    func play(from path: String) {
        
            let filePathString = getDirectory().appendingPathComponent("\(path)").absoluteString
            
            if let url = URL(string: filePathString) {
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer.delegate = self as AVAudioPlayerDelegate
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    state = .playing
                } catch {
                    state = .idle
                    print(error.localizedDescription)
                }
            }
        }
    func stopPlaying() {
        audioPlayer.stop()
        state = .idle
//            state = .idle
        


//
//        if audioPlayer != nil {
//            state = .paused
//            audioPlayer.stop()
//        }
//        else if audioPlayer .isPlaying {
//            state = .playing
//        }
//        else {
//            state = .idle
//            audioPlayer.stop()
//        }

        
    }
    func continueplay() {
            state = .playing
            audioPlayer.play()

    }
    //stop audio recording
    func stopRecording() {
        audioRecorder.stop()
        do {
            try recordinSession.setActive(false)
        } catch {
            print("stop()",error.localizedDescription)
        }
    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("kayıt başarılı")
            state = .idle
        } else {
            print("kayıt başarısız")
        }
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("hata \(error?.localizedDescription ?? "unknown")")
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("playind is done")
//            stopPlaying()
            state = .idle
        }
        else{
            print("error")
        }
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        print("hata \(error?.localizedDescription ?? "unknown")")    }
    
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
