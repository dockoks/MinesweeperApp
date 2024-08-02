import UIKit

enum TilePreview {
    case bomb
    case marked
    case closed
}

class SampleBoardView: UIView, ConfigDelegate {
    enum Constants {
        static let tileSize: CGFloat = 48
    }
    
    let tile1 = UIButton()
    let tile2 = UIButton()
    let tile3 = UIButton()
    let tile4 = UIButton()
    
    let labelLeft = UILabel()
    let labelRight = UILabel()
    let labelUp = UILabel()
    let labelDown = UILabel()
    
    let boardView = UIView()
    let wrapperView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Config.shared.delegate = self
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let gap = CGFloat(Config.shared.tileGap)
        let padding = CGFloat(Config.shared.boardPadding)
        let height = labelUp.intrinsicContentSize.height + labelDown.intrinsicContentSize.height + Constants.tileSize * 2 + padding * 4 + gap * 3
        let width = labelLeft.intrinsicContentSize.width + labelRight.intrinsicContentSize.width + Constants.tileSize * 2 + padding * 4 + gap * 3
        return CGSize(width: width, height: height)
    }
    
    private func setupView() {
        configureLabels()
        configureTiles()
        configureBoardView()
        configureWrapperView()
        
        self.addSubview(wrapperView)
        
        wrapperView.addSubview(boardView)
        wrapperView.addSubview(labelUp)
        wrapperView.addSubview(labelDown)
        wrapperView.addSubview(labelLeft)
        wrapperView.addSubview(labelRight)
        
        boardView.addSubview(tile1)
        boardView.addSubview(tile2)
        boardView.addSubview(tile3)
        boardView.addSubview(tile4)
    }
    
    private func configureBoardView() {
        boardView.backgroundColor = UIColor(named: Config.shared.boardColor)
        boardView.layer.cornerRadius = CGFloat(Config.shared.boardCornerRadius)
        boardView.layer.cornerCurve = .continuous
    }
    
    private func configureLabels() {
        [labelUp, labelDown, labelLeft, labelRight].forEach {
            $0.text = "\(Config.shared.boardTilesNumber)"
            $0.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
            $0.textColor = .secondaryLabel
        }
    }
    
    private func configureTiles() {
        configureTile(tile1, of: .bomb)
        configureTile(tile2, of: .closed)
        configureTile(tile3, of: .marked)
        configureTile(tile4, of: .closed)
    }
    
    private func configureWrapperView() {
        let markBorderColor = Config.shared.markBorderColor
        if traitCollection.userInterfaceStyle == .dark {
            wrapperView.backgroundColor = UIColor(named: markBorderColor)?.withAlphaComponent(0.1) ?? .clear
        } else {
            wrapperView.backgroundColor = UIColor(named: markBorderColor)?.withAlphaComponent(0.3) ?? .clear
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = CGFloat(Config.shared.boardPadding)
        let tileGap = CGFloat(Config.shared.tileGap)
        let boardSize = Constants.tileSize * 2 + tileGap * 3
        
        let wrapperSize = min(self.bounds.width, self.bounds.height)
        let wrapperOriginX = (self.bounds.width - wrapperSize) / 2
        let wrapperOriginY = (self.bounds.height - wrapperSize) / 2
        
        wrapperView.frame = CGRect(
            x: wrapperOriginX,
            y: wrapperOriginY,
            width: wrapperSize,
            height: wrapperSize
        )
        
        configureTiles()
        configureLabels()
        configureBoardView()
        configureWrapperView()
        
        boardView.frame = CGRect(
            x: (wrapperView.bounds.width - boardSize) / 2,
            y: (wrapperView.bounds.height - boardSize) / 2,
            width: boardSize,
            height: boardSize
        )
        
        tile1.frame = CGRect(
            x: tileGap,
            y: tileGap,
            width: Constants.tileSize,
            height: Constants.tileSize
        )
        
        tile2.frame = CGRect(
            x: tileGap * 2 + Constants.tileSize,
            y: tileGap,
            width: Constants.tileSize,
            height: Constants.tileSize
        )
        
        tile3.frame = CGRect(
            x: tileGap,
            y: tileGap * 2 + Constants.tileSize,
            width: Constants.tileSize,
            height: Constants.tileSize
        )
        
        tile4.frame = CGRect(
            x: tileGap * 2 + Constants.tileSize,
            y: tileGap * 2 + Constants.tileSize,
            width: Constants.tileSize,
            height: Constants.tileSize
        )
        
        labelUp.frame = CGRect(
            x: (wrapperView.frame.maxX - labelUp.intrinsicContentSize.width) / 2,
            y: boardView.frame.minY - padding - labelUp.intrinsicContentSize.height,
            width: labelUp.intrinsicContentSize.width,
            height: labelUp.intrinsicContentSize.height
        )
        
        labelDown.frame = CGRect(
            x: (wrapperView.frame.maxX - labelUp.intrinsicContentSize.width) / 2,
            y: boardView.frame.maxY + padding,
            width: labelDown.intrinsicContentSize.width,
            height: labelDown.intrinsicContentSize.height
        )
        
        labelLeft.frame = CGRect(
            x: boardView.frame.minX - padding - labelLeft.intrinsicContentSize.width,
            y: (wrapperView.frame.maxY - labelUp.intrinsicContentSize.height) / 2,
            width: labelLeft.intrinsicContentSize.width,
            height: labelLeft.intrinsicContentSize.height
        )
        
        labelRight.frame = CGRect(
            x: boardView.frame.maxX + padding,
            y: (wrapperView.frame.maxY - labelUp.intrinsicContentSize.height) / 2,
            width: labelRight.intrinsicContentSize.width,
            height: labelRight.intrinsicContentSize.height
        )
    }
    
    private func configureTile(_ button: UIButton, of type: TilePreview) {
        button.layer.cornerRadius = CGFloat(Config.shared.tileCornerRadius)
        button.layer.cornerCurve = .continuous
        
        switch type {
        case .bomb:
            button.setTitle("\(Config.shared.bombSymbol)", for: .normal)
            button.backgroundColor = UIColor(named: Config.shared.bombTileColor)
        case .marked:
            button.backgroundColor = UIColor(named: Config.shared.closedTileColor)
            button.layer.borderWidth = CGFloat(Config.shared.markBorderWidth)
            button.layer.borderColor = UIColor(named: Config.shared.markBorderColor)?.cgColor
        case .closed:
            button.backgroundColor = UIColor(named: Config.shared.closedTileColor)
        }
    }
    
    func configDidChange() {
        UIView.animate(withDuration: 0.1) {
            self.layoutSubviews()
        }
    }
}
