//
//  ViewController.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 30.08.2023.
//

import UIKit
import SwiftUI

// View + states

class ViewController: UIViewController {

    // Kinda onAppear??
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        
        let request = NetworkRouter.getTasks
        NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
            switch result {
            case .success(let success):
                print(success.tasks)
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }

}

/// Preview
struct ViewControllerProvider: PreviewProvider {
  static var previews: some View {
    Group {
      ViewController().preview()
    }
  }
}


