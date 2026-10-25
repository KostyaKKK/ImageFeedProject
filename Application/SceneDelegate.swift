//
//  SceneDelegate.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 05.09.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

       func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let windowScene = (scene as? UIWindowScene) else { return }
           
           window = UIWindow(windowScene: windowScene)

           window?.rootViewController = SplashViewController()
           window?.makeKeyAndVisible()
       }

       func sceneDidDisconnect(_ scene: UIScene) {
           // Called as the scene is being released by the system.
       }

       func sceneDidBecomeActive(_ scene: UIScene) {
           // Called when the scene has moved from an inactive state to an active state.
       }

       func sceneWillResignActive(_ scene: UIScene) {
           // Called when the scene will move from an active state to an inactive state.
       }

       func sceneWillEnterForeground(_ scene: UIScene) {
           // Called as the scene transitions from the background to the foreground.
       }

       func sceneDidEnterBackground(_ scene: UIScene) {
           // Called as the scene transitions to the background.
       }
   }
    //var window: UIWindow?


    //func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      //  guard let scene = (scene as? UIWindowScene) else { return }
       // window = UIWindow(windowScene: scene)
       // window?.rootViewController = UIStoryboard(
         //   name: "Main",
         //   bundle: .main
      //  ).instantiateInitialViewController()
      //  window?.makeKeyAndVisible()

