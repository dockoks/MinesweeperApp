import UIKit

final class BoardView: UIView {
    enum Constants {
        static let easyGameModeFactor: CGFloat = 10
        static let mediumGameModeFactor: CGFloat = 8
        static let hardGameModeFactor: CGFloat = 6
    }
    
    private let tileGap: Double = Double(Config.shared.tileGap)
    private var tiles: [TileView] = []
    private var numberOfTiles: Int {
        size * size
    }
    private let numberOfBombs: Int
    private var tileSize: CGSize {
        CGSize(
            width: (self.bounds.width - tileGap * CGFloat(size + 1)) / CGFloat(size),
            height: (self.bounds.height - tileGap * CGFloat(size + 1)) / CGFloat(size)
        )
    }
    
    let size: Int = Config.shared.boardTilesNumber
    var isFlaggingMode: Bool = false
    
    init(
        gameMode: GameMode
    ) {
        switch gameMode {
        case .easy:
            numberOfBombs = Int((CGFloat(size * size) / Constants.easyGameModeFactor).rounded(.up))
        case .medium:
            numberOfBombs = Int((CGFloat(size * size) / Constants.mediumGameModeFactor).rounded(.up))
        case .hard:
            numberOfBombs = Int((CGFloat(size * size) / Constants.hardGameModeFactor).rounded(.up))
        }
        
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: Config.shared.boardColor)
        self.layer.cornerRadius = CGFloat(Config.shared.boardCornerRadius)
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        
        generateBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateBoard() {
        var tileX = 0
        var tileY = 0
        
        for _ in 0..<numberOfTiles {
            let coordinate = TileCoordinate(x: tileX, y: tileY)
            let tile = TileView(coordinate: coordinate)
            tile.configure(type: .undiscovered)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTileTap))
            tile.addGestureRecognizer(tapGesture)
            
            self.addSubview(tile)
            tiles.append(tile)
            
            tileX += 1
            if tileX >= size {
                tileX = 0
                tileY += 1
            }
        }
        
        var bombs: [TileView] = []
        
        while bombs.count < numberOfBombs {
            guard let tile = tiles.randomElement() else { break }
            guard !tile.isBomb else { continue }
            tile.isBomb = true
            bombs.append(tile)
        }
    }
    
    private func reveal(tile: TileView) {
        guard !tile.isMarked && !tile.isRevealed else { return }
        
        let bombsNearby = numberOfAdjacentBombs(for: tile)
        tile.configure(type: .bombNearby(bombsNearby))
        tile.revealTile()
        if bombsNearby == 0 {
            for adjacentTile in adjacentTiles(for: tile).filter({ !$0.isRevealed && !$0.isMarked }) {
                if !adjacentTile.isBomb {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                        self.reveal(tile: adjacentTile)
                    }
                }
            }
        }
        checkForWin()
    }
    
    private func adjacentTiles(for tile: TileView) -> [TileView] {
        [
            tileAt(coordinate: tile.coordinate.west),
            tileAt(coordinate: tile.coordinate.north),
            tileAt(coordinate: tile.coordinate.east),
            tileAt(coordinate: tile.coordinate.south),
            tileAt(coordinate: tile.coordinate.northWest),
            tileAt(coordinate: tile.coordinate.northEast),
            tileAt(coordinate: tile.coordinate.southWest),
            tileAt(coordinate: tile.coordinate.southEast)
        ].compactMap { $0 }
    }
    
    private func numberOfAdjacentBombs(for tile: TileView) -> Int {
        return adjacentTiles(for: tile).filter { $0.isBomb }.count
    }
    
    private func tileAt(coordinate: TileCoordinate) -> TileView? {
        guard (0..<size).contains(coordinate.x) && (0..<size).contains(coordinate.y) else { return nil }
        let tileIndex = coordinate.y * size + coordinate.x
        return tiles[tileIndex]
    }
    
    private func gameOver(detonatedTile: TileView) {
        for tile in tiles {
            if tile == detonatedTile {
                tile.configure(type: .bomb)
                tile.revealTile(isDetonated: true)
            } else if tile.isBomb {
                tile.configure(type: .bomb)
                tile.revealTile()
            } else {
                let bombsNearby = numberOfAdjacentBombs(for: tile)
                tile.configure(type: .bombNearby(bombsNearby))
                tile.revealTile()
            }
        }

        if let viewController = findViewController() as? GameViewController  {
            let alert = UIAlertController(
                title: "Game Over",
                message: "You hit a bomb. Try again!",
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.resetBoard()
                viewController.changeSubviewColor(color: .systemBackground)
            }
            alert.addAction(action)
            viewController.changeSubviewColor(color: UIColor(named: "Over")?.withAlphaComponent(0.2))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func checkForWin() {
        let isGameWon = tiles.allSatisfy { $0.isBomb || $0.isRevealed }
        if isGameWon {
            if let viewController = findViewController() as? GameViewController {
                let alert = UIAlertController(
                    title: "You Won!",
                    message: "Congratulations, you've cleared the board!",
                    preferredStyle: .alert
                )
                let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.resetBoard()
                    viewController.changeSubviewColor(color: .systemBackground)
                })
                alert.addAction(action)
                viewController.changeSubviewColor(color: UIColor(named: "Win")?.withAlphaComponent(0.2))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    private func resetBoard() {
        tiles.forEach { $0.removeFromSuperview() }
        tiles.removeAll()
        generateBoard()
        repositionBoard(to: self.frame.size)
    }
    
    func repositionBoard(to size: CGSize) {
        self.frame = CGRect(
            origin: CGPoint(
                x: (UIScreen.main.bounds.width - size.width) / 2,
                y: (UIScreen.main.bounds.height - size.height) / 2
            ),
            size: size
        )
        
        var col: Int = 0
        var row: Int = 0
        
        tiles.forEach {
            let x = self.bounds.minX + CGFloat(col) * tileSize.width + tileGap + CGFloat(col) * tileGap
            let y = self.bounds.minY + CGFloat(row) * tileSize.width + tileGap + CGFloat(row) * tileGap
            
            $0.frame = CGRect(
                x: x,
                y: y,
                width: tileSize.width,
                height: tileSize.height
            )
            
            col += 1
            if col >= self.size {
                col = 0
                row += 1
            }
        }
    }
    
    @objc private func handleTileTap(_ sender: UITapGestureRecognizer) {
        guard let tile = sender.view as? TileView else { return }
        if isFlaggingMode {
            tile.toggleMark()
        } else {
            if tile.isRevealed || tile.isMarked {
                tile.performRotationalShake()
            } else {
                if tile.isBomb {
                    gameOver(detonatedTile: tile)
                } else {
                    reveal(tile: tile)
                }
            }
        }
    }
}
