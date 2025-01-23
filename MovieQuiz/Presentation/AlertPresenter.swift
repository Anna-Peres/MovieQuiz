import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert()
}

final class AlertPresenter {
    var alert: UIAlertController?
    
    func showAlert(model: AlertModel) {
        alert = UIAlertController(title: model.alertTitle, message: model.alertMessage, preferredStyle: .alert)
        guard let alert = self.alert else { return }
        alert.addAction(UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()})
    }
}
