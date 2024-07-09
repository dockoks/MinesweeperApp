import UIKit

enum GameMode {
    case easy
    case medium
    case hard
}

final class Config {
    
    // Game options
    var gameMode: GameMode
    var boardTilesNumber: Int
    
    // Insets
    var boardPadding: Int
    var tileGap: Int
    
    var boardCornerRadius: Int
    var tileCornerRadius: Int {
        boardCornerRadius - tileGap
    }
    
    // Colors
    var boardColor: UIColor
    var closedTileColor: UIColor
    var openedTileColor: UIColor
    var bombTileColor: UIColor
    var explodingBombTileColor: UIColor
    var bombsNearbyColor: UIColor
    var markBorderColor: UIColor
    var bombSymbol: String
    var markBorderWidth: Int
    
    // Application Specifics
    var isHapticsEnabled: Bool
    
    // Initialisation
    private init(
        gameMode: GameMode,
        boardTilesNumber: Int,
        boardPadding: Int, tileGap: Int, boardCornerRadius: Int, boardColor: UIColor, closedTileColor: UIColor, openedTileColor: UIColor, bombTileColor: UIColor, explodingBombTileColor: UIColor, bombsNearbyColor: UIColor, markBorderColor: UIColor, bombSymbol: String, markBorderWidth: Int, isHapticsEnabled: Bool) {
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
