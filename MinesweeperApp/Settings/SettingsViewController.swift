import UIKit

class SettingsViewController: UIViewController {
    
    private let config = Config.shared
    private let backButton = UIButton()
    private let sampleBoardView = SampleBoardView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(sampleBoardView)
        view.addSubview(backButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        tableView.contentInset = .init(top: view.safeAreaInsets.bottom, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        tableView.contentOffset.y = -view.safeAreaInsets.bottom
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        setupBackButton()
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
        layoutSampleBoardView()
        layoutTableView()
    }
    
    private func setupBackButton() {
        let imageConfig = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .label
        backButton.backgroundColor = .systemFill
        backButton.layer.cornerRadius = CGFloat(Config.shared.boardCornerRadius)
        backButton.layer.cornerCurve = .continuous
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    
    private func layoutBackButton() {
        backButton.frame = CGRect(
            x: view.safeAreaInsets.left + 12,
            y: view.safeAreaInsets.top + 12,
            width: 48,
            height: 48
        )
    }
    
    private func layoutSampleBoardView() {
        let minEdge = min(view.bounds.height, view.bounds.width)
        sampleBoardView.frame = CGRect(
            x: 0,
            y: 0,
            width: minEdge,
            height: minEdge
        )
    }
    
    private func layoutTableView() {
        let minEdge = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        if (minEdge == UIScreen.main.bounds.width) {
            tableView.frame = CGRect(
                x: 0,
                y: sampleBoardView.frame.maxY,
                width: view.bounds.width,
                height: view.bounds.height - sampleBoardView.frame.maxY
            )
        } else {
            tableView.frame = CGRect(
                x: sampleBoardView.frame.maxX,
                y: 0,
                width: view.bounds.width - sampleBoardView.frame.maxX - view.safeAreaInsets.right,
                height: view.bounds.height
            )
        }
        tableView.contentInset = .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
    @objc
    private func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        var control: UIControl = UIControl()
        var title: String = ""
        var value: String = ""
        
        switch indexPath.row {
        case 0:
            title = "Game Mode"
            let segmentedControl = UISegmentedControl(items: Config.gameModeOptions)
            segmentedControl.selectedSegmentIndex = config.gameMode.rawValue
            segmentedControl.addTarget(self, action: #selector(gameModeChanged(_:)), for: .valueChanged)
            control = segmentedControl
            value = Config.gameModeOptions[config.gameMode.rawValue]
        case 1:
            title = "Board Tiles Number"
            let stepper = UIStepper()
            stepper.maximumValue = 14
            stepper.minimumValue = 2
            stepper.value = Double(config.boardTilesNumber)
            stepper.addTarget(self, action: #selector(boardTilesNumberChanged(_:)), for: .valueChanged)
            control = stepper
            value = "\(config.boardTilesNumber)"
        case 2:
            title = "Board Padding"
            let stepper = UIStepper()
            stepper.maximumValue = 12
            stepper.minimumValue = 2
            stepper.value = Double(config.boardPadding)
            stepper.addTarget(self, action: #selector(boardPaddingChanged(_:)), for: .valueChanged)
            control = stepper
            value = "\(config.boardPadding)"
        case 3:
            title = "Tile Gap"
            let stepper = UIStepper()
            stepper.maximumValue = 8
            stepper.minimumValue = 1
            stepper.value = Double(config.tileGap)
            stepper.addTarget(self, action: #selector(tileGapChanged(_:)), for: .valueChanged)
            control = stepper
            value = "\(config.tileGap)"
        case 4:
            title = "Board Corner Radius"
            let stepper = UIStepper()
            stepper.maximumValue = 12
            stepper.minimumValue = 0
            stepper.value = Double(config.boardCornerRadius)
            stepper.addTarget(self, action: #selector(boardCornerRadiusChanged(_:)), for: .valueChanged)
            control = stepper
            value = "\(config.boardCornerRadius)"
        case 5:
            title = "Bomb Symbol"
            let segmentedControl = UISegmentedControl(items: Config.bombSymbolOptions)
            segmentedControl.selectedSegmentIndex = Config.bombSymbolOptions.firstIndex(of: config.bombSymbol) ?? 0
            segmentedControl.addTarget(self, action: #selector(bombSymbolChanged(_:)), for: .valueChanged)
            control = segmentedControl
            value = config.bombSymbol
        case 6:
            title = "Mark Border Width"
            let stepper = UIStepper()
            stepper.maximumValue = 3
            stepper.minimumValue = 1
            stepper.value = Double(config.markBorderWidth)
            stepper.addTarget(self, action: #selector(markBorderWidthChanged(_:)), for: .valueChanged)
            control = stepper
            value = "\(config.markBorderWidth)"
        case 7:
            title = "Mark Border Color"
            let segmentedControl = UISegmentedControl(items: Config.markColorOptions)
            segmentedControl.selectedSegmentIndex = Config.markColorOptions.firstIndex(of: config.markBorderColor) ?? 0
            segmentedControl.addTarget(self, action: #selector(markBorderColorChanged(_:)), for: .valueChanged)
            control = segmentedControl
            value = config.markBorderColor
        case 8:
            title = "Haptics Enabled"
            let switchControl = UISwitch()
            switchControl.isOn = config.isHapticsEnabled
            switchControl.addTarget(self, action: #selector(hapticsEnabledChanged(_:)), for: .valueChanged)
            control = switchControl
            value = config.isHapticsEnabled ? "On" : "Off"
        default:
            title = ""
            control = UIControl()
            value = ""
        }
        
        cell.configure(title: title, control: control, value: value)
        
        return cell
    }
    
    func updateCell(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingTableViewCell else { return }
        
        let valueText: String
        switch indexPath.row {
        case 0: valueText = Config.gameModeOptions[config.gameMode.rawValue]
        case 1: valueText = "\(config.boardTilesNumber)"
        case 2: valueText = "\(config.boardPadding)"
        case 3: valueText = "\(config.tileGap)"
        case 4: valueText = "\(config.boardCornerRadius)"
        case 5: valueText = config.bombSymbol
        case 6: valueText = "\(config.markBorderWidth)"
        case 7: valueText = config.markBorderColor.description
        case 8: valueText = config.isHapticsEnabled ? "On" : "Off"
        default: valueText = ""
        }
        
        cell.valueLabel.text = valueText
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        98
    }
    
    @objc
    private func gameModeChanged(_ sender: UISegmentedControl) {
        config.gameMode = GameMode(rawValue: sender.selectedSegmentIndex) ?? .easy
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 0, section: 0))
    }
    
    @objc
    private func boardTilesNumberChanged(_ sender: UIStepper) {
        config.boardTilesNumber = Int(sender.value)
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 1, section: 0))
    }
    
    @objc
    private func boardPaddingChanged(_ sender: UIStepper) {
        config.boardPadding = Int(sender.value)
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 2, section: 0))
    }
    
    @objc
    private func tileGapChanged(_ sender: UIStepper) {
        config.tileGap = Int(sender.value)
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 3, section: 0))
    }
    
    @objc
    private func boardCornerRadiusChanged(_ sender: UIStepper) {
        config.boardCornerRadius = Int(sender.value)
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 4, section: 0))
    }
    
    @objc
    private func bombSymbolChanged(_ sender: UISegmentedControl) {
        config.bombSymbol = Config.bombSymbolOptions[sender.selectedSegmentIndex]
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 5, section: 0))
    }
    
    @objc
    private func markBorderWidthChanged(_ sender: UIStepper) {
        config.markBorderWidth = Int(sender.value)
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 6, section: 0))
    }
    
    @objc
    private func markBorderColorChanged(_ sender: UISegmentedControl) {
        config.markBorderColor = Config.markColorOptions[sender.selectedSegmentIndex]
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 7, section: 0))
    }
    
    @objc
    private func hapticsEnabledChanged(_ sender: UISwitch) {
        config.isHapticsEnabled = sender.isOn
        sampleBoardView.configDidChange()
        updateCell(at: IndexPath(row: 8, section: 0))
    }
}
