//
//  GuardManualTest.swift
//  GuardTests
//
//  Created by JnMars on 2022/8/5.
//

@testable import Guard
import XCTest

class GuardManualTest: XCTestCase {
    var TIMEOUT = 30.0
    var account: String = "ci"
    var password: String = "111111"
    var emailAddress: String = "test@authing.com"
    var emailCode: String = ""
    var phone: String = "15100000000"
    var phoneCode: String = ""

    // MARK: - --------- Verification code scene ----------

    func testRegisterByEmailCode() {
        let expectation = XCTestExpectation(description: "registerByEmailCode")

        AuthClient().registerByEmailCode(email: emailAddress, code: emailCode) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().getCurrentUser { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testRegisterByPhoneCodeFail() {
        let expectation = XCTestExpectation(description: "registerByPhoneCodeFail")

        AuthClient().registerByPhoneCode(phone: phone, code: phoneCode) { code, _, _ in
            XCTAssert(code == 2001)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginByEmailCode() {
        let expectation = XCTestExpectation(description: "loginByEmailCode")

        AuthClient().loginByEmail(email: emailAddress, code: emailCode) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().getCurrentUser { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testBindEmail() {
        let expectation = XCTestExpectation(description: "bindEmail")

        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().bindEmail(email: self.emailAddress, code: self.emailCode) { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testRegisterByPhoneCode() {
        let expectation = XCTestExpectation(description: "registerByPhoneCode")

        AuthClient().registerByPhoneCode(phone: phone, code: phoneCode) { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginByPhoneCode() {
        let expectation = XCTestExpectation(description: "loginByPhoneCode")

        AuthClient().loginByPhoneCode(phone: phone, code: phoneCode) { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testBindPhone() {
        let expectation = XCTestExpectation(description: "bindPhone")

        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().bindPhone(phone: self.phone, code: self.phoneCode) { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    // MARK: - --------- Social ----------

    func testLoginByWechat() {
        let expectation = XCTestExpectation(description: "loginByWechat")
        AuthClient().loginByWechat("code") { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginByWeCom() {
        let expectation = XCTestExpectation(description: "loginByWeCom")
        AuthClient().loginByWeCom("code") { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginbyWeComAgency() {
        let expectation = XCTestExpectation(description: "loginbyWeComAgency")
        AuthClient().loginbyWeComAgency("code") { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginByLark() {
        let expectation = XCTestExpectation(description: "loginByLark")
        AuthClient().loginByLark("code") { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginByApple() {
        let expectation = XCTestExpectation(description: "loginByApple")
        AuthClient().loginByApple("code") { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    // MARK: - --------- MFA ----------

    func testMfaCheck() {
        let expectation = XCTestExpectation(description: "mfaCheck")
        AuthClient().mfaCheck(phone: phone, email: emailAddress) { code, _, _ in
            XCTAssert(code == 2021)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testMfaCheck2() {
        let expectation = XCTestExpectation(description: "mfaCheck2")
        AuthClient().mfaCheck(phone: phone, email: emailAddress) { code, _, _ in
            XCTAssert(code == 2021)
            AuthClient().loginByAccount(account: self.account, password: self.password) { code, _, _ in
                XCTAssert(code == 200)
                AuthClient().mfaCheck(phone: self.phone, email: self.emailAddress) { code, _, _ in
                    XCTAssert(code == 2021)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testMfaVerifyByPhone() {
        let expectation = XCTestExpectation(description: "mfaVerifyByPhone")
        AuthClient().mfaVerifyByPhone(phone: phone, code: emailAddress) { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testMfaVerifyByPhone2() {
        let expectation = XCTestExpectation(description: "mfaVerifyByPhone2")
        AuthClient().mfaVerifyByPhone(phone: phone, code: emailAddress) { code, _, _ in
            XCTAssert(code == 2021)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testMfaVerifyByEmail() {
        let expectation = XCTestExpectation(description: "mfaVerifyByEmail")
        AuthClient().mfaVerifyByEmail(email: phone, code: emailAddress) { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testMfaVerifyByEmail2() {
        let expectation = XCTestExpectation(description: "mfaVerifyByEmail2")
        AuthClient().mfaVerifyByEmail(email: phone, code: emailAddress) { code, _, _ in
            XCTAssert(code == 2021)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testMfaVerifyByOTP() {
        let expectation = XCTestExpectation(description: "mfaVerifyByOTP")
        AuthClient().mfaVerifyByOTP(code: "code") { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    // MARK: - --------- Special scenario  ----------

    func testResetPasswordByFirstTimeLoginToken() {
        let expectation = XCTestExpectation(description: "resetPasswordByFirstTimeLoginToken")
        let userName = "t1"
        AuthClient().loginByAccount(account: userName, password: "t1") { code, _, userInfo in
            XCTAssert(code == 1639)
            AuthClient().resetPasswordByFirstTimeLoginToken(
                token: userInfo?.firstTimeLoginToken ?? "",
                password: "test1"
            ) { code, _ in
                XCTAssert(code == 200)
                AuthClient().loginByAccount(account: userName, password: "test1") { code, _, _ in
                    XCTAssert(code == 200)
                    AuthClient().deleteAccount { code, _ in
                        XCTAssert(code == 200)
                    }
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }
}
