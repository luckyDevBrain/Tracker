//
//  WeekDay.swift
//  Tracker
//
//  Created by Kirill on 15.10.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case sun = 1, mon, tue, wed, thu, fri, sat

    static var allWeekdays: [WeekDay] {
            let firstDay = Calendar.current.firstWeekday
            return (firstDay...7).compactMap{ WeekDay(rawValue: $0) }
                 + (1..<firstDay).compactMap{ WeekDay(rawValue: $0) }
        }

        static let shortWeekdayText: [WeekDay: String] = [
            .sun: "Вс",
            .mon: "Пн",
            .tue: "Вт",
            .wed: "Ср",
            .thu: "Чт",
            .fri: "Пт",
            .sat: "Сб",
        ]

        static let longWeekdayText: [WeekDay: String] = [
            .sun: "Воскресенье",
            .mon: "Понедельник",
            .tue: "Вторник",
            .wed: "Среда",
            .thu: "Четверг",
            .fri: "Пятница",
            .sat: "Суббота",
        ]

        static func getDescription(for schedule: [WeekDay]) -> String {
            let description = schedule.compactMap{ WeekDay.shortWeekdayText[$0] }.joined(separator: ", ")
            return description
        }

        static func getWeekDays(from string: String) -> [WeekDay] {
            let invertedShortWD = Dictionary(
                    uniqueKeysWithValues: shortWeekdayText.map { ($0.value.lowercased(), $0.key) }
            )
            return string.split(separator: ",").compactMap{
                let normalizedWeekDay = $0.trimmingCharacters(in: .whitespaces).lowercased()
                return invertedShortWD[normalizedWeekDay]
            }
        }
    }
