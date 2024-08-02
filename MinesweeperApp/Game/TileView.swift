import UIKit

enum TileType {
    case undiscovered
    case bomb
    case bombNearby(Int)
}

struct TileCoordinate {
    let x: Int
    let y: Int
    
    var west: TileCoordinate {
        TileCoordinate(x: x-1, y: y)
    }
    
    var north: TileCoordinate {
        TileCoordinate(x: x, y: y-1)
    }
    
    var south: TileCoordinate {
        TileCoordinate(x: x, y: y+1)
    }
    
    var east: TileCoordinate {
        TileCoordinate(x: x+1, y: y)
    }
    
    var northEast: TileCoordinate {
        TileCoordinate(x: x+1, y: y-1)
    }
    
    var southEast: TileCoordinate {
        TileCoordinate(x: x+1, y: y+1)
    }
    
    var southWest: TileCoordinate {
        TileCoordinate(x: x-1, y: y+1)
    }

    var northWest: TileCoordinate {
        TileCoordinate(x: x-1, y: y-1)
    }
}

class TileView: UIView {
    private let label = UILabel()
    
    let coordinate: TileCoordinate
    
    var bombsNearby: Int = 0
    var isBomb: Bool = false
    var isRevealed: Bool = false
    var isMarked: Bool = false

    init(coordinate: TileCoordinate) {
        self.coordinate = coordinate
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
    
    func setupView() {
        self.backgroundColor = UIColor(named: Config.shared.closedTileColor)
        self.layer.cornerRadius = CGFloat(Config.shared.tileCornerRadius)
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
    }
    
    func configure(type: TileType) {
        self.addSubview(label)
        switch type {
        case .undiscovered:
            label.text = ""
        case .bomb:
            label.text = Config.shared.bombSymbol
            label.font = .systemFont(ofSize: max(12, self.frame.height/3))
            label.textColor = .label
            label.textAlignment = .center
            label.isHidden = false
        case .bombNearby(let numberOfBombs):
            if !self.isBomb && numberOfBombs > 0 {
                label.text = "\(numberOfBombs)"
                label.font = .systemFont(ofSize: max(12, self.frame.height/3))
                label.textColor = UIColor(named: Config.shared.bombsNearbyColor)
                label.textAlignment = .center
                label.isHidden = true
            }
        }
    }
    
    func revealTile(isDetonated: Bool = false) {
        self.isRevealed = true
        self.isMarked = false
        if Config.shared.isHapticsEnabled {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            if isDetonated {
                self.backgroundColor = UIColor(named: Config.shared.explodingBombTileColor)
            } else if self.isBomb {
                self.backgroundColor = UIColor(named: Config.shared.bombTileColor)
            } else {
                self.backgroundColor = .tertiarySystemFill
                self.label.isHidden = false
            }
        }, completion: nil)
    }
    
    func toggleMark() {
        guard !isRevealed else { return }
        isMarked.toggle()
        UIView.animate(withDuration: 0.3) {
            self.layer.borderWidth = self.isMarked ? CGFloat(Config.shared.markBorderWidth) : 0
            self.layer.borderColor = self.isMarked ? UIColor(named: Config.shared.markBorderColor)?.cgColor : UIColor.clear.cgColor
        }
    }
    
    func performRotationalShake() {
        let shake = CAKeyframeAnimation(keyPath: "transform.rotation")
        shake.values = [0, 0.15, -0.15, 0.10, -0.10, 0.05, -0.05, 0]
        shake.duration = 0.3
        shake.isAdditive = true
        self.layer.add(shake, forKey: "shake")
    }
}
