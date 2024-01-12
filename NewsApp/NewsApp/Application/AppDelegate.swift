//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 100, vertical: 0), for: .default)
        
        return true
    }
}

