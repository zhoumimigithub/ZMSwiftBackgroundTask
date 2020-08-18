//
//  SceneDelegate.swift
//  ZMSwiftBackgroundTask
//
//  Created by zhoumimi on 2020/8/18.
//

import UIKit
import SwiftUI
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var audioPlayer: AVAudioPlayer!
    var audioEngine = AVAudioEngine()
    
    let app = UIApplication.shared
    
    var bgTask: UIBackgroundTaskIdentifier!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if (self.bgTask != nil) {
            self.app.endBackgroundTask(self.bgTask)
        }
        print("sceneDidBecomeActive")
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        self.bgTask = app.beginBackgroundTask(expirationHandler: {
            self.app.endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskIdentifier.invalid
        });
        
        let t: TimeInterval!
        t = 10
        Timer.scheduledTimer(timeInterval: t, target: self, selector: #selector(applyForMoreTime), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: t, target: self, selector: #selector(doSomething), userInfo: nil, repeats: true)
        
            print("sceneDidEnterBackground")
    }

    @objc func doSomething() {
        print("doing something, \(app.backgroundTimeRemaining)")
    }
    
    @objc func applyForMoreTime() {
        
        if app.backgroundTimeRemaining < 30 {
            
            let filePathUrl = NSURL(string: "\(Bundle.main.resourcePath!)/1.wav")
            
            
            do {
                try AVAudioSession.sharedInstance()
                    .setCategory(AVAudioSession.Category.playback)
                
//                    .setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
            } catch _ {
                
            }
            
            self.audioPlayer = try? AVAudioPlayer(contentsOf: filePathUrl! as URL)
            
            self.audioEngine.reset()
            self.audioPlayer.play()
            
            self.app.endBackgroundTask(self.bgTask)
            self.bgTask = app.beginBackgroundTask(expirationHandler: {
                self.app.endBackgroundTask(self.bgTask)
                self.bgTask = UIBackgroundTaskIdentifier.invalid
            })
        }
        
    }
}

