//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Анна Перескокова on 05.02.2025.
//
import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticServiceProtocol?
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
           guard let currentQuestion = currentQuestion else {
               return
           }
           
           let givenAnswer = isYes
           
           viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
       }
    
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            guard let statisticService else { return }
            guard let viewController else { return }
            var totalAccuracy: Double {
                if statisticService.gamesCount != 0 {
                    Double(statisticService.finalCorrectAnswers * 100 / (10 * statisticService.gamesCount))
                } else {
                    Double(correctAnswers * 100 / 10)
                }
            }
            let currentGame = GameResult(correct: correctAnswers, total: self.questionsAmount, date: Date())
            statisticService.store(result: currentGame)
            let alertModel = AlertModel(alertTitle: "Этот раунд окончен!",
                                        alertMessage: "Ваш результат: \(correctAnswers) из \(self.questionsAmount) \nКоличество сыгранных квизов: \(statisticService.gamesCount) \nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString) \nСредняя точность: \(String(format: "%.2f", totalAccuracy))%",
                                        buttonText: "Сыграть ещё раз",
                                        completion: viewController.goToStart)
            let alertPresenter = AlertPresenter()
            alertPresenter.showAlert(model: alertModel)
            guard let alert = alertPresenter.alert else { return }
            alert.present(alert, animated: true, completion: nil)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            viewController?.showLoadingIndicator()
        }
    }
    
}
