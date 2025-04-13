import XCTest
@testable import DomainModel

class PersonTests: XCTestCase {

    func testPerson() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
    }

    func testAgeRestrictions() {
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)

        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)

        matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(matt.spouse == nil)
    }

    func testAdultAgeRestrictions() {
        let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)

        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(mike.job != nil)

        mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
        XCTAssert(mike.spouse != nil)
    }

    // Extra credit
    func testSingleName() {
        let ted = Person(firstName: "Ted", lastName: nil, age: 45)
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:nil age:45 job:nil spouse:nil]")
    }

    func testPersonWithoutJobOrSpouse() {
        let jane = Person(firstName: "Jane", lastName: "Doe", age: 30)
        XCTAssert(jane.toString() == "[Person: firstName:Jane lastName:Doe age:30 job:nil spouse:nil]")
    }

    func testPersonWithJobOnly() {
        let john = Person(firstName: "John", lastName: "Smith", age: 40)
        john.job = Job(title: "Engineer", type: Job.JobType.Salary(80000))
        XCTAssert(john.toString() == "[Person: firstName:John lastName:Smith age:40 job:Engineer spouse:nil]")
    }

    func testPersonWithSpouseOnly() {
        let alice = Person(firstName: "Alice", lastName: "Brown", age: 35)
        alice.spouse = Person(firstName: "Bob", lastName: "Brown", age: 36)
        XCTAssert(alice.toString() == "[Person: firstName:Alice lastName:Brown age:35 job:nil spouse:Bob Brown]")
    }

    func testPersonWithJobAndSpouse() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Software Engineer", type: Job.JobType.Salary(120000))
        ted.spouse = Person(firstName: "Charlotte", lastName: "Neward", age: 45)
        print(ted.toString())
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:Software Engineer spouse:Charlotte Neward]")
    }

    func testPersonWithEmptyLastName() {
        let sam = Person(firstName: "Sam", lastName: "", age: 28)
        XCTAssert(sam.toString() == "[Person: firstName:Sam lastName: age:28 job:nil spouse:nil]")
    }

    func testPersonWithNilSpouse() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Software Engineer", type: Job.JobType.Salary(120000))
        ted.spouse = nil
        XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:Software Engineer spouse:nil]")
    }

    func testPersonWithJobAndNoLastName() {
        let alex = Person(firstName: "Alex", lastName: nil, age: 30)
        alex.job = Job(title: "Designer", type: Job.JobType.Salary(70000))
        XCTAssert(alex.toString() == "[Person: firstName:Alex lastName:nil age:30 job:Designer spouse:nil]")
    }

    func testPersonWithSpouseAndNoJob() {
        let emily = Person(firstName: "Emily", lastName: "Clark", age: 40)
        emily.spouse = Person(firstName: "James", lastName: "Clark", age: 42)
        XCTAssert(emily.toString() == "[Person: firstName:Emily lastName:Clark age:40 job:nil spouse:James Clark]")
    }

    static var allTests = [
        ("testPerson", testPerson),
        ("testAgeRestrictions", testAgeRestrictions),
        ("testAdultAgeRestrictions", testAdultAgeRestrictions),
        
        ("testSingleName", testSingleName),
        ("testPersonWithoutJobOrSpouse", testPersonWithoutJobOrSpouse),
        ("testPersonWithJobOnly", testPersonWithJobOnly),
        ("testPersonWithSpouseOnly", testPersonWithSpouseOnly),
        ("testPersonWithJobAndSpouse", testPersonWithJobAndSpouse),
        ("testPersonWithEmptyLastName", testPersonWithEmptyLastName),
        ("testPersonWithNilSpouse", testPersonWithNilSpouse),
        ("testPersonWithJobAndNoLastName", testPersonWithJobAndNoLastName),
        ("testPersonWithSpouseAndNoJob", testPersonWithSpouseAndNoJob),
    ]
}

class FamilyTests : XCTestCase {
  
    func testFamily() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 1000)
    }

    func testFamilyWithKids() {
        let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
        ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))

        let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)

        let family = Family(spouse1: ted, spouse2: charlotte)

        let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
        mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))

        let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
        let _ = family.haveChild(mike)
        let _ = family.haveChild(matt)

        let familyIncome = family.householdIncome()
        XCTAssert(familyIncome == 12000)
    }
  
    static var allTests = [
        ("testFamily", testFamily),
        ("testFamilyWithKids", testFamilyWithKids),
    ]
}
