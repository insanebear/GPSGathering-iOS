//
//  TimeStringConverter.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(in timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul")!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = timeZone

        return dateFormatter.string(from: self)
    }
}
