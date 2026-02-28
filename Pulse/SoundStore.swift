import Foundation
import AVFoundation

struct SoundData: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String // SF Symbol
    let color: String // Color name for gradient
    let filename: String? // Actual filename in bundle
}

class SoundStore: ObservableObject {
    @Published var isPlaying = false
    @Published var currentSound: SoundData?
    
    private var audioPlayer: AVAudioPlayer?
    private var lastPlayedSoundId: String? = nil
    
    let sounds: [SoundData] = [
        SoundData(id: "rain", title: "Rain", description: "Soft summer rain or rain on a roof", icon: "cloud.rain.fill", color: "GlaciarBlue", filename: "rain"),
        SoundData(id: "ocean", title: "Ocean Waves", description: "Rhythmic waves on the shore", icon: "wave.3.right", color: "SkySerene", filename: "ocean"),
        SoundData(id: "stream", title: "Streams", description: "Constant murmur of running water", icon: "drop.fill", color: "RelaxGreen", filename: "stream"),
        SoundData(id: "wind", title: "Wind", description: "Soft breeze through the trees", icon: "wind", color: "MintCalm", filename: "wind"),
        SoundData(id: "storm", title: "Distant Storm", description: "Soft, distant thunder and rain", icon: "cloud.bolt.rain.fill", color: "Clay", filename: "storm"),
        SoundData(id: "forest", title: "Forest", description: "Leaves rustling and morning birds", icon: "leaf.fill", color: "SalviaGreen", filename: "forest"),
        SoundData(id: "cat", title: "Cat Purr", description: "Vibrant and comforting purring", icon: "heart.fill", color: "PalidSand", filename: "cat"),
        SoundData(id: "fire", title: "Fire", description: "Crackling logs in a fireplace", icon: "flame.fill", color: "Clay", filename: "fire"),
        SoundData(id: "noise", title: "Pink/White Noise", description: "Constant waterfall-like mask", icon: "speaker.wave.2.fill", color: "RelaxLavanda", filename: "noise"),
        SoundData(id: "snow", title: "Snow Crunch", description: "Soft, crisp sound of walking on snow", icon: "snowflake", color: "Cream", filename: "snow")
    ]
    
    func toggleSound(_ sound: SoundData) {
        if currentSound?.id == sound.id && isPlaying {
            stop()
        } else {
            play(sound)
        }
    }
    
    func play(_ sound: SoundData) {
        stop()
        
        guard let filename = sound.filename,
              let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            // If file doesn't exist, we just simulate playing for now
            currentSound = sound
            isPlaying = true
            print("Simulating playback of \(sound.title). File not found in bundle.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop infinitely
            audioPlayer?.play()
            currentSound = sound
            isPlaying = true
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        currentSound = nil
    }
    
    func toggleRandom() {
        if isPlaying {
            stop()
        } else {
            playRandom()
        }
    }
    
    func playRandom() {
        // Filter out the last played sound to ensure variety if possible
        let availableSounds = sounds.filter { $0.id != lastPlayedSoundId }
        let soundToPlay = availableSounds.randomElement() ?? sounds.randomElement()
        
        if let sound = soundToPlay {
            lastPlayedSoundId = sound.id
            play(sound)
        }
    }
}
