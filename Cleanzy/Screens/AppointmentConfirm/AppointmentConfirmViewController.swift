//
//  AppointmentConfirmViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class AppointmentConfirmViewController: UIViewController {

    // MARK: - Properties

    var presenter: AppointmentConfirmPresenterProtocol!

    // MARK: - Scroll

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis    = .vertical
        sv.spacing = 0
        sv.alignment = .fill
        return sv
    }()

    // MARK: - Success Hero

    private let heroView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.94, alpha: 1.0)
        return v
    }()

    private let iconCircle: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.20, green: 0.78, blue: 0.38, alpha: 1.0)
        v.layer.cornerRadius = 44
        return v
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark"))
        iv.tintColor   = .white
        iv.contentMode = .scaleAspectFit
        iv.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text          = "Randevunuz Oluşturuldu!"
        l.font          = .systemFont(ofSize: 22, weight: .bold)
        l.textColor     = UIColor(red: 0.08, green: 0.09, blue: 0.12, alpha: 1.0)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text          = "Temizlik uzmanınız belirtilen saatte adresinizde olacaktır."
        l.font          = .systemFont(ofSize: 14, weight: .regular)
        l.textColor     = UIColor(red: 0.36, green: 0.40, blue: 0.48, alpha: 1.0)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    // MARK: - Details Card

    private let detailsCard: UIView = {
        let v = UIView()
        v.backgroundColor    = .white
        v.layer.cornerRadius  = 20
        v.layer.shadowColor   = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.07
        v.layer.shadowOffset  = CGSize(width: 0, height: 4)
        v.layer.shadowRadius  = 16
        return v
    }()

    private let detailsHeaderLabel: UILabel = {
        let l = UILabel()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .bold),
            .foregroundColor: UIColor.systemGray,
            .kern: CGFloat(1.4)
        ]
        l.attributedText = NSAttributedString(string: "RANDEVU DETAYLARI", attributes: attrs)
        return l
    }()

    private let detailsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis    = .vertical
        sv.spacing = 0
        return sv
    }()

    // MARK: - Payment Card

    private let paymentCard: UIView = {
        let v = UIView()
        v.backgroundColor    = .white
        v.layer.cornerRadius  = 20
        v.layer.shadowColor   = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.07
        v.layer.shadowOffset  = CGSize(width: 0, height: 4)
        v.layer.shadowRadius  = 16
        return v
    }()

    private let paymentHeaderLabel: UILabel = {
        let l = UILabel()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .bold),
            .foregroundColor: UIColor.systemGray,
            .kern: CGFloat(1.4)
        ]
        l.attributedText = NSAttributedString(string: "ÖDEME BİLGİSİ", attributes: attrs)
        return l
    }()

    private let paymentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis    = .vertical
        sv.spacing = 0
        return sv
    }()

    // MARK: - Buttons

    private lazy var appointmentsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title           = "Randevularıma Git"
        config.image           = UIImage(systemName: "calendar.badge.clock")
        config.imagePadding    = 10
        config.imagePlacement  = .leading
        config.baseForegroundColor    = .white
        config.baseBackgroundColor    = UIColor(red: 0.09, green: 0.12, blue: 0.20, alpha: 1.0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { a in
            var a = a; a.font = UIFont.systemFont(ofSize: 16, weight: .semibold); return a
        }
        config.cornerStyle = .fixed
        let b = UIButton(configuration: config)
        b.layer.cornerRadius  = 16
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(appointmentsTapped), for: .touchUpInside)
        return b
    }()

    private lazy var homeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title          = "Ana Sayfaya Dön"
        config.image          = UIImage(systemName: "house")
        config.imagePadding   = 8
        config.imagePlacement = .leading
        config.baseForegroundColor = UIColor(red: 0.42, green: 0.46, blue: 0.54, alpha: 1.0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { a in
            var a = a; a.font = UIFont.systemFont(ofSize: 15, weight: .medium); return a
        }
        let b = UIButton(configuration: config)
        b.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        setupUI()
        populate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.hidesBackButton = true
    }
}

// MARK: - Objective-C

@objc private extension AppointmentConfirmViewController {
    func appointmentsTapped() { presenter?.didTapGoToAppointments() }
    func homeTapped()         { presenter?.didTapGoHome() }
}

// MARK: - Private Setup

private extension AppointmentConfirmViewController {

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        // Hero
        heroView.addSubviews([iconCircle, titleLabel, subtitleLabel])
        iconCircle.addSubview(iconImageView)

        // Details card
        detailsCard.addSubviews([detailsHeaderLabel, detailsStack])

        // Payment card
        paymentCard.addSubviews([paymentHeaderLabel, paymentStack])

        // Button wrapper for padding
        let buttonWrapper = UIView()
        buttonWrapper.addSubviews([appointmentsButton, homeButton])
        appointmentsButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        homeButton.snp.makeConstraints {
            $0.top.equalTo(appointmentsButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }

        contentStack.addArrangedSubview(heroView)

        let cardsWrapper = UIView()
        cardsWrapper.addSubviews([detailsCard, paymentCard, buttonWrapper])
        detailsCard.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        paymentCard.snp.makeConstraints {
            $0.top.equalTo(detailsCard.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        buttonWrapper.snp.makeConstraints {
            $0.top.equalTo(paymentCard.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
        contentStack.addArrangedSubview(cardsWrapper)

        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        configureHeroLayout()
        configureDetailCardLayout()
        configurePaymentCardLayout()
    }

    func configureHeroLayout() {
        iconCircle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88)
        }
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconCircle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-32)
        }
    }

    func configureDetailCardLayout() {
        detailsHeaderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        detailsStack.snp.makeConstraints {
            $0.top.equalTo(detailsHeaderLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    func configurePaymentCardLayout() {
        paymentHeaderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        paymentStack.snp.makeConstraints {
            $0.top.equalTo(paymentHeaderLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    // MARK: - Populate

    func populate() {
        guard let item = presenter?.confirmItem else { return }

        let detailRows: [(icon: String, title: String, value: String)] = [
            ("sparkles",       "Hizmet",      item.serviceSummary),
            ("person.fill",    "Temizlikçi",  item.cleanerName),
            ("calendar",       "Tarih",       item.formattedDate),
            ("clock",          "Saat",        item.timeSlot),
            ("mappin.circle",  "Adres",       item.address)
        ]

        detailRows.enumerated().forEach { idx, row in
            detailsStack.addArrangedSubview(
                makeSummaryRow(icon: row.icon, title: row.title, value: row.value,
                               showSeparator: idx < detailRows.count - 1)
            )
        }

        let paymentRows: [(icon: String, title: String, value: String)] = [
            ("creditcard.fill", "Ödeme Yöntemi", item.paymentCard),
            ("turkishlirasign.circle.fill", "Toplam Tutar", item.totalAmount)
        ]

        paymentRows.enumerated().forEach { idx, row in
            paymentStack.addArrangedSubview(
                makeSummaryRow(icon: row.icon, title: row.title, value: row.value,
                               showSeparator: idx < paymentRows.count - 1,
                               highlightValue: idx == paymentRows.count - 1)
            )
        }
    }

    func makeSummaryRow(
        icon: String,
        title: String,
        value: String,
        showSeparator: Bool,
        highlightValue: Bool = false
    ) -> UIView {
        let container = UIView()

        let iconBg = UIView()
        iconBg.backgroundColor    = UIColor.accent.withAlphaComponent(0.10)
        iconBg.layer.cornerRadius  = 10

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor   = .accent
        iconView.contentMode = .scaleAspectFit
        iconBg.addSubview(iconView)

        let titleLbl = UILabel()
        titleLbl.text      = title
        titleLbl.font      = .systemFont(ofSize: 12, weight: .medium)
        titleLbl.textColor = .systemGray

        let valueLbl = UILabel()
        valueLbl.text      = value
        valueLbl.font      = highlightValue
            ? .systemFont(ofSize: 18, weight: .bold)
            : .systemFont(ofSize: 15, weight: .semibold)
        valueLbl.textColor = highlightValue ? .accent : .label
        valueLbl.numberOfLines = 2

        let textStack = UIStackView(arrangedSubviews: [titleLbl, valueLbl])
        textStack.axis    = .vertical
        textStack.spacing = 3

        container.addSubviews([iconBg, textStack])

        iconBg.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(38)
        }
        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        textStack.snp.makeConstraints {
            $0.leading.equalTo(iconBg.snp.trailing).offset(14)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().inset(14)
        }

        if showSeparator {
            let sep = UIView()
            sep.backgroundColor = UIColor.systemGray5
            container.addSubview(sep)
            sep.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(68)
                $0.trailing.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
        }

        return container
    }
}

// MARK: - AppointmentConfirmViewProtocol

extension AppointmentConfirmViewController: AppointmentConfirmViewProtocol {
    func showLoading() { }
    func hideLoading() { }
    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(with: AlertModel(title: alertModel.title, message: alertModel.message), from: self)
    }
}

#Preview {
    let mockItem = AppointmentConfirmItem(
        serviceSummary: "2+1 Ev Temizliği",
        formattedDate: "24 Mayıs 2026, Pazar",
        timeSlot: "09:00 - 13:00",
        address: "Etiler Mah. Nispetiye Cad. No:12, Beşiktaş, İstanbul",
        totalAmount: "₺1.080",
        paymentCard: "Visa **** 4242",
        cleanerName: "Ahmet Yılmaz"
    )
    return AppointmentConfirmBuilder.createModule(with: mockItem)
}
