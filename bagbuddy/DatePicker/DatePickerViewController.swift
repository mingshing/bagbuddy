//
//  DatePickerViewController.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/17.
//

import Foundation
import HorizonCalendar
import SnapKit
import UIKit

protocol DatePickedDelegate: AnyObject {
    
    func didSelectedDate(selectedDate: DayRange)
}


class DatePickerViewController: UIViewController {

    // MARK: View
    private lazy var calendarView = CalendarView(initialContent: makeContent())
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton : UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()
    
    // MARK: Property
    let calendar = Calendar.current
    private var selectedDayRange: DayRange?
    private var selectedDayRangeAtStartOfDrag: DayRange?
    var delegate: DatePickedDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHandler()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(calendarView)
        view.addSubview(closeButton)
        view.addSubview(confirmButton)
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(LayoutConstants.actionButtonHeight)
            make.left.equalToSuperview().inset(4)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstants.actionButtonHeight)
            make.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.top.equalTo(closeButton.snp.top)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(LayoutConstants.pageHorizontalMargin)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func didTapClose(sender: UIButton!) {
        dismiss(animated: true)
    }
    
    @objc func didTapConfirm(sender: UIButton!) {
        if let selectedRange = selectedDayRange {
            delegate?.didSelectedDate(selectedDate: selectedRange)
        }
        dismiss(animated: true)
    }
}


// Date content setup function
extension DatePickerViewController {
    
    func makeContent() -> CalendarViewContent {
        let dayDateFormatter: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.calendar = calendar
          dateFormatter.locale = calendar.locale
          dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "EEEE, MMM d, yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)
          return dateFormatter
        }()
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        if let year = dateComponents.year,
           let month = dateComponents.month,
           let day = dateComponents.day,
           let startDate = calendar.date(from: DateComponents(year: year, month: month, day: day)),
           let endDate = calendar.date(from: DateComponents(year: year + 1, month: month, day: day)) {
            
            let dateRanges: Set<ClosedRange<Date>>
            let selectedDayRange = selectedDayRange
            if let selectedDayRange,
               let lowerBound = calendar.date(from: selectedDayRange.lowerBound.components),
               let upperBound = calendar.date(from: selectedDayRange.upperBound.components) {
                dateRanges = [lowerBound...upperBound]
            } else {
                dateRanges = []
            }
            
            return CalendarViewContent(
                calendar: calendar,
                visibleDateRange: startDate...endDate,
                monthsLayout: .vertical
            )
            .interMonthSpacing(24)
            .verticalDayMargin(8)
            .horizontalDayMargin(8)
            .dayItemProvider { [calendar, dayDateFormatter] day in
                var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
                
                let isSelectedStyle: Bool
                if let selectedDayRange {
                    isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
                } else {
                    isSelectedStyle = false
                }
                
                if isSelectedStyle {
                    invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .systemBackground
                    invariantViewProperties.backgroundShapeDrawingConfig.borderColor = UIColor(.accentColor)
                }
                
                let date = calendar.date(from: day.components)
                
                return DayView.calendarItemModel(
                    invariantViewProperties: invariantViewProperties,
                    content: .init(
                        dayText: "\(day.day)",
                        accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                        accessibilityHint: nil
                    )
                )
            }
            .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
                DayRangeIndicatorView.calendarItemModel(
                    invariantViewProperties: .init(),
                    content: .init(
                        framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }
                    )
                )
            }
        }
        let startDate = calendar.date(from: DateComponents(year: 2023, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        return CalendarViewContent (
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical
        )
    }
    
    func setupHandler() {
        
        calendarView.daySelectionHandler = { [weak self] day in
          guard let self else { return }

          DayRangeSelectionHelper.updateDayRange(
            afterTapSelectionOf: day,
            existingDayRange: &self.selectedDayRange)

          self.calendarView.setContent(self.makeContent())
        }

        calendarView.multipleDaySelectionDragHandler = { [weak self, calendar] day, state in
          guard let self else { return }

          DayRangeSelectionHelper.updateDayRange(
            afterDragSelectionOf: day,
            existingDayRange: &self.selectedDayRange,
            initialDayRange: &self.selectedDayRangeAtStartOfDrag,
            state: state,
            calendar: calendar)

          self.calendarView.setContent(self.makeContent())
        }
    }
}
