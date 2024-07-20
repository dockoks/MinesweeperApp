import Foundation
import UIKit

final class HomeViewController: UIViewController {
    private let settingsButton = UIButton()
    private let startGameButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        repositionButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupbuttons()
    }
    
    private func setupbuttons() {
        configureSettingsButton()
        configureStartGameButton()
        view.addSubview(startGameButton)
        view.addSubview(settingsButton)
        repositionButtons()
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
        
        settingsButton.frame = CGRect(
            x: padding,
            y: view.bounds.height - safeAreaBottom - padding - buttonHeight,
            width: (view.bounds.width - safeAreaLeft - safeAreaRight - buttonSpacing - 2*padding) / 2,
            height: buttonHeight
        )
        
        startGameButton.frame = CGRect(
            x: (view.bounds.width + buttonSpacing) / 2,
            y: view.bounds.height - safeAreaBottom - padding - buttonHeight,
            width: (view.bounds.width - safeAreaLeft - safeAreaRight - buttonSpacing - 2*padding) / 2,
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
}
