//
//  AppointmentsViewController.swift
//  Cleanzy
//

import SnapKit
import UIKit

// MARK: - AppointmentsViewController

final class AppointmentsViewController: UIViewController {

    // MARK: - Properties

    var presenter: AppointmentsPresenterProtocol!

    private var items: [AppointmentItem] = []

    private let loadingView: AuthenticationLoadingView = .init()

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = UIColor.systemGroupedBackground
        tv.separatorStyle  = .none
        tv.rowHeight        = UITableView.automaticDimension
        tv.estimatedRowHeight = 160
        tv.contentInset     = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tv.register(AppointmentCell.self, forCellReuseIdentifier: AppointmentCell.reuseID)
        tv.dataSource = self
        tv.delegate   = self
        return tv
    }()

    private let emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true

        let icon = UIImageView(image: UIImage(systemName: "calendar.badge.exclamationmark"))
        icon.tintColor    = .systemGray3
        icon.contentMode  = .scaleAspectFit

        let label = UILabel()
        label.text          = "Henüz randevunuz bulunmuyor."
        label.textAlignment = .center
        label.font          = .systemFont(ofSize: 16, weight: .medium)
        label.textColor     = .systemGray

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis    = .vertical
        stack.spacing = 12
        stack.alignment = .center

        v.addSubview(stack)
        icon.snp.makeConstraints { $0.size.equalTo(CGSize(width: 64, height: 64)) }
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        return v
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - UI Setup

private extension AppointmentsViewController {
    func setupUI() {
        title = "Randevularım"
        view.backgroundColor = UIColor.systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        tableView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        emptyStateView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}

// MARK: - UITableViewDataSource

extension AppointmentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentCell.reuseID, for: indexPath) as! AppointmentCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AppointmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AppointmentsViewProtocol

extension AppointmentsViewController: AppointmentsViewProtocol {
    func displayAppointments(_ items: [AppointmentItem]) {
        self.items = items
        tableView.reloadData()
    }

    func showEmptyState() {
        emptyStateView.isHidden = false
        tableView.isHidden      = true
    }

    func hideEmptyState() {
        emptyStateView.isHidden = true
        tableView.isHidden      = false
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

// MARK: - AppointmentCell

private final class AppointmentCell: UITableViewCell {
    static let reuseID = "AppointmentCell"

    // MARK: - Subviews

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor  = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor  = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowOffset  = CGSize(width: 0, height: 2)
        v.layer.shadowRadius  = 8
        return v
    }()

    private let statusBadge: UILabel = {
        let l = UILabel()
        l.font            = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor       = .white
        l.layer.cornerRadius = 8
        l.clipsToBounds   = true
        l.textAlignment   = .center
        return l
    }()

    private let cleanerIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        iv.tintColor      = .accent
        iv.contentMode    = .scaleAspectFit
        return iv
    }()

    private let cleanerLabel = AppointmentCell.makeLabel(size: 15, weight: .semibold)
    private let dateLabel    = AppointmentCell.makeLabel(size: 13, color: .systemGray)
    private let addressLabel = AppointmentCell.makeLabel(size: 13, color: .systemGray)
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = .accent
        return l
    }()
    private let sizeLabel = AppointmentCell.makeLabel(size: 13, color: .secondaryLabel)

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    func configure(with item: AppointmentItem) {
        cleanerLabel.text = item.cleanerName
        dateLabel.text    = "📅 \(item.scheduledDate)  ⏰ \(item.scheduledTime)"
        addressLabel.text = "📍 \(item.address)"
        priceLabel.text   = item.formattedPrice
        sizeLabel.text    = "🏠 \(item.houseSize)"

        statusBadge.text             = " \(item.status.displayTitle) "
        statusBadge.backgroundColor  = item.statusColor
    }

    // MARK: - UI Setup

    private func setupUI() {
        selectionStyle     = .none
        backgroundColor    = .clear
        contentView.addSubview(cardView)

        cardView.addSubviews([
            cleanerIcon,
            cleanerLabel,
            statusBadge,
            dateLabel,
            addressLabel,
            sizeLabel,
            priceLabel
        ])

        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        cleanerIcon.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.size.equalTo(CGSize(width: 36, height: 36))
        }

        cleanerLabel.snp.makeConstraints {
            $0.centerY.equalTo(cleanerIcon)
            $0.leading.equalTo(cleanerIcon.snp.trailing).offset(10)
            $0.trailing.equalTo(statusBadge.snp.leading).offset(-8)
        }

        statusBadge.snp.makeConstraints {
            $0.centerY.equalTo(cleanerIcon)
            $0.trailing.equalToSuperview().inset(16)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(cleanerIcon.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        sizeLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(sizeLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    // MARK: - Helpers

    private static func makeLabel(size: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .label) -> UILabel {
        let l = UILabel()
        l.font      = .systemFont(ofSize: size, weight: weight)
        l.textColor = color
        l.numberOfLines = 0
        return l
    }
}

