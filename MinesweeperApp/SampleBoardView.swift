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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        [labelUp, labelDown, labelLeft, labelRight].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "\(Config.shared.boardTilesNumber)"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .secondaryLabel
        }
        
        let boardView = makeSampleBoardView()
        boardView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(boardView)
        self.addSubview(labelUp)
        self.addSubview(labelDown)
        self.addSubview(labelLeft)
        self.addSubview(labelRight)
        
        let padding = CGFloat(Config.shared.boardPadding)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boardView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            boardView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            labelUp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelUp.bottomAnchor.constraint(equalTo: boardView.topAnchor, constant: -padding),
            
            labelDown.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelDown.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: padding),
            
            labelLeft.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelLeft.rightAnchor.constraint(equalTo: boardView.leftAnchor, constant: -padding),
            
            labelRight.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelRight.leftAnchor.constraint(equalTo: boardView.rightAnchor, constant: padding)
        ])
    }
    
    private func configureTile(_ button: UIButton, of type: TilePreview) {
        button.layer.cornerRadius = CGFloat(Config.shared.tileCornerRadius)
        button.layer.cornerCurve = .continuous
        
        switch type {
        case .bomb:
            button.setTitle("\(Config.shared.bombSymbol)", for: .normal)
            button.backgroundColor = Config.shared.bombTileColor
        case .marked:
            button.backgroundColor = Config.shared.closedTileColor
            button.layer.borderWidth = CGFloat(Config.shared.markBorderWidth)
            button.layer.borderColor = Config.shared.markBorderColor.cgColor
        case .closed:
            button.backgroundColor = Config.shared.closedTileColor
        }
    }
    
    private func makeSampleBoardView() -> UIView {
        configureTile(tile1, of: .bomb)
        configureTile(tile2, of: .closed)
        configureTile(tile3, of: .marked)
        configureTile(tile4, of: .closed)
        
        let boardView = UIView()
        boardView.backgroundColor = Config.shared.boardColor
        boardView.layer.cornerRadius = CGFloat(Config.shared.boardCornerRadius)
        boardView.layer.cornerCurve = .continuous
        
        [tile1, tile2, tile3, tile4].forEach {
            boardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tileGap = CGFloat(Config.shared.tileGap)
        
        NSLayoutConstraint.activate([
            tile1.topAnchor.constraint(equalTo: boardView.topAnchor, constant: tileGap),
            tile1.leftAnchor.constraint(equalTo: boardView.leftAnchor, constant: tileGap),
            tile1.heightAnchor.constraint(equalToConstant: Constants.tileSize),
            tile1.widthAnchor.constraint(equalToConstant: Constants.tileSize),
            
            tile2.topAnchor.constraint(equalTo: boardView.topAnchor, constant: tileGap),
            tile2.leftAnchor.constraint(equalTo: tile1.rightAnchor, constant: tileGap),
            tile2.heightAnchor.constraint(equalToConstant: Constants.tileSize),
            tile2.widthAnchor.constraint(equalToConstant: Constants.tileSize),
            
            tile3.topAnchor.constraint(equalTo: tile1.bottomAnchor, constant: tileGap),
            tile3.leftAnchor.constraint(equalTo: boardView.leftAnchor, constant: tileGap),
            tile3.heightAnchor.constraint(equalToConstant: Constants.tileSize),
            tile3.widthAnchor.constraint(equalToConstant: Constants.tileSize),
            
            tile4.topAnchor.constraint(equalTo: tile2.bottomAnchor, constant: tileGap),
            tile4.leftAnchor.constraint(equalTo: tile3.rightAnchor, constant: tileGap),
            tile4.heightAnchor.constraint(equalToConstant: Constants.tileSize),
            tile4.widthAnchor.constraint(equalToConstant: Constants.tileSize),
            
            boardView.heightAnchor.constraint(equalToConstant: Constants.tileSize * 2 + tileGap * 3),
            boardView.widthAnchor.constraint(equalToConstant: Constants.tileSize * 2 + tileGap * 3)
        ])
        
        return boardView
    }
    
    func configDidChange() {
        subviews.forEach { $0.removeFromSuperview() }
        setupView()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
