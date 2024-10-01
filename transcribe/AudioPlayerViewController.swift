//
//  AudioPlayerViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {

    var audioAction: AudioAction?
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pause", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00 / 00:00"
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Set the title and subtitle labels
        titleLabel.text = audioAction?.titleLabel
        subtitleLabel.text = audioAction?.subTitleLabel
        
        // Load and prepare audio
        if let audioPath = audioAction?.audioPath {
            loadAudio(at: audioPath)
        }
        
        // Add target actions for buttons
        playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseAudio), for: .touchUpInside)
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(playButton)
        view.addSubview(pauseButton)
        view.addSubview(timestampLabel)

        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            playButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pauseButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10),
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timestampLabel.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 20),
            timestampLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func loadAudio(at path: String) {
        let fileURL = URL(fileURLWithPath: path)
        print(fileURL)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("File exists at \(fileURL.path)")
        } else {
            print("File does not exist at \(fileURL.path)")
        }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let audioPath = URL(fileURLWithPath: fileURL.path)
                print("Audio Path \(audioPath)")
                audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
                audioPlayer?.prepareToPlay()
                
                // Set the duration in the timestamp label
                let duration = formatTime(audioPlayer?.duration ?? 0)
                timestampLabel.text = "00:00 / \(duration)" // Initialize label with duration
                print("Audio player initialized successfully with URL: \(fileURL)")
            } catch {
                print("Error loading audio: \(error)")
            }
        } else {
            print("Audio file does not exist at path: \(fileURL.path)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    @objc func playAudio() {
        audioPlayer?.play()
        startTimer()
    }

    @objc func pauseAudio() {
        audioPlayer?.pause()
        stopTimer()
    }
    
    private func startTimer() {
        // Invalidate previous timer if any
        stopTimer()
        
        // Start a new timer to update the timestamp every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimestampLabel), userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateTimestampLabel() {
        guard let audioPlayer = audioPlayer else { return }

        let currentTime = formatTime(audioPlayer.currentTime)
        let duration = formatTime(audioPlayer.duration)

        timestampLabel.text = "\(currentTime) / \(duration)"
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    deinit {
        stopTimer()  // Ensure timer is invalidated when the view controller is deallocated
    }
}
