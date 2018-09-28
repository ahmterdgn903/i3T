//
//  ViewController.swift
//  MessageDemo
//
//  Created by macOS on 6.08.2018.
//  Copyright © 2018 erdogan. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
//AVAudioRecorderDelegate, AVAudioPlayerDelegate,
    var realm: Realm!
    
    var audioRec: Results<Item2>{
        get{
            return realm.objects(Item2.self)
        }
    }
   
    
    var audios = [Item2]()
    
//    var audioPlayer: AVAudioPlayer!
//    var recordinSession:AVAudioSession!
    var filePath = AudioManager.sharedInstance.filePath
    var fileName = AudioManager.sharedInstance.fileName
//    var iCell: myCellClass!
//    var progressView: UIProgressView!

    @IBOutlet weak var sendBtnO: UIButton!
    @IBOutlet weak var recordO: UIButton!
    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var btnOUtlet: UIButton!
    @IBAction func sendBtnA(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        iCell.self.timeSlider.value = 0
//        iCell.self.timeFormatter.minimumIntegerDigits = 2
//        iCell.self.timeFormatter.minimumFractionDigits = 0
//        iCell.self.timeFormatter.roundingMode = .down
//        iCell.self.makeTimer()
        // These could be added in the Storyboard instead if you mark
        // buttonDown and buttonUp with @IBAction
        recordO.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        recordO.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
        
        // Do any additional setup after loading the view, typically from a nib.

        //***
        AudioManager.sharedInstance.AvSession()
        
        realm = try? Realm()
        audios = Array(realm.objects(Item2.self)) as [Item2]
        print(audios.count)
    }
   
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }


    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioRec.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell2 = tableView.cellForRow(at: indexPath) as! myCellClass
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myCellClass
        let item = audios[indexPath.row]
        cell.audio = item
        //        cell.cellLabel.text = "\(item.name)\n\(Date())"
//        cell = tableView.cellForRow(at: indexPAth2) as! myCellClass
        // Cell seperator deleting
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        cell.timeSlider.value = 0
        cell.timeFormatter.minimumIntegerDigits = 2
        cell.timeFormatter.minimumFractionDigits = 0
        cell.timeFormatter.roundingMode = .down
        //cell.makeTimer()
        //prgrss
//        cell.myTimer = Timer()
//        cell.progressViewO.progress = 0.0
        // Setup a number formatter that rounds down and pads with a 0




        return cell
        
    }

    
    //Work can on rows
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Delete Function
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == UITableViewCell.EditingStyle.delete){
                let item = audioRec[indexPath.row]
                try! self.realm.write ({
                    self.realm.delete(item)
                })
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let audio = audios[indexPath.row]
//
//
////        AudioManager.sharedInstance.play(from: audio.path)
////
////
//        tableView.deselectRow(at: indexPath, animated: true)
////
//    }


//    //Mark - Add Delegate Methods
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let audio = audios[indexPath.row]
//            let urlPath = URL(string: audio.path)
//
//
//            //        let path = getDirectory().appendingPathComponent("\(indexPath.row).m4a")
//            //print(audio.path)
//            do{
//
//                audioPlayer = try AVAudioPlayer(contentsOf: urlPath!)
//                audioPlayer.prepareToPlay()
//                audioPlayer.play()
////                let myimage = UIImage(named: "stop-50.png")
////                btnOUtlet.setImage(myimage, for: UIControlState.normal)
//            }
//
//            catch{
//                print(error)
//            }
//            //        tableView.reloadRows(at: [indexPath], with: .automatic)
//            tableView.deselectRow(at: indexPath, animated: true)
//
//        }
    
    @objc func buttonDown(_ sender: UIButton) {
        AudioManager.sharedInstance.record()
        //recording alert
        let alert = UIAlertController(title: nil, message: "Recording...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

    }
    @objc func buttonUp(_ sender: UIButton) {
        AudioManager.sharedInstance.stopRecording()
        UserDefaults.standard.set(fileName, forKey: "myNumber")
        let item = Item2()
        item.name = AudioManager.sharedInstance.fileName
        item.path = AudioManager.sharedInstance.fileName
        try! self.realm.write ({
            realm.add(item)
            self.filePath = URL(fileURLWithPath: "")
            self.fileName = ""
        })
        //recording alert
        dismiss(animated: false, completion: nil)
        audios = Array(realm.objects(Item2.self)) as [Item2]
        myTableView.reloadData()
    }

//
//    @IBAction func record(_ sender: UIButton) {
//
//
//        switch AudioManager.sharedInstance.state {
//        case .idle:
//            let myimage = UIImage(named: "stop-50.png")
//            sender.setImage(myimage, for: UIControlState.normal)
//            AudioManager.sharedInstance.record()
//            break
//        case .recording:
//            let myimage = UIImage(named: "record-50.png")
//            btnOUtlet.setImage(myimage, for: UIControlState.normal)
//            AudioManager.sharedInstance.stopRecording()
//            UserDefaults.standard.set(fileName, forKey: "myNumber")
//            let item = Item2()
//            item.name = fileName
//            item.path = AudioManager.sharedInstance.filePath.absoluteString
//
//            try! self.realm.write ({
//                realm.add(item)
//                self.filePath = URL(fileURLWithPath: "")
//                self.fileName = ""
//            })
//            audios = Array(realm.objects(Item2.self)) as [Item2]
//            myTableView.reloadData()
//
//            break
//        case .playing:
//
//            break
//        case .stoping:
//            break
//        }
    
//        if audioRecorder == nil
//        {
//            let myimage = UIImage(named: "stop-50.png")
//            sender.setImage(myimage, for: UIControlState.normal)
//            AudioManager.sharedInstance.record()
//
//        }
//        else
//        {
//            let myimage = UIImage(named: "record-50.png")
//            btnOUtlet.setImage(myimage, for: UIControlState.normal)
//            AudioManager.sharedInstance.stop()
//            UserDefaults.standard.set(fileName, forKey: "myNumber")
//            let item = Item2()
//            item.name = fileName
//            item.path = (filePath?.absoluteString)!
//
//            try! self.realm.write ({
//                realm.add(item)
//                self.filePath = URL(fileURLWithPath: "")
//                self.fileName = ""
//            })
//            audios = Array(realm.objects(Item2.self)) as [Item2]
//            myTableView.reloadData()
//        }
        
//    }
    

}

enum AudioState : Int {
    case idle = 0
    case recording
    case playing
    case paused
}
