//
//  CreateEventViewController.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 18/12/24.
//

import UIKit

final class CreateEventViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let headerLabel = UILabel()
    private let maxNumberOfSymbolsErrorLabel = UILabel()
    private let trackerNameTextField = UITextField()
    private let textFieldStackView = UIStackView()
    private let spacingView = UIView()
    private let buttonsContainerView = UIView()
    private let categoryButtonImageView = UIImageView()
    private let categoryButton = UIButton(type: .system)
    // TODO: добавить (скорее всего UICollectionView с двумя секциями) - emoji, color
    private let bottomButtonsStackView = UIStackView()
    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    @objc private func categoryButtonTapped() {
        print("category button tapped")
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.ypWhite
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Новое нерегулярное событие"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerLabel.textColor = UIColor.ypBlack
        view.addSubview(headerLabel)
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 8
        textFieldStackView.alignment = .center
        view.addSubview(textFieldStackView)
        
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameTextField.delegate = self
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.layer.masksToBounds = true
        trackerNameTextField.backgroundColor = UIColor.ypBackground
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.clearButtonMode = .whileEditing
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameTextField.frame.height))
        trackerNameTextField.leftView = leftPaddingView
        trackerNameTextField.leftViewMode = .always
        textFieldStackView.addArrangedSubview(trackerNameTextField)
        
        maxNumberOfSymbolsErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        maxNumberOfSymbolsErrorLabel.text = "Ограничение 38 символов"
        maxNumberOfSymbolsErrorLabel.textColor = UIColor.ypRed
        maxNumberOfSymbolsErrorLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        maxNumberOfSymbolsErrorLabel.isHidden = true
        textFieldStackView.addArrangedSubview(maxNumberOfSymbolsErrorLabel)
        
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        spacingView.isHidden = true
        textFieldStackView.addArrangedSubview(spacingView)
        
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerView.layer.cornerRadius = 16
        buttonsContainerView.layer.masksToBounds = true
        buttonsContainerView.backgroundColor = UIColor.ypBackground
        view.addSubview(buttonsContainerView)
        
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        categoryButton.backgroundColor = UIColor.ypBackground
        categoryButton.setTitle("Категория", for: .normal)
        categoryButton.tintColor = UIColor.ypBlack
        categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        categoryButton.contentHorizontalAlignment = .left
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        buttonsContainerView.addSubview(categoryButton)
        
        categoryButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryButtonImageView.image = UIImage.chevronIcon
        categoryButton.addSubview(categoryButtonImageView)
        
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.spacing = 8
        view.addSubview(bottomButtonsStackView)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.tintColor = UIColor.ypRed
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        bottomButtonsStackView.addArrangedSubview(cancelButton)
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.backgroundColor = UIColor.ypGray
        createButton.setTitle("Создать", for: .normal)
        createButton.tintColor = UIColor.ypWhite
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bottomButtonsStackView.addArrangedSubview(createButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameTextField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            trackerNameTextField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            
            spacingView.heightAnchor.constraint(equalToConstant: 0),
            
            buttonsContainerView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            buttonsContainerView.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 16),
            buttonsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            buttonsContainerView.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            
            categoryButtonImageView.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryButtonImageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            categoryButtonImageView.widthAnchor.constraint(equalToConstant: 24),
            categoryButtonImageView.heightAnchor.constraint(equalToConstant: 24),
            
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension CreateEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        
        let currentText = trackerNameTextField.text ?? ""
        let requestedLength = currentText.count + string.count - range.length
        
        if requestedLength >= maxLength {
            maxNumberOfSymbolsErrorLabel.isHidden = false
            spacingView.isHidden = false
        } else {
            maxNumberOfSymbolsErrorLabel.isHidden = true
            spacingView.isHidden = true
        }
        
        return requestedLength <= maxLength
    }
}
