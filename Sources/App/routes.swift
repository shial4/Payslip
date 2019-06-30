import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Example of configuring a controller
    let payslipController = PayslipController()
    //Remember to include header in your post request
    //Content-Type application/json
    router.post("payslip", use: payslipController.calculate)
}
