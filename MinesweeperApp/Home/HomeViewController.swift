import Foundation
import AVFoundation
import UIKit

final class HomeViewController: UIViewController {
    private var playerLight: AVPlayer?
    private var playerDark: AVPlayer?
    private var playerLayerLight: AVPlayerLayer?
    private var playerLayerDark: AVPlayerLayer?
    
    private let imageView = UIImageView()
    private let settingsButton = UIButton()
    private let startGameButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotificationObservers()
        setupAppLifecycleObservers()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        repositionButtons()
        playerLayerLight?.frame = view.bounds
        playerLayerDark?.frame = view.bounds
        imageView.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupImageView()
        setupVideoPlayers()
        setupButtons()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerLight?.currentItem
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerDark?.currentItem
        )
    }
    
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    private func setupImageView() {
        let image = UIImage(named: "background")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
    
    private func setupVideoPlayers() {
        guard
            let videoURLdark = Bundle.main.url(forResource: "dark", withExtension: "mp4"),
            let videoURLlight = Bundle.main.url(forResource: "light", withExtension: "mp4")
        else { return }
        
        playerLight = AVPlayer(url: videoURLlight)
        playerDark = AVPlayer(url: videoURLdark)
        
        playerLayerLight = AVPlayerLayer(player: playerLight)
        playerLayerDark = AVPlayerLayer(player: playerDark)
        
        guard
            let playerLayerLight = playerLayerLight,
            let playerLayerDark = playerLayerDark
        else { return }
        
        playerLayerLight.frame = view.bounds
        playerLayerLight.videoGravity = .resizeAspectFill
        playerLayerDark.frame = view.bounds
        playerLayerDark.videoGravity = .resizeAspectFill
        
        view.layer.insertSublayer(playerLayerLight, above: imageView.layer)
        view.layer.insertSublayer(playerLayerDark, above: playerLayerLight)
        
        playerLight?.play()
        playerDark?.play()
        
        updatePlayerLayerVisibility(for: traitCollection.userInterfaceStyle)
    }
    
    private func updatePlayerLayerVisibility(for userInterfaceStyle: UIUserInterfaceStyle) {
        if userInterfaceStyle == .dark {
            playerLayerLight?.isHidden = true
            playerLayerDark?.isHidden = false
        } else {
            playerLayerLight?.isHidden = false
            playerLayerDark?.isHidden = true
        }
    }
    
    private func setupButtons() {
        configureSettingsButton()
        configureStartGameButton()
        view.addSubview(startGameButton)
        view.addSubview(settingsButton)
    }
    
    private func configureSettingsButton() {
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.label, for: .normal)
        settingsButton.backgroundColor = .systemFill
        settingsButton.layer.cornerRadius = 12
        settingsButton.layer.cornerCurve = .continuous
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    }
    
    private func configureStartGameButton() {
        startGameButton.setTitle("Start Game", for: .normal)
        startGameButton.setTitleColor(.label, for: .normal)
        startGameButton.backgroundColor = .systemFill
        startGameButton.layer.cornerRadius = 12
        startGameButton.layer.cornerCurve = .continuous
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    
    private func repositionButtons() {
        let padding: CGFloat = 20
        let buttonHeight: CGFloat = 48
        let buttonSpacing: CGFloat = 12
        let safeAreaLeft: CGFloat = view.safeAreaInsets.left
        let safeAreaRight: CGFloat = view.safeAreaInsets.right
        let safeAreaBottom: CGFloat = view.safeAreaInsets.bottom
        
        let buttonWidth = (view.bounds.width - safeAreaLeft - safeAreaRight - buttonSpacing - 2 * padding) / 2
        
        settingsButton.frame = CGRect(
            x: safeAreaLeft + padding,
            y: view.bounds.height - safeAreaBottom - padding - buttonHeight,
            width: buttonWidth,
            height: buttonHeight
        )
        
        startGameButton.frame = CGRect(
            x: safeAreaLeft + padding + buttonWidth + buttonSpacing,
            y: view.bounds.height - safeAreaBottom - padding - buttonHeight,
            width: buttonWidth,
            height: buttonHeight
        )
    }
    
    @objc
    private func startGame() {
        let vc = GameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func openSettings() {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func playerDidFinishPlaying(_ notification: Notification) {
        playerLayerLight?.isHidden = true
        playerLayerDark?.isHidden = true
    }
    
    @objc
    private func appWillResignActive() {
        playerLight?.pause()
        playerDark?.pause()
    }
    
    @objc
    private func appDidBecomeActive() {
        playerLight?.play()
        playerDark?.play()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updatePlayerLayerVisibility(for: traitCollection.userInterfaceStyle)
        }
    }
}
