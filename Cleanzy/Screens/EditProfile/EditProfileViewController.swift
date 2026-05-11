//
//  EditProfileViewController.swift
//  Cleanzy
//

import SnapKit
import UIKit

// MARK: - EditProfileViewController

final class EditProfileViewController: UIViewController {

    // MARK: - Properties

    var presenter: EditProfilePresenterProtocol!

    private let loadingView: AuthenticationLoadingView = .init()

    // MARK: - Avatar

    private let avatarContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .accent
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50
        iv.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        return iv
    }()

    private lazy var editAvatarButton: UIButton = {
        let b = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "camera.fill")
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .accent
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        b.configuration = config
        return b
    }()

    // MARK: - Form Fields

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let formStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()

    private lazy var nameField     = makeField(placeholder: "Ad Soyad", icon: "person.fill")
    private lazy var emailField    = makeField(placeholder: "E-posta", icon: "envelope.fill", keyboardType: .emailAddress)
    private lazy var locationField = makeField(placeholder: "Konum (şehir/ilçe)", icon: "location.fill")

    private lazy var saveButton: UIButton = {
        let b = UIButton()
        b.setTitle("Değişiklikleri Kaydet", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor = .accent
        b.layer.cornerRadius = 14
        b.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private Setup

private extension EditProfileViewController {
    func setupUI() {
        title = "Profili Düzenle"
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        view.addSubview(scrollView)
        scrollView.addSubview(formStack)

        // Avatar section
        avatarContainer.addSubviews([avatarImageView, editAvatarButton])
        avatarImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        editAvatarButton.snp.makeConstraints {
            $0.trailing.equalTo(avatarImageView.snp.trailing).offset(4)
            $0.bottom.equalTo(avatarImageView.snp.bottom).offset(4)
            $0.width.height.equalTo(32)
        }
        avatarContainer.snp.makeConstraints { $0.height.equalTo(120) }

        // Section labels
        let accountSection  = makeSectionHeader("KİŞİSEL BİLGİLER")
        let locationSection = makeSectionHeader("KONUM")

        let fieldsCard = makeCard([nameField, emailField])
        let locationCard = makeCard([locationField])

        [avatarContainer, accountSection, fieldsCard, locationSection, locationCard, saveButton]
            .forEach { formStack.addArrangedSubview($0) }

        formStack.setCustomSpacing(4, after: accountSection)
        formStack.setCustomSpacing(20, after: fieldsCard)
        formStack.setCustomSpacing(4, after: locationSection)
        formStack.setCustomSpacing(28, after: locationCard)

        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        formStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16))
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-32)
        }

        nameField.snp.makeConstraints { $0.height.equalTo(52) }
        emailField.snp.makeConstraints { $0.height.equalTo(52) }
        locationField.snp.makeConstraints { $0.height.equalTo(52) }
        saveButton.snp.makeConstraints { $0.height.equalTo(52) }
    }

    // MARK: - Factory

    func makeField(placeholder: String, icon: String, keyboardType: UIKeyboardType = .default) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 14

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemGray3
        iconView.contentMode = .scaleAspectFit

        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = .systemFont(ofSize: 15)
        tf.keyboardType = keyboardType
        tf.autocapitalizationType = keyboardType == .emailAddress ? .none : .words
        tf.returnKeyType = .done
        tf.delegate = self
        tf.tag = fieldTag(for: placeholder)

        container.addSubviews([iconView, tf])
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        tf.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        return container
    }

    func makeCard(_ fields: [UIView]) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.05
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 8

        let stack = UIStackView(arrangedSubviews: fields)
        stack.axis = .vertical
        stack.spacing = 0

        // Separators between fields
        for i in 0..<(fields.count - 1) {
            let sep = UIView()
            sep.backgroundColor = UIColor.systemGray5
            stack.insertArrangedSubview(sep, at: i * 2 + 1)
            sep.snp.makeConstraints { $0.height.equalTo(0.5) }
        }

        card.addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
        return card
    }

    func makeSectionHeader(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = .systemGray
        return l
    }

    func fieldTag(for placeholder: String) -> Int {
        switch placeholder {
        case "Ad Soyad": return 0
        case "E-posta": return 1
        default: return 2
        }
    }

    func textField(withTag tag: Int) -> UITextField? {
        func findTextField(in view: UIView, tag: Int) -> UITextField? {
            for sub in view.subviews {
                if let tf = sub as? UITextField, tf.tag == tag { return tf }
                if let found = findTextField(in: sub, tag: tag) { return found }
            }
            return nil
        }
        return findTextField(in: self.view, tag: tag)
    }
}

// MARK: - Objective-C

@objc private extension EditProfileViewController {
    func saveTapped() {
        view.endEditing(true)
        let name     = textField(withTag: 0)?.text ?? ""
        let email    = textField(withTag: 1)?.text ?? ""
        let location = textField(withTag: 2)?.text ?? ""
        presenter?.didTapSave(name: name, email: email, location: location)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let next = self.textField(withTag: textField.tag + 1)
        if let next {
            next.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - EditProfileViewProtocol

extension EditProfileViewController: EditProfileViewProtocol {
    func populateFields(name: String, email: String, location: String) {
        textField(withTag: 0)?.text = name
        textField(withTag: 1)?.text = email
        textField(withTag: 2)?.text = location
    }

    func showLoading() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func hideLoading() {
        loadingView.removeFromSuperview()
    }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(with: alertModel, from: self)
    }
}
