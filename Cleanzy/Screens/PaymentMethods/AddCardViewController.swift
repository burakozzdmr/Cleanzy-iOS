//
//  AddCardViewController.swift
//  Cleanzy
//

import SnapKit
import UIKit

// MARK: - AddCardViewController

final class AddCardViewController: UIViewController {

    // MARK: - Properties

    private let completion: (PaymentCardItem) -> Void

    // MARK: - UI

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Kart Ekle"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = .label
        return l
    }()

    private lazy var cardNumberField  = makeField(placeholder: "Kart Numarası", keyboard: .numberPad)
    private lazy var holderNameField  = makeField(placeholder: "Kart Üzerindeki İsim")
    private lazy var expiryDateField  = makeField(placeholder: "Son Kullanma (AA/YY)", keyboard: .numberPad)
    private lazy var cvvField         = makeField(placeholder: "CVV", keyboard: .numberPad, isSecure: true)

    private lazy var addButton: UIButton = {
        let b = UIButton()
        b.setTitle("Kartı Ekle", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor = .accent
        b.layer.cornerRadius = 14
        b.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Init

    init(completion: @escaping (PaymentCardItem) -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private

private extension AddCardViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain, target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        title = ""

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            cardNumberField,
            holderNameField,
            expiryDateField,
            cvvField,
            addButton
        ])
        stack.axis    = .vertical
        stack.spacing = 14

        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        [cardNumberField, holderNameField, expiryDateField, cvvField].forEach {
            $0.snp.makeConstraints { make in make.height.equalTo(52) }
        }
        addButton.snp.makeConstraints { $0.height.equalTo(52) }
    }

    func makeField(placeholder: String, keyboard: UIKeyboardType = .default, isSecure: Bool = false) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 12

        let tf = UITextField()
        tf.placeholder         = placeholder
        tf.keyboardType        = keyboard
        tf.isSecureTextEntry   = isSecure
        tf.font                = .systemFont(ofSize: 15)
        tf.autocorrectionType  = .no
        tf.returnKeyType       = .done
        tf.delegate            = self

        container.addSubview(tf)
        tf.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        return container
    }

    func textField(placeholder: String) -> UITextField? {
        func find(in v: UIView) -> UITextField? {
            for sub in v.subviews {
                if let tf = sub as? UITextField, tf.placeholder == placeholder { return tf }
                if let found = find(in: sub) { return found }
            }
            return nil
        }
        return find(in: view)
    }

    @objc func addTapped() {
        let number  = textField(placeholder: "Kart Numarası")?.text ?? ""
        let holder  = textField(placeholder: "Kart Üzerindeki İsim")?.text ?? ""
        let expiry  = textField(placeholder: "Son Kullanma (AA/YY)")?.text ?? ""

        guard number.count >= 4, !holder.isEmpty, !expiry.isEmpty else {
            AlertManager.shared.showAlert(
                with: .init(title: "Uyarı", message: "Lütfen tüm alanları doldurun."),
                from: self
            )
            return
        }

        let lastFour = String(number.suffix(4))
        let card = PaymentCardItem(holderName: holder.uppercased(), lastFour: lastFour, expiryDate: expiry)
        dismiss(animated: true) { [weak self] in
            self?.completion(card)
        }
    }

    @objc func cancelTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AddCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
