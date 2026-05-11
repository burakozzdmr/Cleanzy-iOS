//
//  TimeSlotSelectorView.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class TimeSlotSelectorView: UIView {

    // MARK: - Public

    var onTimeSelected: ((String) -> Void)?

    private(set) var selectedTime: String?

    // MARK: - Config

    private let timeSlots = [
        "09:00", "10:00", "11:00", "12:00",
        "13:00", "14:00", "15:00", "16:00", "17:00"
    ]

    private var slotButtons: [UIButton] = []
    private var selectedIndex: Int = 2 // 11:00 default

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center
        return sv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private Setup

private extension TimeSlotSelectorView {
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide)
        }

        timeSlots.enumerated().forEach { index, time in
            let btn = makeSlotButton(time: time, index: index)
            slotButtons.append(btn)
            stackView.addArrangedSubview(btn)
        }

        applySelection(index: selectedIndex)
        selectedTime = timeSlots[selectedIndex]
    }

    func makeSlotButton(time: String, index: Int) -> UIButton {
        let btn = UIButton()
        btn.setTitle(time, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.layer.cornerRadius = 12
        btn.tag = index
        btn.addTarget(self, action: #selector(slotTapped(_:)), for: .touchUpInside)
        btn.snp.makeConstraints { $0.width.equalTo(80) }
        return btn
    }

    func applySelection(index: Int) {
        slotButtons.enumerated().forEach { i, btn in
            if i == index {
                btn.backgroundColor = .accent
                btn.setTitleColor(.white, for: .normal)
            } else {
                btn.backgroundColor = UIColor.systemGray6
                btn.setTitleColor(.black, for: .normal)
            }
        }
    }
}

// MARK: - Actions

@objc private extension TimeSlotSelectorView {
    func slotTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        selectedTime = timeSlots[sender.tag]
        applySelection(index: sender.tag)
        onTimeSelected?(timeSlots[sender.tag])
    }
}
