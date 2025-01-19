import Foundation

struct AlertModel {
    var alertTitle: String
    let alertMessage: String
    let buttonText: String
    let completion: () -> ()
    
    init(alertTitle: String, alertMessage: String, buttonText: String, completion: @escaping () -> Void) {
        self.alertMessage = alertMessage
        self.alertTitle = alertTitle
        self.buttonText = buttonText
        self.completion = completion
    }
}
