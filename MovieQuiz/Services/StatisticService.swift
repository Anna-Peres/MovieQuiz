import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: "Keys.gamesCount.rawValue")
        }
        set {
            storage.set(newValue, forKey: "Keys.gamesCount.rawValue")
        }
    }
    
    var bestGame: GameResult {
            get {
                let correct = storage.integer(forKey: "Keys.bestGame.correct.rawValue")
                let total = storage.integer(forKey: "Keys.bestGame.total.rawValue")
                let date = storage.object(forKey: "Keys.bestGame.date.rawValue") as? Date ?? Date()
                return GameResult(correct: correct, total: total, date: date)
            }
            set {
                storage.set(newValue, forKey: "Keys.bestGame.correct.rawValue")
                storage.set(newValue, forKey: "Keys.bestGame.total.rawValue")
                storage.set(newValue, forKey: "Keys.bestGame.date.rawValue")
            }
        }
    
    var totalAccuracy: Double {
        if gamesCount != 0 {
            Double(finalCorrectAnswers) / 10 / Double(gamesCount) * 100
        } else {
            Double(finalCorrectAnswers) / 10 * 100
        }
    }
    
    private var finalCorrectAnswers: Int {
        get {
            storage.integer(forKey: "Keys.correctAnswers.rawValue")
        }
        set {
            storage.set(newValue, forKey: "Keys.correctAnswers.rawValue")
        }
    }
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        finalCorrectAnswers += count
        gamesCount += 1
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        currentGame.isBetterThan(bestGame) ? bestGame = currentGame : ()
    }
}

