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

    // MARK: - Success Icon

    private let iconCircle: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.87, green: 0.97, blue: 0.89, alpha: 1.0)
        v.layer.cornerRadius = 40
        return v
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.circle.fill")
        iv.tintColor = UIColor(red: 0.18, green: 0.72, blue: 0.34, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // MARK: - Title & Description

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Randevunuz Başarıyla\nOluşturuldu!"
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = UIColor(red: 0.08, green: 0.09, blue: 0.12, alpha: 1.0)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Temizlik uzmanınız randevu saatinde belirttiğiniz adreste olacaktır. Randevu detaylarını 'Randevularım' sayfasından takip edebilirsiniz."
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor(red: 0.42, green: 0.46, blue: 0.54, alpha: 1.0)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    // MARK: - Summary Section

    private let summaryHeaderLabel: UILabel = {
        let l = UILabel()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
            .foregroundColor: UIColor(red: 0.52, green: 0.56, blue: 0.64, alpha: 1.0),
            .kern: CGFloat(1.3)
        ]
        l.attributedText = NSAttributedString(string: "RANDEVU ÖZETİ", attributes: attrs)
        return l
    }()

    private let summaryContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.0)
        v.layer.cornerRadius = 14
        return v
    }()

    private let summaryStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()

    // MARK: - Buttons

    private lazy var appointmentsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Randevularıma Git"
        config.image = UIImage(systemName: "calendar.badge.clock")
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor(red: 0.09, green: 0.12, blue: 0.20, alpha: 1.0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var a = attrs; a.font = UIFont.systemFont(ofSize: 16, weight: .semibold); return a
        }
        config.cornerStyle = .fixed
        let b = UIButton(configuration: config)
        b.layer.cornerRadius = 14
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(appointmentsTapped), for: .touchUpInside)
        return b
    }()

    private lazy var homeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Ana Sayfaya Dön"
        config.image = UIImage(systemName: "house")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseForegroundColor = UIColor(red: 0.42, green: 0.46, blue: 0.54, alpha: 1.0)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var a = attrs; a.font = UIFont.systemFont(ofSize: 15, weight: .medium); return a
        }
        let b = UIButton(configuration: config)
        b.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
    func homeTapped() { presenter?.didTapGoHome() }
}

// MARK: - Private Setup

private extension AppointmentConfirmViewController {

    func setupUI() {
        iconCircle.addSubview(iconImageView)
        summaryContainer.addSubview(summaryStack)

        view.addSubviews([
            iconCircle,
            titleLabel,
            descriptionLabel,
            summaryHeaderLabel,
            summaryContainer,
            appointmentsButton,
            homeButton
        ])

        configureLayout()
    }

    func configureLayout() {
        iconCircle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(38)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconCircle.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(28)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(32)
        }

        summaryHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(24)
        }

        summaryContainer.snp.makeConstraints {
            $0.top.equalTo(summaryHeaderLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        summaryStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        appointmentsButton.snp.makeConstraints {
            $0.top.equalTo(summaryContainer.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }

        homeButton.snp.makeConstraints {
            $0.top.equalTo(appointmentsButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
    }

    // MARK: - Populate

    func populate() {
        guard let item = presenter?.confirmItem else { return }
        let rows: [(icon: String, title: String, value: String)] = [
            ("sparkles",  "Hizmet", item.serviceSummary),
            ("calendar",  "Tarih",  item.formattedDate),
            ("clock",     "Saat",   item.timeSlot)
        ]
        rows.enumerated().forEach { index, row in
            summaryStack.addArrangedSubview(makeSummaryRow(
                icon: row.icon,
                title: row.title,
                value: row.value,
                showSeparator: index < rows.count - 1
            ))
        }
    }

    func makeSummaryRow(icon: String, title: String, value: String, showSeparator: Bool) -> UIView {
        let container = UIView()

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor(red: 0.18, green: 0.22, blue: 0.30, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit

        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = .systemFont(ofSize: 12, weight: .regular)
        titleLbl.textColor = UIColor(red: 0.55, green: 0.58, blue: 0.65, alpha: 1.0)

        let valueLbl = UILabel()
        valueLbl.text = value
        valueLbl.font = .systemFont(ofSize: 16, weight: .semibold)
        valueLbl.textColor = UIColor(red: 0.08, green: 0.10, blue: 0.16, alpha: 1.0)

        let textStack = UIStackView(arrangedSubviews: [titleLbl, valueLbl])
        textStack.axis = .vertical
        textStack.spacing = 2

        container.addSubviews([iconView, textStack])

        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }

        textStack.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        container.snp.makeConstraints { $0.height.equalTo(70) }

        if showSeparator {
            let sep = UIView()
            sep.backgroundColor = UIColor(red: 0.88, green: 0.89, blue: 0.91, alpha: 1.0)
            container.addSubview(sep)
            sep.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(50)
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
        AlertManager.shared.showAlert(
            with: AlertModel(title: alertModel.title, message: alertModel.message),
            from: self
        )
    }
}

#Preview {
    let mockItem = AppointmentConfirmItem(
        serviceSummary: "2+1 Ev Temizliği",
        formattedDate: "24 Ekim 2023, Perşembe",
        timeSlot: "09:00 - 13:00"
    )
    return AppointmentConfirmBuilder.createModule(with: mockItem)
}
