import App
import XCTest

let json = """
{
"employee": {
"name": "R2-D2",
"age": "adult",
"casual": true
},
"wageLevels": {
"1": "12.34",
"3": "14.12"
},
"shifts": [
{
"start": "2019-06-27T12:00:00",
"end": "2019-06-27T23:15:00",
"wageLevel": "1",
"breakStart": "2019-06-27T17:30:00",
"breakDurationMinutes": "45"
},
{
"start": "2019-06-28T12:00:00",
"end": "2019-06-28T16:15:00",
"wageLevel": "1"
},
{
"start": "2019-06-29T11:00:00",
"end": "2019-06-29T18:30:00",
"wageLevel": "1"
},
{
"start": "2019-06-30T12:00:00",
"end": "2019-06-30T21:15:00",
"wageLevel": "1",
"breakStart": "2019-06-30T14:30:00",
"breakDurationMinutes": "30"
}
]
}
"""

final class AppTests: XCTestCase {
    func testNothing() throws {
        // Add your tests here
        XCTAssert(true)
    }
    
    func testWeekdayOperators() {
        XCTAssert(1 == WeekDay.sunday)
        XCTAssert(Optional(1) == WeekDay.sunday)
        XCTAssertFalse(2 == WeekDay.sunday)
        XCTAssertFalse(Optional(2) == WeekDay.sunday)
        XCTAssertFalse(nil == WeekDay.sunday)
        XCTAssert(2 != WeekDay.sunday)
        XCTAssert(Optional(2) != WeekDay.sunday)
        XCTAssertFalse(1 != WeekDay.sunday)
        XCTAssertFalse(Optional(1) != WeekDay.sunday)
        XCTAssert(nil != WeekDay.sunday)
    }
    
    func testPayslip() {
        do {
            let modelOutput = try JSONDecoder().decode(Shifts.self, from: json.data(using: .utf8)!)
            let payslip = try Payslip(modelOutput)
            XCTAssertNotNil(payslip)
            XCTAssert(payslip.totalWorkHours == 25.75)
            XCTAssert(payslip.eveningWorkHours == 5.25)
            XCTAssert(payslip.overtimeWorkHours == 0)
            XCTAssertEqual(payslip.totalEarnings, 382.5, accuracy: 0.5)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }
    
    func testDateConversion() {
        XCTAssert("2019-06-29T11:00:00".date()?.toString() == "2019-06-29T11:00:00")
        XCTAssert("2019-06-29T18:30:00".date()?.toString() == "2019-06-29T18:30:00")
        XCTAssert("2019-06-27T23:15:00".date()?.toString() == "2019-06-27T23:15:00")
        XCTAssert("2019-06-30T14:30:00".date()?.toString() == "2019-06-30T14:30:00")
        XCTAssert("2019-06-27T12:00:00".date()?.toString() == "2019-06-27T12:00:00")
    }
    
    func testTimeInterval() {
        XCTAssert(Date.interval(from: "2019-06-29T11:00:00".date()!, to: "2019-06-29T11:00:00".date()!, in: .minute) == 0)
        XCTAssert(Date.interval(from: "2019-06-29T11:00:00".date()!, to: "2019-06-29T11:30:00".date()!, in: .minute) == 30)
        XCTAssert(Date.interval(from: "2019-06-29T11:00:00".date()!, to: "2019-06-29T11:10:00".date()!, in: .minute) == 10)
        XCTAssert(Date.interval(from: "2019-06-28T11:00:00".date()!, to: "2019-06-29T11:00:00".date()!, in: .minute) == 1440)
        XCTAssert(Date.interval(from: "2019-06-29T11:30:00".date()!, to: "2019-06-29T12:00:00".date()!, in: .minute) == 30)
    }
    
    func testAddInterval() {
        XCTAssert("2019-06-29T11:00:00".date()?.add(interval: 30, in: .minute)?.toString() == "2019-06-29T11:30:00")
        XCTAssert("2019-06-29T11:00:00".date()?.add(interval: 15, in: .minute)?.toString() == "2019-06-29T11:15:00")
        XCTAssert("2019-06-29T11:00:00".date()?.add(interval: 1, in: .hour)?.toString() == "2019-06-29T12:00:00")
        XCTAssert("2019-06-29T11:00:00".date()?.add(interval: 1, in: .second)?.toString() == "2019-06-29T11:00:01")
        XCTAssert("2019-06-29T11:00:00".date()?.add(interval: -1, in: .day)?.toString() == "2019-06-28T11:00:00")
    }
    
    func testWeekday() {
        XCTAssert("2019-06-24T11:00:00".date()?.weekDay() == WeekDay.monday.rawValue)
        XCTAssert("2019-06-25T11:00:00".date()?.weekDay() == WeekDay.tuesday.rawValue)
        XCTAssert("2019-06-26T11:00:00".date()?.weekDay() == WeekDay.wednesday.rawValue)
        XCTAssert("2019-06-27T11:00:00".date()?.weekDay() == WeekDay.thursday.rawValue)
        XCTAssert("2019-06-28T11:00:00".date()?.weekDay() == WeekDay.friday.rawValue)
        XCTAssert("2019-06-29T11:00:00".date()?.weekDay() == WeekDay.saturday.rawValue)
        XCTAssert("2019-06-30T11:00:00".date()?.weekDay() == WeekDay.sunday.rawValue)
    }
    
    func testSetTo6PM() {
        XCTAssert("2019-06-29T11:00:00".date()?.setTo6PM()?.toString() == "2019-06-29T18:00:00")
    }
    
    func testExampleInput() {
        do {
            let modelOutput = try JSONDecoder().decode(Shifts.self, from: json.data(using: .utf8)!)
            XCTAssert(modelOutput.employee.age == "adult")
            XCTAssert(modelOutput.employee.name == "R2-D2")
            XCTAssert(modelOutput.employee.casual)
            XCTAssert(modelOutput.wageLevels.levels.keys.count == 2)
            XCTAssert(modelOutput.wageLevels.levels["1"] == 12.34)
            XCTAssert(modelOutput.wageLevels.levels["3"] == 14.12)
            XCTAssert(modelOutput.shifts.count == 4)
            XCTAssert(modelOutput.shifts.first?.wageLevel == "1")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }
    
    func testStringInitializable() {
        struct Model: Decodable {
            let value: Int?
            let secondValue: Int
            let thirdValue: Int
            let fourthValue: Int?
            
            enum CodingKeys: String, CodingKey {
                case value
                case secondValue
                case thirdValue
                case fourthValue
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                value = try container.decodeUnstable(forKey: .value)
                secondValue = try container.decodeUnstable(forKey: .secondValue)
                thirdValue = try container.decodeUnstable(forKey: .thirdValue)
                fourthValue = try container.decodeUnstable(forKey: .fourthValue)
            }
        }
        
        let json = """
        {
            "value": "123",
            "secondValue": "434234434",
            "thirdValue": 777,
            "fourthValue": 2
        }
        """.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            let test = try decoder.decode(Model.self, from: json)
            print(test)
            XCTAssert(test.value == 123, "value:\(String(describing: test.value)) is wrong")
            XCTAssert(test.secondValue == 434234434, "value:\(test.secondValue) is wrong")
            XCTAssert(test.thirdValue == 777, "value:\(test.thirdValue) is wrong")
            XCTAssert(test.fourthValue == 2, "value:\(String(describing: test.fourthValue)) is wrong")
        } catch {
            print(error)
            XCTFail()
        }
    }

    static let allTests = [
        ("testPayslip", testPayslip),
        ("testAddInterval", testAddInterval),
        ("testWeekday", testWeekday),
        ("testSetTo6PM", testSetTo6PM),
        ("testDateConversion", testDateConversion),
        ("testTimeInterval", testTimeInterval),
        ("testDateConversion", testDateConversion),
        ("testExampleInput", testExampleInput),
        ("testStringInitializable", testStringInitializable),
    ]
}
