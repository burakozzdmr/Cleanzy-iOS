//
//  UserDetailViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class UserDetailViewController: UIViewController {

    // MARK: - Properties

    var presenter: UserDetailPresenterProtocol!

    private let loadingView: AuthenticationLoadingView = .init()

    // MARK: - Scroll & Layout

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentView = UIView()

    // MARK: - Profile Header

    private let profileCard: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 52
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.accent.cgColor
        iv.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        iv.image = UIImage(systemName: "person.fill")
        iv.tintColor = .accent
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = .black
        l.textAlignment = .center
        return l
    }()

    private let starImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star.fill"))
        iv.tintColor = UIColor(red: 1.0, green: 0.75, blue: 0.0, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let ratingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .black
        return l
    }()

    private let reviewCountLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .systemGray
        return l
    }()

    private let ratingStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .center
        return sv
    }()

    private let verifiedBadge: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        v.layer.cornerRadius = 14
        v.isHidden = true
        return v
    }()

    private let verifiedIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark.shield.fill"))
        iv.tintColor = .accent
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let verifiedLabel: UILabel = {
        let l = UILabel()
        l.text = "Doğrulanmış Profil"
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .accent
        return l
    }()

    // MARK: - Services

    private let servicesCard = UIView()
    private let servicesScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    private let servicesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    // MARK: - Rate

    private let rateCard = UIView()
    private let hourlyRateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textColor = .accent
        return l
    }()

    // MARK: - About

    private let aboutCard = UIView()
    private let biographyLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = UIColor.darkGray
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()

    // MARK: - Availability

    private let availabilityCard = UIView()
    private let scheduleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()

    // MARK: - Reviews

    private let reviewsCard = UIView()
    private let reviewsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()

    // MARK: - Favorite Button

    private lazy var favoriteButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.tintColor = UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 1.0)
        b.backgroundColor = .white
        b.layer.cornerRadius = 18
        b.layer.shadowColor = UIColor.black.cgColor
        b.layer.shadowOpacity = 0.10
        b.layer.shadowOffset = CGSize(width: 0, height: 2)
        b.layer.shadowRadius = 4
        b.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Chat Button

    private lazy var chatButton: UIButton = {
        let b = UIButton()
        b.setTitle("Sohbet Başlat", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        b.setTitleColor(.accent, for: .normal)
        b.backgroundColor = .white
        b.layer.cornerRadius = 16
        b.layer.borderWidth = 2
        b.layer.borderColor = UIColor.accent.cgColor
        b.setImage(UIImage(systemName: "message.fill"), for: .normal)
        b.tintColor = .accent
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        b.addTarget(self, action: #selector(chatTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Appointment Button

    private lazy var appointmentButton: UIButton = {
        let b = UIButton()
        b.setTitle("Randevu Oluştur", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor = .accent
        b.layer.cornerRadius = 16
        b.addTarget(self, action: #selector(appointmentTapped), for: .touchUpInside)
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
        setupNavigationBar()
    }
}

// MARK: - Objective-C Methods

@objc private extension UserDetailViewController {
    func backTapped() {
        presenter?.view = nil
        navigationController?.popViewController(animated: true)
    }

    func appointmentTapped() {
        presenter?.didTapCreateMeet()
    }

    func chatTapped() {
        presenter?.didTapChat()
    }

    func favoriteTapped() {
        presenter?.didTapFavorite()
    }
}

// MARK: - Private Setup

private extension UserDetailViewController {

    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Temizlikçi Detay Sayfası"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black

        favoriteButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.black
        ]
    }

    func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        addViews()
        configureLayout()
    }

    func addViews() {
        view.addSubviews([scrollView, chatButton, appointmentButton])
        scrollView.addSubview(contentView)

        // Profile card
        contentView.addSubview(profileCard)
        profileCard.addSubviews([avatarImageView, nameLabel, ratingStackView, verifiedBadge])
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewCountLabel)
        verifiedBadge.addSubviews([verifiedIconView, verifiedLabel])

        // Content cards
        [servicesCard, rateCard, aboutCard, availabilityCard, reviewsCard].forEach {
            contentView.addSubview($0)
            styleCard($0)
        }

        // Services
        servicesCard.addSubview(servicesScrollView)
        servicesScrollView.addSubview(servicesStackView)

        // Rate
        let rateSubtitle = makeCardTitleLabel("Saatlik Ücret")
        rateCard.addSubviews([rateSubtitle, hourlyRateLabel])

        // About
        let aboutTitle = makeCardTitleLabel("Hakkında")
        aboutCard.addSubviews([aboutTitle, biographyLabel])

        // Availability
        let availabilityTitle = makeCardTitleLabel("Müsaitlik")
        availabilityCard.addSubviews([availabilityTitle, scheduleStackView])

        // Reviews header
        let reviewsTitleLabel = makeCardTitleLabel("Yorumlar")
        let seeAllButton = makeSeeAllButton()
        let reviewsHeaderStack = UIStackView(arrangedSubviews: [reviewsTitleLabel, seeAllButton])
        reviewsHeaderStack.axis = .horizontal
        reviewsHeaderStack.distribution = .equalSpacing
        reviewsHeaderStack.alignment = .center
        reviewsCard.addSubviews([reviewsHeaderStack, reviewsStackView])

        configureCardLayouts(
            rateSubtitle: rateSubtitle,
            aboutTitle: aboutTitle,
            availabilityTitle: availabilityTitle,
            reviewsHeaderStack: reviewsHeaderStack
        )
    }

    func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(chatButton.snp.top).offset(-8)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        // Profile card
        profileCard.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(104)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        ratingStackView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        starImageView.snp.makeConstraints { $0.width.height.equalTo(15) }

        verifiedBadge.snp.makeConstraints {
            $0.top.equalTo(ratingStackView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(28)
        }

        verifiedIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }

        verifiedLabel.snp.makeConstraints {
            $0.leading.equalTo(verifiedIconView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        // Cards stack
        let cards = [servicesCard, rateCard, aboutCard, availabilityCard, reviewsCard]
        for (i, card) in cards.enumerated() {
            card.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                if i == 0 {
                    $0.top.equalTo(profileCard.snp.bottom).offset(16)
                } else {
                    $0.top.equalTo(cards[i - 1].snp.bottom).offset(12)
                }
                if i == cards.count - 1 {
                    $0.bottom.equalToSuperview().inset(16)
                }
            }
        }

        // Services scroll
        servicesScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(36)
            $0.bottom.equalToSuperview().inset(16)
        }

        servicesStackView.snp.makeConstraints {
            $0.edges.equalTo(servicesScrollView.contentLayoutGuide)
            $0.height.equalTo(servicesScrollView.frameLayoutGuide)
        }

        // Bottom action buttons — chat (left) + appointment (right)
        chatButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(54)
            $0.trailing.equalTo(view.snp.centerX).offset(-6)
        }

        appointmentButton.snp.makeConstraints {
            $0.leading.equalTo(view.snp.centerX).offset(6)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(54)
        }
    }

    func configureCardLayouts(
        rateSubtitle: UILabel,
        aboutTitle: UILabel,
        availabilityTitle: UILabel,
        reviewsHeaderStack: UIStackView
    ) {
        // Rate card
        rateSubtitle.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        hourlyRateLabel.snp.makeConstraints {
            $0.top.equalTo(rateSubtitle.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        // About card
        aboutTitle.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        biographyLabel.snp.makeConstraints {
            $0.top.equalTo(aboutTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        // Availability card
        availabilityTitle.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        scheduleStackView.snp.makeConstraints {
            $0.top.equalTo(availabilityTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        // Reviews card
        reviewsHeaderStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        reviewsStackView.snp.makeConstraints {
            $0.top.equalTo(reviewsHeaderStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    // MARK: - Factory Helpers

    func styleCard(_ card: UIView) {
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowRadius = 8
    }

    func makeCardTitleLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 17, weight: .bold)
        l.textColor = .black
        return l
    }

    func makeSeeAllButton() -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle("Tümünü Gör", for: .normal)
        b.setTitleColor(.accent, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return b
    }

    func makeServiceChip(_ service: CleaningService) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.accent.withAlphaComponent(0.10)
        container.layer.cornerRadius = 12

        let label = UILabel()
        label.text = service.displayName
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .accent

        container.addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        return container
    }

    func makeScheduleRow(day: String, time: String) -> UIView {
        let container = UIView()

        let dayLabel = UILabel()
        dayLabel.text = day
        dayLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dayLabel.textColor = .darkGray

        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .systemGray
        timeLabel.textAlignment = .right

        container.addSubviews([dayLabel, timeLabel])
        dayLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
        container.snp.makeConstraints { $0.height.equalTo(22) }
        return container
    }

    func makeReviewView(_ review: UserDetailReviewItem) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1.0)
        container.layer.cornerRadius = 12

        // Initials avatar
        let initials = String(review.reviewerName.prefix(1))
        let avatarView = UIView()
        avatarView.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        avatarView.layer.cornerRadius = 20

        let initialsLabel = UILabel()
        initialsLabel.text = initials
        initialsLabel.font = .systemFont(ofSize: 16, weight: .bold)
        initialsLabel.textColor = .accent
        initialsLabel.textAlignment = .center
        avatarView.addSubview(initialsLabel)
        initialsLabel.snp.makeConstraints { $0.edges.equalToSuperview() }

        let nameLabel = UILabel()
        nameLabel.text = review.reviewerName
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .black

        let starsView = makeStarsView(rating: review.rating)

        let commentLabel = UILabel()
        commentLabel.text = review.comment
        commentLabel.font = .systemFont(ofSize: 13, weight: .regular)
        commentLabel.textColor = .darkGray
        commentLabel.numberOfLines = 0

        container.addSubviews([avatarView, nameLabel, starsView, commentLabel])

        avatarView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.width.height.equalTo(40)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarView.snp.top).offset(2)
            $0.leading.equalTo(avatarView.snp.trailing).offset(10)
        }

        starsView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(avatarView.snp.trailing).offset(10)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(avatarView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }

        return container
    }

    func makeStarsView(rating: Int) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        for i in 1...5 {
            let iv = UIImageView()
            iv.image = UIImage(systemName: i <= rating ? "star.fill" : "star")
            iv.tintColor = UIColor(red: 1.0, green: 0.75, blue: 0.0, alpha: 1.0)
            iv.contentMode = .scaleAspectFit
            iv.snp.makeConstraints { $0.width.height.equalTo(13) }
            stack.addArrangedSubview(iv)
        }
        return stack
    }
}

// MARK: - UserDetailViewProtocol

extension UserDetailViewController: UserDetailViewProtocol {
    func displayDetail(_ item: UserDetailItem, reviews: [UserDetailReviewItem]) {
        nameLabel.text = item.fullName
        ratingLabel.text = String(format: "%.1f", item.rating)
        reviewCountLabel.text = "(\(item.totalReviews) Yorum)"
        hourlyRateLabel.text = "₺\(Int(item.hourlyRate))"
        biographyLabel.text = item.biography
        verifiedBadge.isHidden = !item.isVerified

        // Services
        item.services.forEach { service in
            servicesStackView.addArrangedSubview(makeServiceChip(service))
        }

        // Schedule
        let sorted = item.schedule.sorted { $0.key < $1.key }
        sorted.forEach { day, time in
            scheduleStackView.addArrangedSubview(makeScheduleRow(day: day, time: time))
        }
        if item.schedule.isEmpty {
            let noInfo = UILabel()
            noInfo.text = "Çalışma saati bilgisi eklenmemiş."
            noInfo.font = .systemFont(ofSize: 14)
            noInfo.textColor = .systemGray
            scheduleStackView.addArrangedSubview(noInfo)
        }

        // Reviews
        reviews.forEach { review in
            reviewsStackView.addArrangedSubview(makeReviewView(review))
        }
    }

    func appendReviews(_ reviews: [UserDetailReviewItem]) {
        reviews.forEach { review in
            reviewsStackView.addArrangedSubview(makeReviewView(review))
        }
    }

    func updateFavoriteButton(isFavorited: Bool) {
        let iconName = isFavorited ? "heart.fill" : "heart"
        let tint: UIColor = isFavorited ? .systemRed : UIColor(red: 0.25, green: 0.27, blue: 0.32, alpha: 1.0)
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
        favoriteButton.tintColor = tint
    }

    func showLoading() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func hideLoading() {
        loadingView.removeFromSuperview()
    }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(
            with: AlertModel(title: alertModel.title, message: alertModel.message),
            from: self
        )
    }
}

#Preview {
    UINavigationController(rootViewController: UserDetailViewController())
}
