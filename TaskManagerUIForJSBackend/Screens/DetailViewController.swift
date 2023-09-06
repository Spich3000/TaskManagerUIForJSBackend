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
    
    private var task: TaskModel.TaskElement
    private var oldName: String = ""
    private var oldComplete: Bool = false
    
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
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .large
        loader.hidesWhenStopped = true
        loader.color = .black
        return loader
    }()
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.2
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldName = task.name
        oldComplete = task.completed
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUp()
    }
    
    private func setUp() {
        self.title = "Edit task"
        layout()
    }
    
    private func layout() {
        view.addSubview(textField)
        view.addSubview(taskId)
        view.addSubview(completedLabel)
        view.addSubview(toggle)
        view.addSubview(button)
        
        view.addSubview(background)
        view.addSubview(loader)
        
        layoutSnapKit()
    }
    
    private func configure() {
        view.backgroundColor = .secondarySystemBackground
        
        textField.text = task.name
        taskId.text = "Task id: \(task.id)"
        toggle.isOn = task.completed
        toggle.addTarget(self, action: #selector(editTaskState), for: .valueChanged )
        
        completedLabel.text = "Completed:"
        
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(sendUpdateRequest), for: .touchUpInside)
        changeButtonState(false)
        
        textField.addTarget(self, action: #selector(editTaskName), for: .editingChanged)
    }
    
    @objc private func editTaskName() {
        task.name = textField.text ?? String()
        if oldName == task.name, oldComplete == task.completed {
            changeButtonState(false)
        } else {
            changeButtonState(true)
        }
    }
    
    @objc private func editTaskState() {
        task.completed = toggle.isOn
        if oldName == task.name, oldComplete == task.completed {
            changeButtonState(false)
        } else {
            changeButtonState(true)
        }
    }
    
    @objc private func sendUpdateRequest() {
        updateTask()
    }
    
    func updateTask() {
        let request = NetworkRouter.updateTask(task: task)
        
        self.enableLoader(on: true)
        
        NetworkManager.request(request) { [weak self] (result: Result<TaskModel.Task, NetworkManager.Error>) in
            switch result {
            case .success:
                print("success updating")
            case .failure(let failure):
                print(failure.errorDescription as Any)
            }

            if let rootVC = self?.navigationController?.viewControllers.first as? HomeViewController {
                rootVC.viewModel.getTasks() {
                    self?.enableLoader(on: false)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    private func enableLoader(on: Bool) {
        if on {
            loader.startAnimating()
            background.isHidden = false
        } else {
            loader.stopAnimating()
            background.isHidden = true
        }
    }
    
    private func changeButtonState(_ value: Bool) {
        if value {
            button.isUserInteractionEnabled = true
            button.layer.opacity = 1
            button.backgroundColor = .systemBlue
        } else {
            button.isUserInteractionEnabled = false
            button.layer.opacity = 0.4
            button.backgroundColor = .gray
        }
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
        loader.center = view.center
        background.frame = view.bounds
        
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
