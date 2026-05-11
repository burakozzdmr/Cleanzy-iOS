//
//  ProfileViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    var presenter: ProfilePresenterProtocol!

    private let sections = ProfileSection.allCases

    // MARK: - Header

    private let headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()

    private let avatarContainer: UIView = UIView()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 44
        iv.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .accent
        return iv
    }()

    private let editBadge: UIView = {
        let v = UIView()
        v.backgroundColor = .accent
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()

    private let editBadgeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "pencil"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = UIColor(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)
        l.textAlignment = .center
        return l
    }()

    private let memberBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .accent
        l.textAlignment = .center
        l.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        return l
    }()

    // MARK: - TableView

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.sectionHeaderTopPadding = 0
        tv.register(ProfileRowCell.self, forCellReuseIdentifier: ProfileRowCell.reuseIdentifier)
        return tv
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private Setup

private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)

        navigationItem.title = "Profil"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
        navigationController?.navigationBar.backgroundColor = .white

        editBadge.addSubview(editBadgeIcon)
        avatarContainer.addSubviews([avatarImageView, editBadge])
        headerView.addSubviews([avatarContainer, nameLabel, memberBadge])
        view.addSubviews([tableView])

        tableView.tableHeaderView = headerView

        // Header layout
        avatarContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }

        avatarImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        editBadge.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(2)
            $0.width.height.equalTo(28)
        }

        editBadgeIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(14)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarContainer.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        memberBadge.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
            $0.bottom.equalToSuperview().inset(24)
        }

        memberBadge.snp.makeConstraints { $0.width.greaterThanOrEqualTo(100) }

        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        layoutHeaderView()
    }

    func layoutHeaderView() {
        headerView.layoutIfNeeded()
        let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let size = headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        headerView.frame = CGRect(origin: .zero, size: size)
        tableView.tableHeaderView = headerView
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func displayUserInfo(name: String, memberType: String) {
        nameLabel.text = name
        memberBadge.text = "  \(memberType)  "
        layoutHeaderView()
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

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileRowCell.reuseIdentifier, for: indexPath
        ) as? ProfileRowCell else { return UITableViewCell() }
        let row = sections[indexPath.section].rows[indexPath.row]
        let isLast = indexPath.row == sections[indexPath.section].rows.count - 1
        cell.configure(with: row, hideSeparator: isLast)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        return row.subtitle != nil ? 66 : 54
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = sections[section].title
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = UIColor(red: 0.52, green: 0.56, blue: 0.64, alpha: 1.0)

        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(6)
        }
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 32 : 38
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == sections.count - 1 else { return UIView() }
        let label = UILabel()
        label.text = "Sürüm 2.4.0 (154)"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.systemGray3
        label.textAlignment = .center
        let container = UIView()
        container.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return container
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == sections.count - 1 ? 52 : 12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        presenter?.didTapRow(row)
    }
}

// MARK: - ProfileRowCell

private final class ProfileRowCell: UITableViewCell {
    static let reuseIdentifier = "ProfileRowCell"

    private let iconContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        return v
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .medium)
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = UIColor.systemGray
        l.isHidden = true
        return l
    }()

    private let chevronView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = UIColor.systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1.0)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with row: ProfileRow, hideSeparator: Bool) {
        iconView.image = UIImage(systemName: row.iconName)
        iconContainer.backgroundColor = row.iconBackgroundColor
        titleLabel.text = row.title
        titleLabel.textColor = row.isDestructive
            ? UIColor(red: 0.95, green: 0.25, blue: 0.25, alpha: 1.0)
            : UIColor(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)
        backgroundColor = row.isDestructive
            ? UIColor(red: 1.0, green: 0.93, blue: 0.93, alpha: 1.0)
            : .white

        if let sub = row.subtitle {
            subtitleLabel.text = sub
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        separator.isHidden = hideSeparator
    }

    private func setupUI() {
        selectionStyle = .none
        layer.cornerRadius = 14

        iconContainer.addSubview(iconView)
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        contentView.addSubviews([iconContainer, textStack, chevronView, separator])

        iconContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }

        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(18)
        }

        textStack.snp.makeConstraints {
            $0.leading.equalTo(iconContainer.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(chevronView.snp.leading).offset(-8)
        }

        chevronView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(14)
        }

        separator.snp.makeConstraints {
            $0.leading.equalTo(iconContainer.snp.trailing).offset(12)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: ProfileBuilder.createModule())
}
