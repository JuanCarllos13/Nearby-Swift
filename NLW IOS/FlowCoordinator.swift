//
//  FlowCoordinator.swift
//  NLW IOS
//
//  Created by Juan Carlos on 09/12/24.
//

import Foundation


import UIKit

class FlowCoordinator {
    private var navigationController: UINavigationController?
    
    public init(){
        
    }
    
    func start() -> UINavigationController? {
        let startViewController = UIViewController()
        startViewController.view.backgroundColor = .red
        
        self.navigationController = UINavigationController(rootViewController: startViewController)
        
        return navigationController
    }
    
}
