//
//  PaymentHandler.swift
//  BookingHotel
//
//  Created by Yury on 28/09/2023.
//

import UIKit

class PaymentHandler {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    var textFields: [UITextField]
    var views: [UIView]
    var viewConstraints: [NSLayoutConstraint]
    var stacksInViews: [UIStackView]
    var buttonsUpDownPlus: [UIButton]
    var scrollView: UIScrollView
    var mainStackView: UIStackView
    
    // MARK: - Init
    
    init(viewController: UIViewController,
         textFields: [UITextField],
         views: [UIView],
         viewConstraints: [NSLayoutConstraint],
         stacksInViews: [UIStackView],
         buttonsUpDownPlus: [UIButton],
         scrollView: UIScrollView,
         mainStackView: UIStackView) {
        
        self.viewController = viewController
        self.textFields = textFields
        self.views = views
        self.viewConstraints = viewConstraints
        self.stacksInViews = stacksInViews
        self.buttonsUpDownPlus = buttonsUpDownPlus
        self.scrollView = scrollView
        self.mainStackView = mainStackView
    }
}
 
// MARK: Methods

extension PaymentHandler {
    
    func makeUIContext() -> UIContext {
        return UIContext(
            textFields: textFields,
            views: views,
            viewConstraints: viewConstraints,
            stacksInViews: stacksInViews,
            buttonsUpDownPlus: buttonsUpDownPlus,
            scrollView: scrollView,
            mainStackView: mainStackView
        )
    }
    
    func makeActionContext(for sender: UIButton) -> ActionContext {
        return ActionContext(
            sender: sender,
            controller: viewController!,
            performSegue: { [weak self] in
                self?.viewController?.performSegue(withIdentifier: "ToFinalScreen", sender: nil)
            }
        )
    }
    
    func handlePaymentAction(for sender: UIButton) {
        let uiContext = makeUIContext()
        let actionContext = makeActionContext(for: sender)
        ActionManager.shared.payButtonAction(uiContext: uiContext, actionContext: actionContext)
    }
    
}
