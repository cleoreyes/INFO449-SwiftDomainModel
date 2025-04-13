import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }

    // Extra credit
    func testConvertHourlyToSalary() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssertEqual(job.calculateIncome(10), 150)

        job.convert()
        if case .Salary(let salary) = job.type {
            XCTAssertEqual(salary, 30000)
        } else {
            XCTFail("Job type should be Salary after conversion")
        }

        XCTAssertEqual(job.calculateIncome(10), 30000)
    }

    func testHourlyJobNegativeHours() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssertEqual(job.calculateIncome(0), 0)
    }

    func testSalaryJobNegativeHours() {
        let job = Job(title: "Manager", type: Job.JobType.Salary(50000))
        XCTAssertEqual(job.calculateIncome(0), 50000)
    }

    func testRaiseHourlyJobByNegativeAmount() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        job.raise(byAmount: -5.0)
        XCTAssertEqual(job.calculateIncome(10), 100)
    }

    func testRaiseSalaryJobByNegativeAmount() {
        let job = Job(title: "Manager", type: Job.JobType.Salary(50000))
        job.raise(byAmount: -10000)
        XCTAssertEqual(job.calculateIncome(10), 40000)
    }

    func testRaiseHourlyJobByZeroPercent() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        job.raise(byPercent: 0.0)
        XCTAssertEqual(job.calculateIncome(10), 150)
    }

    func testRaiseSalaryJobByZeroPercent() {
        let job = Job(title: "Manager", type: Job.JobType.Salary(50000))
        job.raise(byPercent: 0.0)
        XCTAssertEqual(job.calculateIncome(10), 50000)
    }

    func testConvertHourlyJobWithHighRate() {
        let job = Job(title: "Consultant", type: Job.JobType.Hourly(100.0))
        job.convert()
        if case .Salary(let salary) = job.type {
            XCTAssertEqual(salary, 200000)
        } else {
            XCTFail("Job type should be Salary after conversion")
        }
    }

    func testConvertSalaryJobDoesNothing() {
        let job = Job(title: "CEO", type: Job.JobType.Salary(100000))
        job.convert()
        if case .Salary(let salary) = job.type {
            XCTAssertEqual(salary, 100000)
        } else {
            XCTFail("Job type should remain Salary after conversion")
        }
    }
  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        
        ("testConvertHourlyToSalary", testConvertHourlyToSalary),
        ("testHourlyJobNegativeHours", testHourlyJobNegativeHours),
        ("testSalaryJobNegativeHours", testSalaryJobNegativeHours),
        ("testRaiseHourlyJobByNegativeAmount", testRaiseHourlyJobByNegativeAmount),
        ("testRaiseSalaryJobByNegativeAmount", testRaiseSalaryJobByNegativeAmount),
        ("testRaiseHourlyJobByZeroPercent", testRaiseHourlyJobByZeroPercent),
        ("testRaiseSalaryJobByZeroPercent", testRaiseSalaryJobByZeroPercent),
        ("testConvertHourlyJobWithHighRate", testConvertHourlyJobWithHighRate),
        ("testConvertSalaryJobDoesNothing", testConvertSalaryJobDoesNothing)
    ]
}
