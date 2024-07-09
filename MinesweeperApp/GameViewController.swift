import UIKit

class GameViewController: UIViewController {
    private let padding: CGFloat = CGFloat(Config.shared.boardPadding)
    let boardView = BoardView(gameMode: Config.shared.gameMode)
    
    let backButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = CGFloat(Config.shared.boardCornerRadius)
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    let flagButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "flag.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemFill
        button.layer.cornerRadius = CGFloat(Config.shared.boardCornerRadius)
        button.layer.cornerCurve = .continuous
        button.addTarget(self, action: #selector(toggleFlagMode), for: .touchUpInside)
        return button
    }()
    
    var isFlaggingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        setupBoard()
        setupControls()
    }

    private func setupBoard() {
        view.addSubview(boardView)
    }
    
    private func setupControls() {
        view.addSubview(backButton)
        view.addSubview(flagButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateBoardPosition()
        layoutBackButton()
        layoutFlagButton()
    }
    
    private func updateBoardPosition() {
        let sideLength = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 2 * CGFloat(Config.shared.boardPadding)
        boardView.repositionBoard(to: CGSize(width: sideLength, height: sideLength))
        boardView.center = view.center
    }
    
    private func layoutBackButton() {
        backButton.frame = CGRect(
            x: view.safeAreaInsets.left + padding,
            y: view.safeAreaInsets.top + padding,
            width: 48,
            height: 48
        )
    }

    private func layoutFlagButton() {
        flagButton.frame = CGRect(
            x: view.bounds.width - view.safeAreaInsets.right - 48 - padding,
            y: view.safeAreaInsets.top + padding,
            width: 48,
            height: 48
        )
    }

    @objc
    private func toggleFlagMode(_ sender: UISwitch) {
        self.isFlaggingMode.toggle()
        self.boardView.isFlaggingMode = self.isFlaggingMode
        
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 0.95, 1.05, 1.0]
        bounceAnimation.keyTimes = [0, 0.3, 0.6, 1]
        bounceAnimation.duration = 0.3
        
        if self.isFlaggingMode {
            let image = UIImage(systemName: "flag", withConfiguration: imageConfig)
            self.flagButton.backgroundColor = Config.shared.markBorderColor
            self.flagButton.setImage(image, for: .normal)
            self.flagButton.tintColor = .label
            self.flagButton.layer.borderColor = Config.shared.markBorderColor.cgColor
            self.flagButton.layer.borderWidth = 0
        } else {
            let image = UIImage(systemName: "flag.fill", withConfiguration: imageConfig)
            self.flagButton.backgroundColor = .systemFill
            self.flagButton.setImage(image, for: .normal)
            self.flagButton.tintColor = .label
            self.flagButton.layer.borderColor = UIColor.clear.cgColor
            self.flagButton.layer.borderWidth = 0
        }
        
        flagButton.layer.add(bounceAnimation, forKey: "bounce")
    }

    @objc
    private func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
