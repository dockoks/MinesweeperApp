import UIKit

class SettingsViewController: UIViewController {
    
    private let config = Config.shared
    private let backButton = UIButton()
    private let sampleBoardWrapperView = UIView()
    private let sampleBoardView = SampleBoardView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(sampleBoardWrapperView)
        sampleBoardWrapperView.addSubview(sampleBoardView)
        
        view.addSubview(backButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        view.addSubview(tableView)
        
        setupBackButton()
        setupWrapperView()
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
        layoutWrapperView()
        layoutTableView()
        layoutSampleBoardView()
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
    
    private func layoutWrapperView() {
        let minEdge = min(view.bounds.height, view.bounds.width)
        sampleBoardWrapperView.frame = CGRect(
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
                y: sampleBoardWrapperView.frame.maxY,
                width: view.bounds.width,
                height: view.bounds.height - sampleBoardWrapperView.frame.maxY
            )
        } else {
            tableView.frame = CGRect(
                x: sampleBoardWrapperView.frame.maxX,
                y: 0,
                width: view.bounds.width - sampleBoardWrapperView.frame.maxX - view.safeAreaInsets.right,
                height: view.bounds.height
            )
        }
    }
    
    private func layoutSampleBoardView() {
        let sampleBoardSize = sampleBoardView.sizeThatFits(sampleBoardWrapperView.bounds.size)
        sampleBoardView.frame = CGRect(
            x: (sampleBoardWrapperView.bounds.width - sampleBoardSize.width) / 2,
            y: (sampleBoardWrapperView.bounds.height - sampleBoardSize.height) / 2,
            width: sampleBoardSize.width,
            height: sampleBoardSize.height
        )
    }
    
    private func setupWrapperView() {
        sampleBoardWrapperView.backgroundColor = Config.shared.markBorderColor.withAlphaComponent(0.3)
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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableViewCell
        let control: UIControl
        let title: String
        let value: String
        
        switch indexPath.row {
        case 0:
            title = "Game Mode"
            control = UISegmentedControl(items: Config.shared.modes)
            (control as! UISegmentedControl).selectedSegmentIndex = config.gameMode.rawValue
            (control as! UISegmentedControl).addTarget(self, action: #selector(gameModeChanged(_:)), for: .valueChanged)
            value = config.modes[config.gameMode.rawValue]
        case 1:
            title = "Board Tiles Number"
            control = UIStepper()
            (control as! UIStepper).maximumValue = 14
            (control as! UIStepper).minimumValue = 2
            (control as! UIStepper).value = Double(config.boardTilesNumber)
            (control as! UIStepper).addTarget(self, action: #selector(boardTilesNumberChanged(_:)), for: .valueChanged)
            value = "\(config.boardTilesNumber)"
        case 2:
            title = "Board Padding"
            control = UIStepper()
            (control as! UIStepper).maximumValue = 20
            (control as! UIStepper).minimumValue = 2
            (control as! UIStepper).value = Double(config.boardPadding)
            (control as! UIStepper).addTarget(self, action: #selector(boardPaddingChanged(_:)), for: .valueChanged)
            value = "\(config.boardPadding)"
        case 3:
            title = "Tile Gap"
            control = UIStepper()
            (control as! UIStepper).maximumValue = 8
            (control as! UIStepper).minimumValue = 1
            (control as! UIStepper).value = Double(config.tileGap)
            (control as! UIStepper).addTarget(self, action: #selector(tileGapChanged(_:)), for: .valueChanged)
            value = "\(config.tileGap)"
        case 4:
            title = "Board Corner Radius"
            control = UIStepper()
            (control as! UIStepper).maximumValue = 16
            (control as! UIStepper).minimumValue = 0
            (control as! UIStepper).value = Double(config.boardCornerRadius)
            (control as! UIStepper).addTarget(self, action: #selector(boardCornerRadiusChanged(_:)), for: .valueChanged)
            value = "\(config.boardCornerRadius)"
        case 5:
            title = "Bomb Symbol"
            control = UISegmentedControl(items: Config.shared.bombSymbols)
            (control as! UISegmentedControl).selectedSegmentIndex = Config.shared.bombSymbols.firstIndex(of: config.bombSymbol) ?? 0
            (control as! UISegmentedControl).addTarget(self, action: #selector(bombSymbolChanged(_:)), for: .valueChanged)
            value = config.bombSymbol
        case 6:
            title = "Mark Border Width"
            control = UIStepper()
            (control as! UIStepper).maximumValue = 4
            (control as! UIStepper).minimumValue = 1
            (control as! UIStepper).value = Double(config.markBorderWidth)
            (control as! UIStepper).addTarget(self, action: #selector(markBorderWidthChanged(_:)), for: .valueChanged)
            value = "\(config.markBorderWidth)"
        case 7:
            title = "Haptics Enabled"
            control = UISwitch()
            (control as! UISwitch).isOn = config.isHapticsEnabled
            (control as! UISwitch).addTarget(self, action: #selector(hapticsEnabledChanged(_:)), for: .valueChanged)
            value = config.isHapticsEnabled ? "On" : "Off"
        default:
            title = ""
            control = UIControl()
            value = ""
        }
        
        cell.configure(title: title, control: control, value: value)
        
        return cell
    }
    
    @objc private func gameModeChanged(_ sender: UISegmentedControl) {
        config.gameMode = GameMode(rawValue: sender.selectedSegmentIndex) ?? .easy
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func boardTilesNumberChanged(_ sender: UIStepper) {
        config.boardTilesNumber = Int(sender.value)
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func boardPaddingChanged(_ sender: UIStepper) {
        config.boardPadding = Int(sender.value)
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func tileGapChanged(_ sender: UIStepper) {
        config.tileGap = Int(sender.value)
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func boardCornerRadiusChanged(_ sender: UIStepper) {
        config.boardCornerRadius = Int(sender.value)
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func bombSymbolChanged(_ sender: UISegmentedControl) {
        config.bombSymbol = Config.shared.bombSymbols[sender.selectedSegmentIndex]
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func markBorderWidthChanged(_ sender: UIStepper) {
        config.markBorderWidth = Int(sender.value)
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
    
    @objc private func hapticsEnabledChanged(_ sender: UISwitch) {
        config.isHapticsEnabled = sender.isOn
        sampleBoardView.configDidChange()
        tableView.reloadData()
    }
}
