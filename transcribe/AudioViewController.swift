//
//  AudioViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 02/10/24.
//

import UIKit
import AVFoundation

var audioPath : String  = "path"

class AudioViewController: UIViewController {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var runningtimeDuration: UILabel!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var progressBar: UISlider!
    
    var audioAction: AudioAction?
    var audioPlayer: AVAudioPlayer?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Audio Player"

        // Do any additional setup after loading the view.
        
        setupSlider()
        setupDurationLabels()
        
        print("Audio Controller")
        
        // Assuming you have an instance of AudioAction
        if let audioAction = audioAction {
            if audioPlayer?.isPlaying == true {
                    audioPlayer?.stop()
                    stopTimer()
                }
            if audioPath != audioAction.audioPath {
                
                loadAudio(at: audioAction.audioPath)
                title = audioAction.titleLabel
                subtitleLabel.text = audioAction.subTitleLabel
                
                playAudio()
            }else {
                // Old audio is already loaded
                print("Continuing with old audio")

                // Restore title and subtitles
                title = audioAction.titleLabel
                subtitleLabel.text = audioAction.subTitleLabel

                // Restore current time and duration
                runningtimeDuration.text = formatTime(audioPlayer?.currentTime ?? 0)
                totalDuration.text = formatTime(audioPlayer?.duration ?? 0)
                progressBar.value = Float(audioPlayer?.currentTime ?? 0)
                progressBar.maximumValue = Float(audioPlayer?.duration ?? 0)

                // Continue playing from where it left off
//                playAudio()
            }
        } else {
            print("Audio action is not set.")
        }
    }
    

    @IBAction func segmentChangeTracker(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            playAudio()
        } else if sender.selectedSegmentIndex == 1 {
            pauseAudio()
        }
        
        
    }
    
    private func setupSlider(){
        if let slider = progressBar{
            slider.minimumValue = 0
            slider.value = 0
        } else{
            print("Progress bar not found")
        }
    }
    
    private func setupDurationLabels(){
        if let totalLabel = totalDuration{
            totalLabel.text = "00:00"
        } else {
            print("Total duration label not found")
        }
        
        if let runningLabel = runningtimeDuration{
            runningLabel.text = "00:00"
        }else{
            print("Running duration label not found")
        }
    }
    
    private func loadAudio(at path: String){
        let fileURL = URL(fileURLWithPath: path)
        audioPath = path
        print("file url received")
        print(fileURL.path)
        
        if FileManager.default.fileExists(atPath: fileURL.path){
            do{
                print("File path : \(fileURL.path)")
                
                audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                audioPlayer?.prepareToPlay()
                
                totalDuration.text = formatTime(audioPlayer?.duration ?? 0)
                progressBar.maximumValue = Float(audioPlayer?.duration ?? 0)
                print ("Audio loaded successfully")
            } catch{
                print("Error loading audio: \(error)")
            }
        }
    }
    
    
    private func playAudio(){
        if let currentPlayer = audioPlayer, currentPlayer.isPlaying {
            currentPlayer.stop()
            stopTimer()
        }
        
        audioPlayer?.play()
        startTimer()
    }
    
    private func pauseAudio(){
        audioPlayer?.pause()
        stopTimer()
    }


    private func startTimer(){
        stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimestamp), userInfo: nil, repeats: true)
    }
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimestamp(){
        guard let audioPlayer else {return}
        
        let currentTime = audioPlayer.currentTime
        runningtimeDuration.text = formatTime(currentTime)
        progressBar.value = Float(currentTime)
    }
    
    private func formatTime(_ time: TimeInterval) -> String{
        let minutes = Int(time / 60)
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    deinit{
        stopTimer()
    }
}
