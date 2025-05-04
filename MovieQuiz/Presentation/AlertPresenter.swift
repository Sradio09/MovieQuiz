import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?
    private var currentAlert: UIAlertController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func show(alert model: AlertModel) {
        if let alert = currentAlert {
            alert.dismiss(animated: false, completion: nil)
            currentAlert = nil
        }

        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        if let id = model.accessibilityIdentifier {
                    alert.view.accessibilityIdentifier = id
                }

        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            self?.currentAlert = nil
            model.completion()
        }

        alert.addAction(action)
        currentAlert = alert
        viewController?.present(alert, animated: true)
    }
}

