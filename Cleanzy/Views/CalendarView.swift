//
//  CalendarView.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import SnapKit
import UIKit

final class CalendarView: UIView {

    // MARK: - Public

    var onDateSelected: ((Date) -> Void)?

    // MARK: - Private State

    private var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2  // Monday
        cal.locale = Locale(identifier: "tr_TR")
        return cal
    }()

    private var displayYear: Int
    private var displayMonth: Int
    private var selectedDay: Int?
    private var selectedDate: Date?

    private let daysOfWeek = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"]

    // MARK: - UI

    private let headerStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()

    private lazy var prevButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        b.tintColor = .black
        b.addTarget(self, action: #selector(prevMonthTapped), for: .touchUpInside)
        return b
    }()

    private lazy var nextButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        b.tintColor = .black
        b.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
        return b
    }()

    private let monthYearLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .black
        return l
    }()

    private let weekdayStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()

    private let gridStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.distribution = .fillEqually
        return sv
    }()

    private var dayButtons: [UIButton] = []

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        dayButtons.forEach { btn in
            let side = min(btn.bounds.width, btn.bounds.height)
            btn.layer.cornerRadius = side / 2
        }
    }

    // MARK: - Init

    init() {
        let now = Date()
        self.displayYear = Calendar.current.component(.year, from: now)
        self.displayMonth = Calendar.current.component(.month, from: now)
        super.init(frame: .zero)
        setupUI()
        reloadCalendar()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private Setup

private extension CalendarView {
    func setupUI() {
        addSubviews([headerStack, weekdayStack, gridStack])

        headerStack.addArrangedSubview(monthYearLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(prevButton)
        headerStack.addArrangedSubview(nextButton)

        daysOfWeek.forEach { day in
            let l = UILabel()
            l.text = day
            l.font = .systemFont(ofSize: 12, weight: .medium)
            l.textColor = .systemGray
            l.textAlignment = .center
            weekdayStack.addArrangedSubview(l)
        }

        for _ in 0..<6 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            for _ in 0..<7 {
                let btn = makeDayButton()
                rowStack.addArrangedSubview(btn)
                dayButtons.append(btn)
            }
            gridStack.addArrangedSubview(rowStack)
        }

        headerStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }

        weekdayStack.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        gridStack.snp.makeConstraints {
            $0.top.equalTo(weekdayStack.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        prevButton.snp.makeConstraints { $0.width.height.equalTo(32) }
        nextButton.snp.makeConstraints { $0.width.height.equalTo(32) }
    }

    func makeDayButton() -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(dayTapped(_:)), for: .touchUpInside)
        return btn
    }

    func reloadCalendar() {
        monthYearLabel.text = formattedMonthYear(month: displayMonth, year: displayYear)

        let daysInCurrent = daysInMonth(displayMonth, year: displayYear)
        let offset = firstWeekdayOffset(displayMonth, year: displayYear)
        let daysInPrev = daysInMonth(displayMonth == 1 ? 12 : displayMonth - 1,
                                     year: displayMonth == 1 ? displayYear - 1 : displayYear)

        let today = calendar.dateComponents([.year, .month, .day], from: Date())

        for (index, btn) in dayButtons.enumerated() {
            let dayNumber: Int
            let isCurrentMonth: Bool

            if index < offset {
                dayNumber = daysInPrev - offset + index + 1
                isCurrentMonth = false
            } else if index < offset + daysInCurrent {
                dayNumber = index - offset + 1
                isCurrentMonth = true
            } else {
                dayNumber = index - offset - daysInCurrent + 1
                isCurrentMonth = false
            }

            btn.setTitle("\(dayNumber)", for: .normal)
            btn.tag = isCurrentMonth ? dayNumber : -1
            btn.isEnabled = isCurrentMonth

            let isToday = isCurrentMonth
                && dayNumber == today.day
                && displayMonth == today.month
                && displayYear == today.year

            let isSelected = isCurrentMonth
                && dayNumber == selectedDay
                && displayMonth == selectedMonthOf(selectedDate)
                && displayYear == selectedYearOf(selectedDate)

            applyStyle(to: btn, isCurrentMonth: isCurrentMonth, isSelected: isSelected, isToday: isToday)
        }
    }

    func applyStyle(to btn: UIButton, isCurrentMonth: Bool, isSelected: Bool, isToday: Bool) {
        if isSelected {
            btn.backgroundColor = .accent
            btn.setTitleColor(.white, for: .normal)
        } else if isToday {
            btn.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
            btn.setTitleColor(.accent, for: .normal)
        } else {
            btn.backgroundColor = .clear
            btn.setTitleColor(isCurrentMonth ? .black : UIColor.systemGray3, for: .normal)
        }
    }

    // MARK: - Calendar Math

    func daysInMonth(_ month: Int, year: Int) -> Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        let date = calendar.date(from: comps)!
        return calendar.range(of: .day, in: .month, for: date)!.count
    }

    func firstWeekdayOffset(_ month: Int, year: Int) -> Int {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        let date = calendar.date(from: comps)!
        let weekday = calendar.component(.weekday, from: date)
        // Convert to Monday-first index: Mon=0, Tue=1, ... Sun=6
        return (weekday + 5) % 7
    }

    func formattedMonthYear(month: Int, year: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "LLLL yyyy"
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        let date = calendar.date(from: comps) ?? Date()
        return formatter.string(from: date).capitalized
    }

    func selectedMonthOf(_ date: Date?) -> Int {
        guard let date else { return -1 }
        return calendar.component(.month, from: date)
    }

    func selectedYearOf(_ date: Date?) -> Int {
        guard let date else { return -1 }
        return calendar.component(.year, from: date)
    }
}

// MARK: - Actions

@objc private extension CalendarView {
    func prevMonthTapped() {
        displayMonth -= 1
        if displayMonth < 1 { displayMonth = 12; displayYear -= 1 }
        reloadCalendar()
    }

    func nextMonthTapped() {
        displayMonth += 1
        if displayMonth > 12 { displayMonth = 1; displayYear += 1 }
        reloadCalendar()
    }

    func dayTapped(_ sender: UIButton) {
        guard sender.tag > 0 else { return }
        selectedDay = sender.tag
        var comps = DateComponents()
        comps.year = displayYear
        comps.month = displayMonth
        comps.day = sender.tag
        if let date = calendar.date(from: comps) {
            selectedDate = date
            onDateSelected?(date)
        }
        reloadCalendar()
    }
}
