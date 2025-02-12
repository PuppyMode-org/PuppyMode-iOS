//
//  AppointmentResponse.swift
//  PuppyMode
//
//  Created by 박준석 on 1/31/25.
//

import Foundation

struct StartAppointmentResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: AppointmentResult?
}

struct AppointmentResult: Codable {
    let appointmentId: Int
    let address: String
    let locationName: String
    let appointmentStatus: String
    let isDrinking: Bool
    let startTime: String
}

struct EndAppointmentResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EndAppointmentResult?
}

struct EndAppointmentResult: Codable {
    let completedTime: String
    let appointmentStatus: String
}

struct GetAppointmentsResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: AppointmentsResult?
}

struct AppointmentsResult: Codable {
    let totalCount: Int
    let appointments: [Appointment]
}

struct Appointment: Codable {
    let appointmentId: Int
    let dateTime: String // 날짜 및 시간 (ISO8601 형식)
    let address: String
    let status: String   // scheduled, completed 등 상태 값
}

struct GetAppointmentStatusResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: GetAppointmentStatusResult?
}

struct GetAppointmentStatusResult: Codable {
    let appointmentId: Int
    let address: String
    let locationName: String
    let appointmentStatus: String
    let isDrinking: Bool
    let startTime: String
}

struct CheckDrinkingStatusResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DrinkingStatusResult?
}

struct DrinkingStatusResult: Codable {
    let appointmentId: Int
    let isDrinking: Bool
    let appointmentStatus: String
    let puppyName: String
    let drinkingHours: Int
}

struct RescheduleAppointmentResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RescheduleResult?
}

struct RescheduleResult: Codable {
    let appointmentId: Int
    let rescheduledTime: String
    let message: String
}

struct CreateAppointmentResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CreateAppointmentResult?
}

struct CreateAppointmentResult: Codable {
    let appointmentId: Int
    let dateTime: String
    let address: String
    let status: String
}

extension String {
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
}

// MARK: DrinkCapacity

struct DrinkCapacityResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DrinkCapacityResult?
}

struct DrinkCapacityResult: Decodable {
    let drinkItemId: Int
    let drinkItemName: String
    let imageUrl: String?
    let alcoholPercentage: Int
    let safetyValue: Int
    let maxValue: Int
}
