import Vapor

/// Controls basic CRUD operations on `PayslipController`s.
final public class PayslipController {
    public init() {}
    
    public func calculate(_ req: Request) throws -> Future<Payslip> {
        return try req.content.decode(Shifts.self).map(to: Payslip.self, { shifts -> Payslip in
            return try Payslip(shifts)
        })
    }
}
