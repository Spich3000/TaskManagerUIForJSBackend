//
//  UIViewControllerPreview.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 31.08.2023.
//

import SwiftUI

// Extension -> UiViewController+Preview
extension UIViewController {

  struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {
      viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  }

  func preview() -> some View {
    Preview(viewController: self).edgesIgnoringSafeArea(.all)
  }
}
