//
//  RetrieveCategoryStatisticsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/20/17.
//

import XCTest
@testable import SendGrid

class RetrieveCategoryStatisticsTests: XCTestCase {
    
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }
    
    func testMinimalInitialization() {
        let request = RetrieveCategoryStatistics(startDate: date(day: 20), categories: "Foo")
        XCTAssertEqual(request.description, "")
    }
    
    func testMaxInitialization() {
        let request = RetrieveCategoryStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, categories: "Foo", "Bar")
        XCTAssertEqual(request.description, "")
    }
    
    func testValidation() {
        let good = RetrieveCategoryStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, categories: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
        XCTAssertNoThrow(try good.validate())
        
        do {
            let under = RetrieveCategoryStatistics(startDate: date(day: 20), categories: [])
            try under.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfCategories {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let over = RetrieveCategoryStatistics(startDate: date(day: 20), categories: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven")
            try over.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfCategories {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let request = RetrieveCategoryStatistics(startDate: date(day: 20), endDate: date(day: 19))
            try request.validate()
            XCTFail("Expected a failure to be thrown when the end date is before the start date, but nothing was thrown.")
        } catch SendGrid.Exception.Statistic.invalidEndDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}