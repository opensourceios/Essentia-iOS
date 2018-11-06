//
//  BaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UINavigationControllerDelegate {
    var keyboardHeight: CGFloat = 0
    var isKeyboardShown: Bool = false
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let newKeyboardHeight = keyboardSize.cgRectValue.height
        let shouldNotify = keyboardHeight != newKeyboardHeight || isKeyboardShown == false
        keyboardHeight = newKeyboardHeight
        isKeyboardShown = true
        if shouldNotify {
            keyboardDidChange()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isKeyboardShown = false
        keyboardDidChange()
    }
    
    func keyboardDidChange() {}
    
    func showFlipAnimation() {
        guard let mainwindow = UIApplication.shared.delegate?.window as? UIWindow else { return }
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (_) -> Void in}
    }
}
