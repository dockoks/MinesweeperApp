import UIKit

class SettingsViewController: UIViewController {
    
    private let config = Config.shared
    
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
    
    private let sampleBoardWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = Config.shared.markBorderColor.withAlphaComponent(0.3)
        return view
    }()
    
    private let sampleBoardView = SampleBoardView()
    
    private let gameModeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        segmentedControl.selectedSegmentIndex = Config.shared.gameMode == .easy ? 0 : Config.shared.gameMode == .medium ? 1 : 2
        segmentedControl.addTarget(self, action: #selector(gameModeChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let boardTilesNumberStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 14
        stepper.minimumValue = 2
        stepper.value = Double(Config.shared.boardTilesNumber)
        stepper.addTarget(self, action: #selector(boardTilesNumberChanged), for: .valueChanged)
        return stepper
    }()
    
    private let boardPaddingStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 2
        stepper.maximumValue = 20
        stepper.value = Double(Config.shared.boardPadding)
        stepper.addTarget(self, action: #selector(boardPaddingChanged), for: .valueChanged)
        return stepper
    }()
    
    private let tileGapStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 8
        stepper.value = Double(Config.shared.tileGap)
        stepper.addTarget(self, action: #selector(tileGapChanged), for: .valueChanged)
        return stepper
    }()
    
    private let boardCornerRadiusStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 16
        stepper.value = Double(Config.shared.boardCornerRadius)
        stepper.addTarget(self, action: #selector(boardCornerRadiusChanged), for: .valueChanged)
        return stepper
    }()
    
    private let bombSymbolSegmentedControl: UISegmentedControl = {
        let symbols = ["💣", "⭐️", "💥", "🔥", "👾", "🎃"]
        let segmentedControl = UISegmentedControl(items: symbols)
        segmentedControl.selectedSegmentIndex = symbols.firstIndex(of: Config.shared.bombSymbol) ?? 0
        segmentedControl.addTarget(self, action: #selector(bombSymbolChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let markBorderWidthStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 4
        stepper.value = Double(Config.shared.markBorderWidth)
        stepper.addTarget(self, action: #selector(markBorderWidthChanged), for: .valueChanged)
        return stepper
    }()
    
    private let hapticsEnabledSwitch: UISwitch = {
        let hapticsSwitch = UISwitch()
        hapticsSwitch.isOn = Config.shared.isHapticsEnabled
        hapticsSwitch.addTarget(self, action: #selector(hapticsEnabledChanged), for: .valueChanged)
        return hapticsSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(sampleBoardWrapperView)
        sampleBoardWrapperView.addSubview(sampleBoardView)
        
        sampleBoardWrapperView.translatesAutoresizingMaskIntoConstraints = false
        sampleBoardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sampleBoardWrapperView.topAnchor.constraint(equalTo: view.topAnchor),
            sampleBoardWrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sampleBoardWrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sampleBoardWrapperView.heightAnchor.constraint(equalToConstant: 240 + view.safeAreaInsets.top),
            
            sampleBoardView.centerXAnchor.constraint(equalTo: sampleBoardWrapperView.centerXAnchor),
            sampleBoardView.bottomAnchor.constraint(equalTo: sampleBoardWrapperView.bottomAnchor)
        ])
        
        view.addSubview(backButton)
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: sampleBoardWrapperView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            createSettingView(title: "Game Mode", control: gameModeSegmentedControl),
            createSettingView(title: "Board Tiles Number", control: boardTilesNumberStepper),
            createSettingView(title: "Board Padding", control: boardPaddingStepper),
            createSettingView(title: "Tile Gap", control: tileGapStepper),
            createSettingView(title: "Board Corner Radius", control: boardCornerRadiusStepper),
            createSettingView(title: "Bomb Symbol", control: bombSymbolSegmentedControl),
            createSettingView(title: "Mark Border Width", control: markBorderWidthStepper),
            createSettingView(title: "Haptics Enabled", control: hapticsEnabledSwitch)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func createSettingView(title: String, control: UIControl) -> UIView {
        let label = UILabel()
        label.text = title
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [label, control])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    @objc private func gameModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            config.gameMode = .easy
        case 1:
            config.gameMode = .medium
        case 2:
            config.gameMode = .hard
        default:
            break
        }
        sampleBoardView.configDidChange()
    }
    
    @objc private func boardTilesNumberChanged(_ sender: UIStepper) {
        config.boardTilesNumber = Int(sender.value)
        sampleBoardView.configDidChange()
    }
    
    @objc private func boardPaddingChanged(_ sender: UIStepper) {
        config.boardPadding = Int(sender.value)
        sampleBoardView.configDidChange()
    }
    
    @objc private func tileGapChanged(_ sender: UIStepper) {
        config.tileGap = Int(sender.value)
        sampleBoardView.configDidChange()
    }
    
    @objc private func boardCornerRadiusChanged(_ sender: UIStepper) {
        config.boardCornerRadius = Int(sender.value)
        sampleBoardView.configDidChange()
    }
    
    @objc private func bombSymbolChanged(_ sender: UISegmentedControl) {
        let symbols = ["💣", "⭐️", "💥", "🔥", "👾", "🎃"]
        config.bombSymbol = symbols[sender.selectedSegmentIndex]
        sampleBoardView.configDidChange()
    }
    
    @objc private func markBorderWidthChanged(_ sender: UIStepper) {
        config.markBorderWidth = Int(sender.value)
        sampleBoardView.configDidChange()
    }
    
    @objc private func hapticsEnabledChanged(_ sender: UISwitch) {
        config.isHapticsEnabled = sender.isOn
        sampleBoardView.configDidChange()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutBackButton()
    }
    
    private func layoutBackButton() {
        backButton.frame = CGRect(
            x: view.safeAreaInsets.left + 12,
            y: view.safeAreaInsets.top + 12,
            width: 48,
            height: 48
        )
    }
    
    @objc
    private func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
