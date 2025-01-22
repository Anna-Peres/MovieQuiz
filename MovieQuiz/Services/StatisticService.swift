import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case gamesCount
        case total
        case finalCorrectAnswers
        case bestGame
        case date
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    var finalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.finalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.finalCorrectAnswers.rawValue)
        }
    }
    
    func store(result: GameResult) {
        finalCorrectAnswers += result.correct
        gamesCount += 1
        result.isBetterThan(bestGame) ? bestGame = result : ()
    }
}
