//
//  SearchViewController.swift
//  Cleanzy
//

import SnapKit
import UIKit

final class SearchViewController: UIViewController {

    var presenter: SearchPresenterProtocol!

    private var items: [HomepageCleanerItem] = []

    private let loadingView: AuthenticationLoadingView = .init()

    // MARK: - UI

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder      = "Temizlikçi ara…"
        sb.searchBarStyle   = .minimal
        sb.delegate         = self
        sb.autocapitalizationType = .none
        sb.autocorrectionType     = .no
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor  = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        tv.separatorStyle   = .none
        tv.keyboardDismissMode = .onDrag
        tv.rowHeight          = UITableView.automaticDimension
        tv.estimatedRowHeight = 88
        tv.contentInset       = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        tv.dataSource = self
        tv.delegate   = self
        return tv
    }()

    private let emptyContainerView: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()

    private let emptyIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor         = .systemGray3
        iv.contentMode       = .scaleAspectFit
        return iv
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font          = .systemFont(ofSize: 15, weight: .medium)
        l.textColor     = .systemGray
        l.numberOfLines = 0
        return l
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Ara"
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)

        view.addSubviews([searchBar, tableView, emptyContainerView])
        emptyContainerView.addSubviews([emptyIconView, emptyLabel])

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyContainerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }

        emptyIconView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyIconView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - SearchViewProtocol

extension SearchViewController: SearchViewProtocol {
    func displayResults(_ items: [HomepageCleanerItem]) {
        self.items = items
        emptyContainerView.isHidden = true
        tableView.isHidden          = false
        tableView.reloadData()
    }

    func showEmpty(query: String) {
        items = []
        tableView.reloadData()
        tableView.isHidden          = false
        emptyContainerView.isHidden = false
        emptyLabel.text = query.isEmpty
            ? "Aramaya başlamak için bir isim girin."
            : "\"\(query)\" için sonuç bulunamadı."
    }

    func showLoading() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func hideLoading() { loadingView.removeFromSuperview() }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(with: alertModel, from: self)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didChangeQuery(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource / Delegate

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as! SearchResultCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectResult(at: indexPath.row)
    }
}

// MARK: - SearchResultCell

private final class SearchResultCell: UITableViewCell {
    static let reuseID = "SearchResultCell"

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor    = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor  = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowOffset  = CGSize(width: 0, height: 2)
        v.layer.shadowRadius  = 8
        return v
    }()

    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode      = .scaleAspectFill
        iv.clipsToBounds    = true
        iv.layer.cornerRadius = 24
        iv.backgroundColor  = UIColor.accent.withAlphaComponent(0.12)
        iv.image            = UIImage(systemName: "person.fill")
        iv.tintColor        = .accent
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .label
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 13)
        l.textColor = .systemGray
        return l
    }()

    private let rateLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 15, weight: .bold)
        l.textColor = .accent
        l.setContentHuggingPriority(.required, for: .horizontal)
        return l
    }()

    private let chevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor  = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle  = .none

        contentView.addSubview(cardView)
        cardView.addSubviews([avatarView, nameLabel, subtitleLabel, rateLabel, chevron])

        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(avatarView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(rateLabel.snp.leading).offset(-8)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(16)
        }

        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(chevron.snp.leading).offset(-6)
        }

        chevron.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(8)
            $0.height.equalTo(14)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with item: HomepageCleanerItem) {
        nameLabel.text     = item.fullName
        subtitleLabel.text = "⭐ \(String(format: "%.1f", item.rating))  (\(item.totalReviews) yorum)"
        rateLabel.text     = "₺\(Int(item.hourlyRate))/saat"
    }
}
