//
//  AppDelegate.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let navigationController = UINavigationController()
    var primaryViewController: UIViewController {
        MainListViewController(viewModel: ListViewModel())
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        navigationController.pushViewController(primaryViewController, animated: true)
        
        //Otra forma de mostrar el UINAvigationController y se mantenga en el safeArea.
//        let navigationControllers = UINavigationController.init(rootViewController: primaryViewController)
//        window?.rootViewController = navigationControllers
        return true
    }

}

