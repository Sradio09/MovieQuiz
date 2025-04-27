import Foundation

final class StatisticService: StatisticServiceProtocol{
    
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
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
                guard
                    let data = storage.dictionary(forKey: Keys.bestGame.rawValue),
                    let correct = data["correct"] as? Int,
                    let total = data["total"] as? Int,
                    let date = data["date"] as? Date
                else {
                    return GameResult(correct: 0, total: 0, date: Date())
                }

                return GameResult(correct: correct, total: total, date: date)
            }
            set {
                let bestGameData: [String: Any] = [
                    "correct": newValue.correct,
                    "total": newValue.total,
                    "date": newValue.date
                ]
                storage.set(bestGameData, forKey: Keys.bestGame.rawValue)
            }
        }
    var totalCorrect: Int {
            get {
                storage.integer(forKey: Keys.correct.rawValue)
            }
            set {
                storage.set(newValue, forKey: Keys.correct.rawValue)
            }
        }
    var totalAccuracy: Double {
            let total = gamesCount * 10
            guard total > 0 else { return 0 }
            return (Double(totalCorrect) / Double(total)) * 100
        }
    
    func store(correct count: Int, total amount: Int) {
            totalCorrect += count
            gamesCount += 1

            let newGame = GameResult(correct: count, total: amount, date: Date())
            if newGame.isBetterThan(bestGame) {
                bestGame = newGame
            }
        }
    }
