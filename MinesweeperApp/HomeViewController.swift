import Foundation
import UIKit

final class HomeViewController: UIViewController {
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Settings", for: .normal)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        return button
    }()
    
    private let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Game", for: .normal)
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
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
        view.addSubview(startGameButton)
        view.addSubview(settingsButton)
        repositionButtons()
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
