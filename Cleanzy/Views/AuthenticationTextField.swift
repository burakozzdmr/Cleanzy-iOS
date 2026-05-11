//
//  AuthenticationTextField.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

class AuthenticationTextField: UITextField {
    
    private var leftIconView: UIImageView?
    private var rightIconView: UIImageView?
    private var isPasswordVisible: Bool = false
    
    // Padding değerleri
    private let leftPadding: CGFloat = 16
    private let rightPadding: CGFloat = 16
    private let iconSpacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    convenience init(
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        leftIcon: String? = nil,
        rightIcon: String? = nil,
        hasPasswordToggle: Bool = false
    ) {
        self.init(frame: .zero)
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure
        
        setupPlaceholder(placeholder)
        
        if let leftIcon = leftIcon {
            setLeftIcon(leftIcon)
        }
        
        if hasPasswordToggle {
            setupPasswordToggle()
        } else if let rightIcon = rightIcon {
            setRightIcon(rightIcon)
        }
    }
    
    // MARK: - Padding Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        
        if leftView != nil {
            rect.origin.x += leftPadding + 24 + iconSpacing
            rect.size.width -= leftPadding + 24 + iconSpacing
        } else {
            rect.origin.x += leftPadding
            rect.size.width -= leftPadding
        }
        
        if rightView != nil {
            rect.size.width -= rightPadding + 24 + iconSpacing
        } else {
            rect.size.width -= rightPadding
        }
        
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x = leftPadding
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x = bounds.width - 24 - rightPadding
        return rect
    }
}

// MARK: - Privates

private extension AuthenticationTextField {
    func setupTextField() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        font = .systemFont(ofSize: 16)
        textColor = .black
        
        autocapitalizationType = .none
        autocorrectionType = .no
        clearButtonMode = .whileEditing
    }
    
    func setupPlaceholder(_ text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
    }
    
    func setLeftIcon(_ iconName: String, tintColor: UIColor = .lightGray) {
        guard let image = UIImage(systemName: iconName) else { return }
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        iconView.contentMode = .scaleAspectFit
        iconView.image = image.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = tintColor
        
        leftView = iconView
        leftViewMode = .always
        leftIconView = iconView
    }
    
    func setRightIcon(_ iconName: String, tintColor: UIColor = .lightGray) {
        guard let image = UIImage(systemName: iconName) else { return }
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        iconView.contentMode = .scaleAspectFit
        iconView.image = image.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = tintColor
        
        rightView = iconView
        rightViewMode = .always
        rightIconView = iconView
    }
    
    func setupPasswordToggle() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        rightView = button
        rightViewMode = .always
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        isSecureTextEntry = !isPasswordVisible
        
        guard let button = rightView as? UIButton else { return }
        
        let iconName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
        button.setImage(UIImage(systemName: iconName), for: .normal)
        
        if let existingText = text, isSecureTextEntry {
            deleteBackward()
            insertText(existingText)
        }
    }
}
