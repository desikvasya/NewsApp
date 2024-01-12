//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Виталий Коростелев on 12.01.2024.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        
        APICaller.shared.getTopNews { result in
            switch result {
            case .success(let response):
                print(response)
                break
            case .failure(let error):
                print(error)
            }
        }

    }


}

