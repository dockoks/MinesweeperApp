import UIKit

enum GameMode: Int {
    case easy
    case medium
    case hard
}

protocol ConfigDelegate: AnyObject {
    func configDidChange()
}

final class Config {
    
    let modes = ["Easy", "Medium", "Hard"]
    let bombSymbols = ["💣", "⭐️", "💥", "🔥", "👾", "🎃"]
    
    weak var delegate: ConfigDelegate?
    
    // Game options
    var gameMode: GameMode {
        didSet { notifyDelegate() }
    }
    var boardTilesNumber: Int {
        didSet { notifyDelegate() }
    }
    
    // Insets
    var boardPadding: Int {
        didSet { notifyDelegate() }
    }
    var tileGap: Int {
        didSet {
            updateTileCornerRadius()
            notifyDelegate()
        }
    }
    
    var boardCornerRadius: Int {
        didSet {
            updateTileCornerRadius()
            notifyDelegate()
        }
    }
    var tileCornerRadius: Int = 0 {
        didSet { notifyDelegate() }
    }
    
    // Colors
    var boardColor: UIColor {
        didSet { notifyDelegate() }
    }
    var closedTileColor: UIColor {
        didSet { notifyDelegate() }
    }
    var openedTileColor: UIColor {
        didSet { notifyDelegate() }
    }
    var bombTileColor: UIColor {
        didSet { notifyDelegate() }
    }
    var explodingBombTileColor: UIColor {
        didSet { notifyDelegate() }
    }
    var bombsNearbyColor: UIColor {
        didSet { notifyDelegate() }
    }
    var markBorderColor: UIColor {
        didSet { notifyDelegate() }
    }
    var bombSymbol: String {
        didSet { notifyDelegate() }
    }
    var markBorderWidth: Int {
        didSet { notifyDelegate() }
    }
    
    // Application Specifics
    var isHapticsEnabled: Bool {
        didSet { notifyDelegate() }
    }
    
    // Initialisation
    private init(
        gameMode: GameMode,
        boardTilesNumber: Int,
        boardPadding: Int,
        tileGap: Int,
        boardCornerRadius: Int,
        boardColor: UIColor,
        closedTileColor: UIColor,
        openedTileColor: UIColor,
        bombTileColor: UIColor,
        explodingBombTileColor: UIColor,
        bombsNearbyColor: UIColor,
        markBorderColor: UIColor,
        bombSymbol: String,
        markBorderWidth: Int,
        isHapticsEnabled: Bool
    ) {
        self.gameMode = gameMode
        self.boardTilesNumber = boardTilesNumber
        self.boardPadding = boardPadding
        self.tileGap = tileGap
        self.boardCornerRadius = boardCornerRadius
        self.boardColor = boardColor
        self.closedTileColor = closedTileColor
        self.openedTileColor = openedTileColor
        self.bombTileColor = bombTileColor
        self.explodingBombTileColor = explodingBombTileColor
        self.bombsNearbyColor = bombsNearbyColor
        self.markBorderColor = markBorderColor
        self.bombSymbol = bombSymbol
        self.markBorderWidth = markBorderWidth
        self.isHapticsEnabled = isHapticsEnabled
        updateTileCornerRadius()
    }
    
    private func notifyDelegate() {
        delegate?.configDidChange()
    }
    
    private func updateTileCornerRadius() {
        tileCornerRadius = boardCornerRadius - tileGap
    }
    
    static let shared: Config = {
        Config(
            gameMode: .hard, //segmented control easy/medium/hard
            boardTilesNumber: 12, //stepper max is 14
            boardPadding: 8, //stepper max is 20
            tileGap: 2, //stepper max is 12
            boardCornerRadius: 8, //stepper max is 20
            boardColor: .secondarySystemBackground,
            closedTileColor: .systemFill,
            openedTileColor: .tertiarySystemFill,
            bombTileColor: .black,
            explodingBombTileColor: .darkGray,
            bombsNearbyColor: .secondaryLabel,
            markBorderColor: .systemPink,
            bombSymbol: "⭐️", //segmented control other 6 random emojis
            markBorderWidth: 2, //stepper max is 4
            isHapticsEnabled: true //switch
        )
    }()
}
