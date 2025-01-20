import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    var finalCorrectAnswers: Int { get }
    
    func store(correct count: Int, total amount: Int)
}


