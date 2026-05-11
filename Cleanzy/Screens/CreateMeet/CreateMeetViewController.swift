//
//  CreateMeetViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class CreateMeetViewController: UIViewController {

    // MARK: - Properties

    var presenter: CreateMeetPresenterProtocol!

    private let loadingView: AuthenticationLoadingView = .init()

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
        sv.spacing = 16
        return sv
    }()

    // MARK: - Address Card

    private let addressCard: UIView = .init()

    /// Seçilen adres metni için etiket
    private let addressValueLabel: UILabel = {
        let l = UILabel()
        l.text          = "Konum seçmek için dokunun"
        l.font          = .systemFont(ofSize: 14, weight: .regular)
        l.textColor     = .systemGray
        l.numberOfLines = 2
        return l
    }()

    private let addressChevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor   = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // MARK: - Calendar Card

    private let calendarCard: UIView = .init()
    private let calendarView: CalendarView = .init()

    // MARK: - Time Slot Card

    private let timeCard: UIView = .init()
    private let timeSlotSelector: TimeSlotSelectorView = .init()

    // MARK: - House Size Card

    private let houseSizeCard: UIView = .init()
    private var houseSizeButtons: [UIButton] = []
    private var selectedHouseSize: HouseSize = .medium

    // MARK: - Extra Services Card

    private let extrasCard: UIView = .init()
    private let extrasStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis    = .vertical
        sv.spacing = 0
        return sv
    }()

    // MARK: - Payment Card

    private let paymentMethodCard: UIView = .init()

    private let paymentMethodValueLabel: UILabel = {
        let l = UILabel()
        l.text      = "Kart seçmek için dokunun"
        l.font      = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .systemGray
        return l
    }()

    private var savedCards: [PaymentCardItem] = {
        // In-memory kartlar — backend hazır olunca service ile çekilecek
        [
            PaymentCardItem(holderName: "KART SAHİBİ", lastFour: "4242", expiryDate: "12/27", isDefault: true),
            PaymentCardItem(holderName: "KART SAHİBİ", lastFour: "5353", expiryDate: "08/26")
        ]
    }()

    private var selectedCardIndex: Int? = nil

    // MARK: - Bottom Bar

    private let bottomBar: UIView = {
        let v = UIView()
        v.backgroundColor    = .white
        v.layer.shadowColor  = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowOffset  = CGSize(width: 0, height: -4)
        v.layer.shadowRadius  = 8
        return v
    }()

    private let totalTitleLabel: UILabel = {
        let l = UILabel()
        l.text      = "TOPLAM TUTAR"
        l.font      = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = .systemGray
        return l
    }()

    private let totalPriceLabel: UILabel = {
        let l = UILabel()
        l.font      = .systemFont(ofSize: 26, weight: .bold)
        l.textColor = .black
        return l
    }()

    private lazy var confirmButton: UIButton = {
        let b = UIButton()
        b.setTitle("Randevuyu Onayla", for: .normal)
        b.titleLabel?.font  = .systemFont(ofSize: 15, weight: .semibold)
        b.backgroundColor   = .accent
        b.layer.cornerRadius = 14
        b.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar()
    }
}

// MARK: - Objective-C

@objc private extension CreateMeetViewController {
    func backTapped()           { presenter?.didTapBack() }
    func confirmTapped()        { presenter?.didTapConfirm() }
    func addressCardTapped()    { openLocationPicker() }
    func paymentCardTapped()    { openPaymentSheet() }

    func houseSizeTapped(_ sender: UIButton) {
        let size = HouseSize.allCases[sender.tag]
        selectedHouseSize = size
        applyHouseSizeSelection()
        presenter?.didSelectHouseSize(size)
    }

    func extraToggled(_ sender: UISwitch) {
        presenter?.didToggleExtraService(at: sender.tag)
    }
}

// MARK: - Payment Sheet

private extension CreateMeetViewController {
    func openPaymentSheet() {
        let sheet = PaymentSelectionSheetViewController(cards: savedCards, selectedIndex: selectedCardIndex)
        sheet.onCardSelected = { [weak self] card in
            guard let self else { return }
            self.selectedCardIndex = self.savedCards.firstIndex(where: { $0.id == card.id })
            self.presenter?.didSelectPaymentCard(card)
        }
        if let sheet = sheet.sheetPresentationController {
            sheet.detents          = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(sheet, animated: true)
    }
}

// MARK: - Location Picker

private extension CreateMeetViewController {
    func openLocationPicker() {
        let picker = LocationPickerViewController()
        picker.onLocationSelected = { [weak self] address in
            self?.addressValueLabel.text      = address
            self?.addressValueLabel.textColor = .label
            self?.presenter?.didChangeAddress(address)
        }
        let nav = UINavigationController(rootViewController: picker)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - Private Setup

private extension CreateMeetViewController {

    func setupNavigationBar() {
        navigationItem.title = "Randevu Oluştur"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
    }

    func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        addViews()
        configureLayout()
        setupCalendarCallbacks()
    }

    func addViews() {
        view.addSubviews([scrollView, bottomBar])
        scrollView.addSubview(contentStack)

        buildAddressCard()
        buildCalendarCard()
        buildTimeCard()
        buildHouseSizeCard()
        buildExtrasCard()
        buildPaymentMethodCard()

        [addressCard, calendarCard, timeCard, houseSizeCard, extrasCard, paymentMethodCard].forEach {
            styleCard($0)
            contentStack.addArrangedSubview($0)
        }

        bottomBar.addSubviews([totalTitleLabel, totalPriceLabel, confirmButton])
    }

    func configureLayout() {
        // Bottom bar — pinned to real screen bottom, content sits above safe area
        bottomBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }

        contentStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide).inset(
                UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            )
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-32)
        }

        totalTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(20)
        }

        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(totalTitleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(20)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(165)
            $0.height.equalTo(52)
        }
    }

    // MARK: - Card Builders

    func buildAddressCard() {
        let sectionLabel = makeSectionLabel("Adres")

        let pinIcon = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        pinIcon.tintColor   = .accent
        pinIcon.contentMode = .scaleAspectFit

        let tapArea = UIView()
        tapArea.backgroundColor   = UIColor.systemGray6
        tapArea.layer.cornerRadius = 12
        let tap = UITapGestureRecognizer(target: self, action: #selector(addressCardTapped))
        tapArea.addGestureRecognizer(tap)
        tapArea.isUserInteractionEnabled = true

        tapArea.addSubviews([pinIcon, addressValueLabel, addressChevron])
        addressCard.addSubviews([sectionLabel, tapArea])

        sectionLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        tapArea.snp.makeConstraints {
            $0.top.equalTo(sectionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(52)
        }
        pinIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        addressChevron.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(14)
        }
        addressValueLabel.snp.makeConstraints {
            $0.leading.equalTo(pinIcon.snp.trailing).offset(10)
            $0.trailing.equalTo(addressChevron.snp.leading).offset(-8)
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().inset(14)
        }
    }

    func buildCalendarCard() {
        let titleLabel = makeSectionLabel("Tarih Seçimi")
        calendarCard.addSubviews([titleLabel, calendarView])
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        calendarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(210)
        }
    }

    func buildTimeCard() {
        let titleLabel = makeSectionLabel("Saat Seçimi")
        timeCard.addSubviews([titleLabel, timeSlotSelector])
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        timeSlotSelector.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    func buildHouseSizeCard() {
        let titleLabel = makeSectionLabel("Evin Büyüklüğü")
        let sizeStack = UIStackView()
        sizeStack.axis         = .horizontal
        sizeStack.spacing      = 12
        sizeStack.distribution = .fillEqually

        HouseSize.allCases.enumerated().forEach { index, size in
            let btn = UIButton()
            btn.setTitle(size.rawValue, for: .normal)
            btn.titleLabel?.font  = .systemFont(ofSize: 16, weight: .semibold)
            btn.layer.cornerRadius = 12
            btn.layer.borderWidth  = 1.5
            btn.tag = index
            btn.addTarget(self, action: #selector(houseSizeTapped(_:)), for: .touchUpInside)
            sizeStack.addArrangedSubview(btn)
            houseSizeButtons.append(btn)
        }

        houseSizeCard.addSubviews([titleLabel, sizeStack])
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        sizeStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(16)
        }
        applyHouseSizeSelection()
    }

    func buildExtrasCard() {
        let titleLabel = makeSectionLabel("Ek Hizmetler")
        extrasCard.addSubviews([titleLabel, extrasStackView])
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        extrasStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    func buildPaymentMethodCard() {
        let sectionLabel = makeSectionLabel("Ödeme Yöntemi")

        let cardIcon = UIImageView(image: UIImage(systemName: "creditcard.fill"))
        cardIcon.tintColor   = .accent
        cardIcon.contentMode = .scaleAspectFit

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor   = .systemGray3
        chevron.contentMode = .scaleAspectFit

        let tapArea = UIView()
        tapArea.backgroundColor    = UIColor.systemGray6
        tapArea.layer.cornerRadius = 12
        let tap = UITapGestureRecognizer(target: self, action: #selector(paymentCardTapped))
        tapArea.addGestureRecognizer(tap)
        tapArea.isUserInteractionEnabled = true

        tapArea.addSubviews([cardIcon, paymentMethodValueLabel, chevron])
        paymentMethodCard.addSubviews([sectionLabel, tapArea])

        sectionLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        tapArea.snp.makeConstraints {
            $0.top.equalTo(sectionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
        cardIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        chevron.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(14)
        }
        paymentMethodValueLabel.snp.makeConstraints {
            $0.leading.equalTo(cardIcon.snp.trailing).offset(10)
            $0.trailing.equalTo(chevron.snp.leading).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Calendar Callbacks

    func setupCalendarCallbacks() {
        calendarView.onDateSelected = { [weak self] date in
            self?.presenter?.didSelectDate(date)
        }
        timeSlotSelector.onTimeSelected = { [weak self] time in
            self?.presenter?.didSelectTime(time)
        }
    }

    // MARK: - House Size Styling

    func applyHouseSizeSelection() {
        houseSizeButtons.enumerated().forEach { index, btn in
            let isSelected = HouseSize.allCases[index] == selectedHouseSize
            btn.layer.borderColor = isSelected ? UIColor.accent.cgColor : UIColor.systemGray3.cgColor
            btn.setTitleColor(isSelected ? .accent : .systemGray, for: .normal)
        }
    }

    // MARK: - Factory Helpers

    func styleCard(_ card: UIView) {
        card.backgroundColor    = .white
        card.layer.cornerRadius  = 16
        card.layer.shadowColor   = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.05
        card.layer.shadowOffset  = CGSize(width: 0, height: 4)
        card.layer.shadowRadius  = 8
    }

    func makeSectionLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text      = text.uppercased()
        l.font      = .systemFont(ofSize: 11, weight: .bold)
        l.textColor = .systemGray
        l.letterSpacing(1.2)
        return l
    }

    func makeExtraServiceRow(_ item: ExtraServiceItem, at index: Int) -> UIView {
        let container = UIView()

        let iconView = UIImageView(image: UIImage(systemName: item.icon))
        iconView.tintColor   = .accent
        iconView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text  = item.title
        titleLabel.font  = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .black

        let priceLabel = UILabel()
        priceLabel.text  = "+\(item.price) TL"
        priceLabel.font  = .systemFont(ofSize: 13, weight: .regular)
        priceLabel.textColor = .systemGray

        let textStack = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        textStack.axis    = .vertical
        textStack.spacing = 2

        let toggle = UISwitch()
        toggle.onTintColor = .accent
        toggle.isOn        = item.isEnabled
        toggle.tag         = index
        toggle.addTarget(self, action: #selector(extraToggled(_:)), for: .valueChanged)

        let separator = UIView()
        separator.backgroundColor = UIColor.systemGray5

        container.addSubviews([iconView, textStack, toggle, separator])

        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        textStack.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        separator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        container.snp.makeConstraints { $0.height.equalTo(68) }

        if item.isEnabled {
            container.backgroundColor    = UIColor.accent.withAlphaComponent(0.04)
            container.layer.cornerRadius = 12
        }
        return container
    }
}

// MARK: - CreateMeetViewProtocol

extension CreateMeetViewController: CreateMeetViewProtocol {
    func updateTotalPrice(_ formatted: String) {
        totalPriceLabel.text = formatted
    }

    func updatePaymentCard(label: String) {
        paymentMethodValueLabel.text      = label
        paymentMethodValueLabel.textColor = .label
    }

    func reloadExtraServices(_ items: [ExtraServiceItem]) {
        extrasStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        items.enumerated().forEach { index, item in
            extrasStackView.addArrangedSubview(makeExtraServiceRow(item, at: index))
        }
    }

    func showLoading() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func hideLoading() { loadingView.removeFromSuperview() }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(
            with: AlertModel(title: alertModel.title, message: alertModel.message),
            from: self
        )
    }
}

// MARK: - UILabel letterSpacing

private extension UILabel {
    func letterSpacing(_ value: CGFloat) {
        guard let text else { return }
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(.kern, value: value, range: NSRange(location: 0, length: text.count))
        attributedText = attributed
    }
}

#Preview {
    UINavigationController(rootViewController: CreateMeetViewController())
}
