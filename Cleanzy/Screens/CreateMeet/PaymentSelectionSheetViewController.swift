//
//  PaymentSelectionSheetViewController.swift
//  Cleanzy
//

import SnapKit
import UIKit

// MARK: - PaymentSelectionSheetViewController

final class PaymentSelectionSheetViewController: UIViewController {

    // MARK: - Callback

    var onCardSelected: ((PaymentCardItem) -> Void)?

    // MARK: - State

    private var cards: [PaymentCardItem]
    private var selectedIndex: Int?

    // MARK: - UI

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text      = "Ödeme Yöntemi Seç"
        l.font      = .systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .label
        return l
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor    = .clear
        tv.separatorStyle     = .none
        tv.rowHeight           = 72
        tv.isScrollEnabled     = false
        tv.register(SheetCardCell.self, forCellReuseIdentifier: SheetCardCell.reuseID)
        tv.dataSource = self
        tv.delegate   = self
        return tv
    }()

    private lazy var emptyLabel: UILabel = {
        let l = UILabel()
        l.text          = "Kayıtlı kart bulunamadı."
        l.font          = .systemFont(ofSize: 15)
        l.textColor     = .systemGray
        l.textAlignment = .center
        l.isHidden      = true
        return l
    }()

    private lazy var addCardButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title        = "Yeni Kart Ekle"
        config.image        = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 8
        config.baseForegroundColor = .accent
        config.baseBackgroundColor = .accent
        config.cornerStyle  = .fixed
        let b = UIButton(configuration: config)
        b.layer.cornerRadius  = 14
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Init

    init(cards: [PaymentCardItem], selectedIndex: Int? = nil) {
        self.cards         = cards
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup

private extension PaymentSelectionSheetViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubviews([titleLabel, tableView, emptyLabel, addCardButton])

        // Native UISheetPresentationController grabber yaklaşık 20pt alıyor,
        // safeAreaLayoutGuide.top bunu zaten hesaba katıyor.
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        emptyLabel.isHidden = !cards.isEmpty
        tableView.isHidden  = cards.isEmpty

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(cards.count * 72)
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        addCardButton.snp.makeConstraints {
            $0.top.equalTo(cards.isEmpty
                ? emptyLabel.snp.bottom
                : tableView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

// MARK: - Actions

@objc private extension PaymentSelectionSheetViewController {
    func addCardTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension PaymentSelectionSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cards.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SheetCardCell.reuseID, for: indexPath) as! SheetCardCell
        cell.configure(with: cards[indexPath.row], isSelected: indexPath.row == selectedIndex)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PaymentSelectionSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let card = cards[indexPath.row]
        onCardSelected?(card)
        dismiss(animated: true)
    }
}

// MARK: - SheetCardCell

private final class SheetCardCell: UITableViewCell {
    static let reuseID = "SheetCardCell"

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor    = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
        v.layer.cornerRadius = 14
        return v
    }()

    private let brandIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let numberLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .label
        return l
    }()

    private let holderLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        return l
    }()

    private let checkmark: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        iv.tintColor   = .accent
        iv.contentMode = .scaleAspectFit
        iv.isHidden    = true
        return iv
    }()

    private let defaultBadge: UILabel = {
        let l = UILabel()
        l.text = " Varsayılan "
        l.font = .systemFont(ofSize: 10, weight: .semibold)
        l.textColor = .white
        l.backgroundColor = .accent
        l.layer.cornerRadius = 5
        l.clipsToBounds = true
        l.isHidden = true
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor  = .clear
        selectionStyle   = .none

        contentView.addSubview(cardView)
        cardView.addSubviews([brandIconView, numberLabel, holderLabel, checkmark, defaultBadge])

        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview()
        }

        brandIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }

        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(brandIconView.snp.trailing).offset(12)
        }

        holderLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(3)
            $0.leading.equalTo(numberLabel)
        }

        defaultBadge.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(8)
        }

        checkmark.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with card: PaymentCardItem, isSelected: Bool) {
        brandIconView.image   = card.brand.icon
        brandIconView.tintColor = card.brand.tintColor
        numberLabel.text      = card.maskedNumber
        holderLabel.text      = card.holderName
        checkmark.isHidden    = !isSelected
        defaultBadge.isHidden = !card.isDefault

        cardView.backgroundColor = isSelected
            ? UIColor.accent.withAlphaComponent(0.08)
            : UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
        cardView.layer.borderColor = isSelected ? UIColor.accent.cgColor : UIColor.clear.cgColor
        cardView.layer.borderWidth = isSelected ? 1.5 : 0
    }
}
