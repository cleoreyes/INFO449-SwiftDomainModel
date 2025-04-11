struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Double
    var currency: String

    init(amount: Double, currency: String) {
        self.amount = amount
        self.currency = currency
    }

    let currencies = ["USD", "GBP", "EUR", "CAN"]

    func isValidCurrency(_ currency: String) -> Bool {
        return currencies.contains(currency)
    }

    func convert(_ newCurrency: String) -> Money {
        let toUSD: [String: Double] = [
            "USD": 1.0,
            "GBP": 2.0,
            "EUR": 2.0 / 3.0,
            "CAN": 0.8
        ]

        let fromUSD: [String: Double] = [
            "USD": 1.0,
            "GBP": 0.5,
            "EUR": 1.5,
            "CAN": 1.25
        ]

        guard let usdRate = toUSD[currency],
              let targetRate = fromUSD[newCurrency] else {
            fatalError("Unsupported currency")
        }

        let amountInUSD: Double = amount * usdRate
        let convertedAmount = amountInUSD * targetRate

        return Money(amount: convertedAmount, currency: newCurrency)
    }

    func add(_ other: Money) -> Money {
        if currencies.contains(other.currency) {
            let converted = self.convert(other.currency)
            return Money(amount: converted.amount + other.amount, currency: other.currency)
        } else {
            fatalError("Unsupported currency")
        }
    }

    func subtract(_ other: Money) -> Money {
        if currencies.contains(other.currency) {
            let convertedOther = other.convert(currency)
            return Money(amount: amount - convertedOther.amount, currency: currency)
        } else {
            fatalError("Unsupported currency")
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }

    var title: String
    var type: JobType

    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    func calculateIncome(_ hours: UInt) -> UInt {
        switch type {
        case .Hourly(let rate):
            return UInt(rate * Double(hours))
        case .Salary(let salary):
            return salary
        }
    }

    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate * (1 + byPercent))
        case .Salary(let salary):
            type = .Salary(UInt(Double(salary) * (1 + byPercent)))
        }
    }

    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate + byAmount)
        case .Salary(let salary):
            type = .Salary(UInt(Double(salary) + byAmount))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    private var _job: Job?
    var job: Job? {
        get {
            return _job
        }
        set {
            if age >= 18 {
                _job = newValue
            } else {
                print("Cannot assign job. \(firstName) is too young.")
                _job = nil
            }
        }
    }
    private var _spouse: Person?
    var spouse: Person? {
        get {
            return _spouse
        }
        set {
            if age >= 18 {
                _spouse = newValue
            } else {
                print("Cannot assign spouse. \(firstName) is too young.")
                _spouse = nil
            }
        }
    }

    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    func toString() -> String {
        let jobDescription = job != nil ? "\(job!)" : "nil"
        let spouseDescription = spouse != nil ? "\(spouse!.firstName) \(spouse!.lastName)" : "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobDescription) spouse:\(spouseDescription)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]

    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil  {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members = [spouse1, spouse2]
        } else {
            self.members = []
        }
    }

    func haveChild(_ child: Person) -> Bool {
        guard members[0].age >= 18 && members[1].age >= 18 else {
            return false
        }

        members.append(child)
        return true
    }

    func householdIncome() -> UInt {
        var totalIncome: UInt = 0
        for member in members {
            if let job = member.job {
                totalIncome += job.calculateIncome(2000)
            }
        }
        return totalIncome
    }
}
