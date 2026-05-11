//
//  PaymentMethodsViewController.swift
//  Cleanzy
//

import SnapKit
import UIKit

// MARK: - PaymentMethodsViewController

final class PaymentMethodsViewController: UIViewController {

    // MARK: - Properties

    var presenter: PaymentMethodsPresenterProtocol!
    private var cards: [PaymentCardItem] = []

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        tv.separatorInset  = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        tv.rowHeight        = 76
        tv.register(PaymentCardCell.self, forCellReuseIdentifier: PaymentCardCell.reuseID)
        tv.dataSource = self
        tv.delegate   = self
        return tv
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private Setup

private extension PaymentMethodsViewController {
    func setupUI() {
        title = "Ödeme Yöntemlerim"
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .accent

        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    @objc func addTapped() {
        presenter?.didTapAddCard()
    }
}

// MARK: - UITableViewDataSource

extension PaymentMethodsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCardCell.reuseID, for: indexPath) as! PaymentCardCell
        cell.configure(with: cards[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        cards.isEmpty ? nil : "KAYITLI KARTLAR"
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completion in
            self?.presenter?.didTapDelete(at: indexPath.row)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableViewDelegate

extension PaymentMethodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PaymentMethodsViewProtocol

extension PaymentMethodsViewController: PaymentMethodsViewProtocol {
    func displayCards(_ cards: [PaymentCardItem]) {
        self.cards = cards
        tableView.reloadData()
    }

    func showLoading() { }
    func hideLoading() { }
    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(with: alertModel, from: self)
    }
}

// MARK: - PaymentCardCell

private final class PaymentCardCell: UITableViewCell {
    static let reuseID = "PaymentCardCell"

    private let brandIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let numberLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .label
        return l
    }()

    private let holderLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        return l
    }()

    private let expiryLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        return l
    }()

    private let defaultBadge: UILabel = {
        let l = UILabel()
        l.text = " Varsayılan "
        l.font = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = .white
        l.backgroundColor = .accent
        l.layer.cornerRadius = 6
        l.clipsToBounds = true
        l.isHidden = true
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(with card: PaymentCardItem) {
        brandIcon.image   = card.brand.icon
        brandIcon.tintColor = card.brand.tintColor
        numberLabel.text  = card.maskedNumber
        holderLabel.text  = card.holderName
        expiryLabel.text  = "Son: \(card.expiryDate)"
        defaultBadge.isHidden = !card.isDefault
    }

    private func setupUI() {
        accessoryType = .disclosureIndicator
        contentView.addSubviews([brandIcon, numberLabel, holderLabel, expiryLabel, defaultBadge])

        brandIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(brandIcon.snp.trailing).offset(14)
        }
        holderLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(4)
            $0.leading.equalTo(numberLabel)
        }
        expiryLabel.snp.makeConstraints {
            $0.centerY.equalTo(holderLabel)
            $0.leading.equalTo(holderLabel.snp.trailing).offset(12)
        }
        defaultBadge.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel)
            $0.trailing.equalToSuperview().inset(40)
        }
    }
}
