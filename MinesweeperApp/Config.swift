import UIKit

enum GameMode: Int {
    case easy
    case medium
    case hard
    
    init(string: String) {
        switch string {
        case "Easy": self = .easy
        case "Medium": self = .medium
        case "Hard": self = .hard
        default: self = .easy
        }
    }
}

protocol ConfigDelegate: AnyObject {
    func configDidChange()
}

final class Config {
    static let gameModeOptions: [String] = ["Easy", "Medium", "Hard"]
    static let bombSymbolOptions: [String] = ["💣", "⭐️", "💥", "🔥", "👾", "🎃"]
    static let markColorOptions: [String] = ["Teal", "Purple", "Yellow", "Pink", "Green"]
    
    weak var delegate: ConfigDelegate?
    
    private enum Keys {
        static let gameMode = "gameMode"
        static let boardTilesNumber = "boardTilesNumber"
        static let boardPadding = "boardPadding"
        static let tileGap = "tileGap"
        static let boardCornerRadius = "boardCornerRadius"
        static let boardColor = "boardColor"
        static let closedTileColor = "closedTileColor"
        static let openedTileColor = "openedTileColor"
        static let bombTileColor = "bombTileColor"
        static let explodingBombTileColor = "explodingBombTileColor"
        static let bombsNearbyColor = "bombsNearbyColor"
        static let markBorderColor = "markBorderColor"
        static let bombSymbol = "bombSymbol"
        static let markBorderWidth = "markBorderWidth"
        static let isHapticsEnabled = "isHapticsEnabled"
    }
    
    // Game options
    var gameMode: GameMode {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var boardTilesNumber: Int {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    
    // Insets
    var boardPadding: Int {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var tileGap: Int {
        didSet {
            updateTileCornerRadius()
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    
    var boardCornerRadius: Int {
        didSet {
            updateTileCornerRadius()
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var tileCornerRadius: Int = 0 {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    
    // Colors
    var boardColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var closedTileColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var openedTileColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var bombTileColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var explodingBombTileColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var bombsNearbyColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var markBorderColor: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var bombSymbol: String {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    var markBorderWidth: Int {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    
    // Application Specifics
    var isHapticsEnabled: Bool {
        didSet {
            saveToUserDefaults()
            notifyDelegate()
        }
    }
    
    // Initialisation
    private init(
        gameMode: GameMode,
        boardTilesNumber: Int,
        boardPadding: Int,
        tileGap: Int,
        boardCornerRadius: Int,
        boardColor: String,
        closedTileColor: String,
        openedTileColor: String,
        bombTileColor: String,
        explodingBombTileColor: String,
        bombsNearbyColor: String,
        markBorderColor: String,
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
        return Config.loadFromUserDefaults()
    }()
    
    private func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(gameMode.rawValue, forKey: Keys.gameMode)
        defaults.set(boardTilesNumber, forKey: Keys.boardTilesNumber)
        defaults.set(boardPadding, forKey: Keys.boardPadding)
        defaults.set(tileGap, forKey: Keys.tileGap)
        defaults.set(boardCornerRadius, forKey: Keys.boardCornerRadius)
        defaults.set(boardColor, forKey: Keys.boardColor)
        defaults.set(closedTileColor, forKey: Keys.closedTileColor)
        defaults.set(openedTileColor, forKey: Keys.openedTileColor)
        defaults.set(bombTileColor, forKey: Keys.bombTileColor)
        defaults.set(explodingBombTileColor, forKey: Keys.explodingBombTileColor)
        defaults.set(bombsNearbyColor, forKey: Keys.bombsNearbyColor)
        defaults.set(markBorderColor, forKey: Keys.markBorderColor)
        defaults.set(bombSymbol, forKey: Keys.bombSymbol)
        defaults.set(markBorderWidth, forKey: Keys.markBorderWidth)
        defaults.set(isHapticsEnabled, forKey: Keys.isHapticsEnabled)
    }
    
    private static func loadFromUserDefaults() -> Config {
        let defaults = UserDefaults.standard
        let gameMode = GameMode(rawValue: defaults.integer(forKey: Keys.gameMode)) ?? GameMode(string: Config.gameModeOptions.first ?? "")
        let boardTilesNumber = defaults.integer(forKey: Keys.boardTilesNumber)
        let boardPadding = defaults.integer(forKey: Keys.boardPadding)
        let tileGap = defaults.integer(forKey: Keys.tileGap)
        let boardCornerRadius = defaults.integer(forKey: Keys.boardCornerRadius)
        let boardColor = defaults.string(forKey: Keys.boardColor) ?? "BoardColor"
        let closedTileColor = defaults.string(forKey: Keys.closedTileColor) ?? "ClosedTileColor"
        let openedTileColor = defaults.string(forKey: Keys.openedTileColor) ?? "OpenedTileColor"
        let bombTileColor = defaults.string(forKey: Keys.bombTileColor) ?? "BombTileColor"
        let explodingBombTileColor = defaults.string(forKey: Keys.explodingBombTileColor) ?? "ExplodingBombTileColor"
        let bombsNearbyColor = defaults.string(forKey: Keys.bombsNearbyColor) ?? "BombsNearbyColor"
        let markBorderColor = defaults.string(forKey: Keys.markBorderColor) ?? Config.markColorOptions.first ?? ""
        let bombSymbol = defaults.string(forKey: Keys.bombSymbol) ?? Config.bombSymbolOptions.first ?? ""
        let markBorderWidth = defaults.integer(forKey: Keys.markBorderWidth)
        let isHapticsEnabled = defaults.bool(forKey: Keys.isHapticsEnabled)
        
        return Config(
            gameMode: gameMode,
            boardTilesNumber: boardTilesNumber == 0 ? 12 : boardTilesNumber, // Default value if 0
            boardPadding: boardPadding == 0 ? 8 : boardPadding, // Default value if 0
            tileGap: tileGap == 0 ? 2 : tileGap, // Default value if 0
            boardCornerRadius: boardCornerRadius == 0 ? 8 : boardCornerRadius, // Default value if 0
            boardColor: boardColor,
            closedTileColor: closedTileColor,
            openedTileColor: openedTileColor,
            bombTileColor: bombTileColor,
            explodingBombTileColor: explodingBombTileColor,
            bombsNearbyColor: bombsNearbyColor,
            markBorderColor: markBorderColor,
            bombSymbol: bombSymbol,
            markBorderWidth: markBorderWidth == 0 ? 2 : markBorderWidth, // Default value if 0
            isHapticsEnabled: isHapticsEnabled
        )
    }
}
