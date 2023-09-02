//
//  DetailViewController.swift
//  TaskManagerUIForJSBackend
//
//  Created by Дмитрий Спичаков on 03.09.2023.
//

import UIKit
import SwiftUI
import SnapKit

class DetailViewController: UIViewController {
    
    let task: TaskModel.TaskElement
    
    init(task: TaskModel.TaskElement) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textField: UITextField = makeTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUp()
    }
    
    private func setUp() {
        view.backgroundColor = .white
        self.title = "Edit task"
        layout()
    }
    
    private func layout() {
        view.addSubview(textField)
        layoutSnapKit()
    }
    
}

// MARK: CREATE UI ELEMENTS
private extension DetailViewController {
    func makeTextField() -> UITextField {
        let textField = UITextField()

        textField.backgroundColor = .white
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
      }
    
    private func layoutSnapKit() {
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.bounds.width * 0.8)
            make.height.equalTo(48)
        }
    }
}

/// Preview
struct DetailViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            DetailViewController(task: TaskModel.TaskElement(
                completed: true,
                id: "Task",
                name: "Task",
                v: nil))
            .preview()
        }
    }
}
