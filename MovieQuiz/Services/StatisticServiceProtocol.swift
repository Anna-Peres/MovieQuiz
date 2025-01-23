import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var finalCorrectAnswers: Int { get }
    
    func store(result: GameResult)
}


