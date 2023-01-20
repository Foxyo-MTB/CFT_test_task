//
//  Router.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit

protocol Routable: UIViewController {
    
    var router: MainRouter? { get set }
    
}

class MainRouter: NSObject {
 
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        navigationController.setNavigationBarHidden(true, animated: true)
        self.navigationController = navigationController
    }
    
    func pushMainVC() {
        let vc = MainViewController()
        pushViewController(vc: vc, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    //MARK: - Extension for push VC
    
    private func pushViewController(vc: Routable, animated: Bool) {
        vc.router = self
        navigationController.pushViewController(vc, animated: animated)
    }
    
    private func presentViewController(vc: Routable, animated: Bool) {
        vc.router = self
        vc.modalPresentationStyle = .popover
        navigationController.present(vc, animated: animated, completion: nil)
    }
    
}
