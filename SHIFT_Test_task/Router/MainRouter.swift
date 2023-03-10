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
        self.navigationController = navigationController
        navigationController.overrideUserInterfaceStyle = .light
        navigationController.navigationBar.tintColor = UIColor(red: 56/255, green: 56/255, blue: 56/266, alpha: 1)
    }
    
    func pushMainVC() {
        let vc = MainViewController()
        pushViewController(vc: vc, animated: true)
    }
    
    func presentRecordEditVC(with record: Record, delegate: TransferDataToDetailVCProtocol) {
        let storyboard = UIStoryboard.init(name: "RecordEdit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecordEdit") as! RecordEditViewController
        vc.task = record
        vc.delegate = delegate
        pushViewController(vc: vc, animated: true)
    }
    
    func presentRecordEditVCForNewRecord(delegate: TransferDataToDetailVCProtocol) {
        let storyboard = UIStoryboard.init(name: "RecordEdit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RecordEdit") as! RecordEditViewController
        vc.delegate = delegate
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

