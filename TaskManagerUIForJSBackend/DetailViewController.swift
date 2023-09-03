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
    
    private lazy var taskId: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completedLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var toggle: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
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
        view.addSubview(taskId)
        view.addSubview(completedLabel)
        view.addSubview(toggle)
        view.addSubview(button)
        layoutSnapKit()
    }
    
    private func configure() {
        textField.text = task.name
        taskId.text = "Task id: \(task.id ?? String())"
        toggle.isOn = task.completed ?? false
        completedLabel.text = "Completed:"
        button.setTitle("Edit", for: .normal)
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
        textField.placeholder = "Task..."
        
        return textField
      }
    
    private func layoutSnapKit() {
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.bounds.width * 0.8)
            make.height.equalTo(48)
        }
        
        taskId.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(textField.snp_topMargin).inset(-50)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp_leadingMargin)
            make.centerY.equalTo(toggle.snp_centerYWithinMargins)
        }
        
        toggle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(textField.snp_bottomMargin).inset(-50)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(toggle.snp_bottomMargin).inset(-70)
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
                id: "Created task",
                name: "Created task",
                v: nil))
            .preview()
        }
    }
}
