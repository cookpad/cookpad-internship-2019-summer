//
// Copyright © Cookpad Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([
            UINavigationController(rootViewController: RecipesViewController()),
            UINavigationController(rootViewController: LikedRecipesViewController())
        ], animated: false)

        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()

        UIBarButtonItem.appearance().tintColor = .green
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UITabBar.appearance().tintColor = .green
        UITabBar.appearance().unselectedItemTintColor = .gray

        return true
    }
}
