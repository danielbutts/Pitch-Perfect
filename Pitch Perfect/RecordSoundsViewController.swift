//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Daniel Butts on 7/13/15.
//  Copyright (c) 2015 Cool Vector. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var pauseImage: UIImage!
    var resumeImage: UIImage!
    var isPaused: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseResumeButton.hidden = true
        recordingInProgress.text = "Tap to Record"
        recordButton.enabled = true
        pauseImage = UIImage(named: "Pause Button") as UIImage!
        resumeImage = UIImage(named: "Play Button") as UIImage!
        isPaused = false
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        pauseResumeButton.hidden = false
        recordingInProgress.text = "Recording"
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Set up audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseResumeRecordAudio(sender: UIButton) {
        if (!isPaused) {
            isPaused = true
            audioRecorder.pause()
            pauseResumeButton.setImage(resumeImage, forState: .Normal)
            recordingInProgress.text = "Recording Paused"
        } else {
            isPaused = false
            audioRecorder.record()
            pauseResumeButton.setImage(pauseImage, forState: .Normal)
            recordingInProgress.text = "Recording"
        }
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent)

            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {

            // present error message to user when recording fails. Adapted from http://www.appcoda.com/uialertcontroller-swift-closures-enum/
            let alertController = UIAlertController(title: "Failure", message: "Audio Recording Failed to Complete", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            recordButton.enabled = true
            stopButton.hidden = true
            pauseResumeButton.hidden = true
            pauseResumeButton.setImage(pauseImage, forState: .Normal)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}
