//
//  ChatDetailViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import SnapKit
import UIKit

final class ChatDetailViewController: UIViewController {

    // MARK: - Properties

    var presenter: ChatDetailPresenterProtocol!
    private var messages: [ChatMessageItem] = []

    // MARK: - Custom Navigation Bar

    private let navBarView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.05
        v.layer.shadowOffset = CGSize(width: 0, height: 1)
        v.layer.shadowRadius = 4
        return v
    }()

    private lazy var backButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        b.tintColor = UIColor(red: 0.20, green: 0.22, blue: 0.30, alpha: 1.0)
        b.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return b
    }()

    private let navAvatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .accent
        return iv
    }()

    private let onlineBadge: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
        v.layer.cornerRadius = 5
        v.layer.borderWidth = 1.5
        v.layer.borderColor = UIColor.white.cgColor
        v.isHidden = true
        return v
    }()

    private let navNameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = UIColor(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)
        return l
    }()

    private let navStatusLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = UIColor.systemGray
        return l
    }()

    private lazy var appointmentButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "calendar.badge.plus")
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .accent
        config.cornerStyle = .fixed
        let b = UIButton(configuration: config)
        b.layer.cornerRadius = 10
        b.layer.masksToBounds = true
        return b
    }()

    // MARK: - Messages TableView

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1.0)
        tv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tv.keyboardDismissMode = .interactive
        tv.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseIdentifier)
        return tv
    }()

    // MARK: - Input Bar

    private let inputBarView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowOffset = CGSize(width: 0, height: -2)
        v.layer.shadowRadius = 6
        return v
    }()

    private lazy var attachButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "plus"), for: .normal)
        b.tintColor = UIColor(red: 0.40, green: 0.44, blue: 0.52, alpha: 1.0)
        b.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.0)
        b.layer.cornerRadius = 20
        return b
    }()

    private let messageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Mesaj yazın..."
        tf.font = .systemFont(ofSize: 15)
        tf.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.0)
        tf.layer.cornerRadius = 20
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        tf.rightViewMode = .always
        return tf
    }()

    private lazy var sendButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        b.tintColor = .white
        b.backgroundColor = .accent
        b.layer.cornerRadius = 20
        b.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        setupKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Objective-C

@objc private extension ChatDetailViewController {
    func backTapped() {
        presenter?.didTapBack()
    }

    func sendTapped() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        presenter?.didTapSend(text: text)
        messageTextField.text = nil
    }

    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: duration) {
            self.inputBarView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(frame.height - self.view.safeAreaInsets.bottom)
            }
            self.view.layoutIfNeeded()
        }
        scrollToBottom()
    }

    func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        UIView.animate(withDuration: duration) {
            self.inputBarView.snp.updateConstraints { $0.bottom.equalTo(self.view.safeAreaLayoutGuide) }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Private Setup

private extension ChatDetailViewController {

    func setupUI() {
        view.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1.0)

        let nameTitleStack = UIStackView(arrangedSubviews: [navNameLabel, navStatusLabel])
        nameTitleStack.axis = .vertical
        nameTitleStack.spacing = 2

        navAvatarView.addSubview(onlineBadge)
        navBarView.addSubviews([backButton, navAvatarView, nameTitleStack, appointmentButton])
        view.addSubviews([navBarView, tableView, inputBarView])
        inputBarView.addSubviews([attachButton, messageTextField, sendButton])

        navBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(36)
        }

        navAvatarView.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
        }

        onlineBadge.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(-1)
            $0.width.height.equalTo(10)
        }

        nameTitleStack.snp.makeConstraints {
            $0.leading.equalTo(navAvatarView.snp.trailing).offset(10)
            $0.centerY.equalTo(navAvatarView)
            $0.trailing.lessThanOrEqualTo(appointmentButton.snp.leading).offset(-8)
        }

        appointmentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(navAvatarView)
            $0.width.height.equalTo(38)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputBarView.snp.top)
        }

        inputBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(66)
        }

        attachButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        messageTextField.snp.makeConstraints {
            $0.leading.equalTo(attachButton.snp.trailing).offset(8)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func scrollToBottom(animated: Bool = true) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
}

// MARK: - ChatDetailViewProtocol

extension ChatDetailViewController: ChatDetailViewProtocol {
    func configureHeader(userName: String, status: String, isOnline: Bool) {
        navNameLabel.text = userName
        navStatusLabel.text = status
        onlineBadge.isHidden = !isOnline
    }

    func displayMessages(_ messages: [ChatMessageItem]) {
        self.messages = messages
        tableView.reloadData()
        DispatchQueue.main.async { self.scrollToBottom(animated: false) }
    }

    func appendMessage(_ message: ChatMessageItem) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        scrollToBottom()
    }

    func showLoading() { }
    func hideLoading() { }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(
            with: AlertModel(title: alertModel.title, message: alertModel.message),
            from: self
        )
    }
}

// MARK: - UITableViewDataSource

extension ChatDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatMessageCell.reuseIdentifier, for: indexPath
        ) as? ChatMessageCell else { return UITableViewCell() }
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        messages[indexPath.row].isDateSeparator ? 36 : 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

#Preview {
    let mockItem = ChatItem.mockList[0]
    return ChatDetailBuilder.createModule(with: mockItem)
}
