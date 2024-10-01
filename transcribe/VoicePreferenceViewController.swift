import UIKit

class VoicePreferenceViewController: UIViewController {

    let voiceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Male", "Female"])
        segmentedControl.selectedSegmentIndex = AppSettings.shared.selectedVoice == "Male" ? 0 : 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    let speedSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5
        slider.maximumValue = 1.0
        slider.value = AppSettings.shared.speechSpeed
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let pitchSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5
        slider.maximumValue = 2.0
        slider.value = AppSettings.shared.pitch
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    let speedLabel: UILabel = {
        let label = UILabel()
        label.text = "Speech Speed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let pitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Pitch"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let customTintColor = UIColor(hex: "#FF6026")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Voice Preferences"
        
        view.backgroundColor = .white
        setupUI()
        
        // Set slider tint colors to match view's tint color
        speedSlider.minimumTrackTintColor = customTintColor
        speedSlider.thumbTintColor = customTintColor
        pitchSlider.minimumTrackTintColor = customTintColor
        pitchSlider.thumbTintColor = customTintColor
        
        // Actions for changes in values
        voiceSegmentedControl.addTarget(self, action: #selector(voiceSegmentChanged), for: .valueChanged)
        speedSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        pitchSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }

    private func setupUI() {
        // Add views to the main view
        view.addSubview(voiceSegmentedControl)
        view.addSubview(speedLabel)
        view.addSubview(speedSlider)
        view.addSubview(pitchLabel)
        view.addSubview(pitchSlider)

        // Constraints for the segmented control
        NSLayoutConstraint.activate([
            voiceSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            voiceSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            voiceSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for speed label
        NSLayoutConstraint.activate([
            speedLabel.topAnchor.constraint(equalTo: voiceSegmentedControl.bottomAnchor, constant: 40),
            speedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for speed slider
        NSLayoutConstraint.activate([
            speedSlider.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 10),
            speedSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for pitch label
        NSLayoutConstraint.activate([
            pitchLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 40),
            pitchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for pitch slider
        NSLayoutConstraint.activate([
            pitchSlider.topAnchor.constraint(equalTo: pitchLabel.bottomAnchor, constant: 10),
            pitchSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pitchSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func voiceSegmentChanged(_ sender: UISegmentedControl) {
        let selectedVoice = sender.selectedSegmentIndex == 0 ? "Male" : "Female"
        AppSettings.shared.updateVoicePreference(to: selectedVoice, speed: AppSettings.shared.speechSpeed, pitch: AppSettings.shared.pitch)
    }

    @objc func sliderChanged(_ sender: UISlider) {
        let speed = speedSlider.value
        let pitch = pitchSlider.value
        
        // Update the global settings automatically
        AppSettings.shared.updateVoicePreference(to: AppSettings.shared.selectedVoice, speed: speed, pitch: pitch)
    }
}
