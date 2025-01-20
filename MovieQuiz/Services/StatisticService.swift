import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case date
        case finalCorrectAnswers
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
                storage.set(newValue, forKey: Keys.correct.rawValue)
                storage.set(newValue, forKey: Keys.total.rawValue)
                storage.set(newValue, forKey: Keys.date.rawValue)
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
    
    var totalAccuracy: Double {
        if gamesCount != 0 {
            Double(finalCorrectAnswers) / 10 / Double(gamesCount) * 100
        } else {
            0
        }
    }
    
   
    func store(correct count: Int, total amount: Int) {
        finalCorrectAnswers += count
        gamesCount += 1
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        currentGame.isBetterThan(bestGame) ? bestGame = currentGame : ()
    }
}

