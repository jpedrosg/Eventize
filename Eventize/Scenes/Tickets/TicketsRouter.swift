//
//  TicketsRouter.swift
//  Eventize
//
//  Created by JP Giarrante on 09/09/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol TicketsRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeFromTickets()
}

protocol TicketsDataPassing {
    var dataStore: TicketsDataStore? { get }
}

class TicketsRouter: NSObject, TicketsRoutingLogic, TicketsDataPassing {
    weak var viewController: TicketsViewController?
    var dataStore: TicketsDataStore?

// MARK: Routing (navigating to other screens)
    
    func routeFromTickets() {
        viewController?.navigationController?.popViewController(animated: true)
    }

//func routeToSomewhere(segue: UIStoryboardSegue?) {
//    if let segue = segue {
//        let destinationVC = segue.destination as! SomewhereViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//    } else {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
//        var destinationDS = destinationVC.router!.dataStore!
//        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        navigateToSomewhere(source: viewController!, destination: destinationVC)
//    }
//}

// MARK: Navigation to other screen

//func navigateToSomewhere(source: TicketsViewController, destination: SomewhereViewController) {
//    source.show(destination, sender: nil)
//}

// MARK: Passing data to other screen

//    func passDataToSomewhere(source: TicketsDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}