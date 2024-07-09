import UIKit

class SampleBoardView: UIView {
    let tile1: UIButton = {}()
    let tile2: UIButton = {}()
    let tile3: UIButton = {}()
    let tile4: UIButton = {}()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = Config.shared.bombTileColor.withAlphaComponent(0.3)
        
        
        
        let verticalSV = UIStackView()
        
        let horisontalSV = UIStackView()
    }
    
    private func make2by2BordView() -> UIView {
        let stackView1 = UIStackView(arrangedSubviews: [tile1, tile2])
        let stackView2 = UIStackView(arrangedSubviews: [tile3, tile4])
        let boradSW = UIStackView(arrangedSubviews: [stackView1, stackView2])
        
        
    }
}

class SettingsViewController: UIViewController {
    
    private let config = Config.shared
    
    private let gameModeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Easy", "Medium", "Hard"])
        segmentedControl.selectedSegmentIndex = Config.shared.gameMode == .easy ? 0 : Config.shared.gameMode == .medium ? 1 : 2
        segmentedControl.addTarget(self, action: #selector(gameModeChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    private let boardTilesNumberStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 14
        stepper.value = Double(Config.shared.boardTilesNumber)
        stepper.addTarget(self, action: #selector(boardTilesNumberChanged), for: .valueChanged)
        return stepper
    }()
    
    private let boardPaddingStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 20
        stepper.value = Double(Config.shared.boardPadding)
        stepper.addTarget(self, action: #selector(boardPaddingChanged), for: .valueChanged)
        return stepper
    }()
    
    private let tileGapStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 12
        stepper.value = Double(Config.shared.tileGap)
        stepper.addTarget(self, action: #selector(tileGapChanged), for: .valueChanged)
        return stepper
    }()
    
    private let boardCornerRadiusStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 20
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
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
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
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func createSettingView(title: String, control: UIControl) -> UIView {
        let label = UILabel()
        label.text = title
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [label, control])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }
    
    @objc 
    private func gameModeChanged(_ sender: UISegmentedControl) {
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
    }
    
    @objc 
    private func boardTilesNumberChanged(_ sender: UIStepper) {
        config.boardTilesNumber = Int(sender.value)
    }
    
    @objc 
    private func boardPaddingChanged(_ sender: UIStepper) {
        config.boardPadding = Int(sender.value)
    }
    
    @objc 
    private func tileGapChanged(_ sender: UIStepper) {
        config.tileGap = Int(sender.value)
    }
    
    @objc 
    private func boardCornerRadiusChanged(_ sender: UIStepper) {
        config.boardCornerRadius = Int(sender.value)
    }
    
    @objc 
    private func bombSymbolChanged(_ sender: UISegmentedControl) {
        let symbols = ["💣", "⭐️", "💥", "🔥", "👾", "🎃"]
        config.bombSymbol = symbols[sender.selectedSegmentIndex]
    }
    
    @objc 
    private func markBorderWidthChanged(_ sender: UIStepper) {
        config.markBorderWidth = Int(sender.value)
    }
    
    @objc 
    private func hapticsEnabledChanged(_ sender: UISwitch) {
        config.isHapticsEnabled = sender.isOn
    }
}
