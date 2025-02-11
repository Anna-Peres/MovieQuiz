import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
     
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                self.delegate?.didFailToLoadData(with: error)
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomRating = Int.random(in: 8...9)
            let randomIndex = Int.random(in: 1...2)
            func makeQuestion () -> QuizQuestion {
                if randomIndex == 1 {
                    let quizQuestion = QuizQuestion(image: imageData,
                                                text: "Рейтинг этого фильма больше, чем \(randomRating)?",
                                                correctAnswer: rating > Float(randomRating))
                    return quizQuestion
                } else {
                    let quizQuestion = QuizQuestion(image: imageData,
                                                text: "Рейтинг этого фильма меньше, чем \(randomRating)?",
                                                correctAnswer: rating < Float(randomRating))
                    return quizQuestion
                }
            }
            
            let question = makeQuestion()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
}
