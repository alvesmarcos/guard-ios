//
//  GuardTests.swift
//  GuardTests
//
//  Created by Lance Mao on 2021/11/23.
//

@testable import Guard
import XCTest

class GuardTests: XCTestCase {
    var TIMEOUT = 30.0
    var account: String = "ci"
    var password: String = "111111"
    var emailAddress: String = "test@authing.com"
    var emailCode: String = ""
    var phone: String = "15100000000"
    var phoneCode: String = ""

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Authing.start("6244398c8a4575cdb2cb5656")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - --------- Basic Authentication ----------

    func testRegisterByEmailNormal() {
        let expectation = XCTestExpectation(description: "registerByEmailNormal")
        AuthClient().registerByEmail(email: "1@1024.cn", password: "111111") { code, _, _ in
            XCTAssert(code == 200)

            // since force login is true we can get detail right after register
            AuthClient().getCurrentUser { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data?.email == "1@1024.cn")

                AuthClient().deleteAccount { code, _ in
                    XCTAssert(code == 200)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testRegisterByEmail1() {
        let expectation = XCTestExpectation(description: "registerByEmail invalid email address")
        AuthClient().registerByEmail(email: "1024.cn", password: "111111") { code, _, _ in
            XCTAssert(code == 400)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testRegisterByEmail2() {
        let expectation = XCTestExpectation(description: "registerByEmail email address exist")
        AuthClient().registerByEmail(email: "1@1024.cn", password: "111111") { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().registerByEmail(email: "1@1024.cn", password: "111111") { code, _, _ in
                XCTAssert(code == 2026)

                AuthClient().loginByAccount(account: "1@1024.cn", password: "111111") { code, _, _ in
                    XCTAssert(code == 200)

                    AuthClient().deleteAccount { code, _ in
                        XCTAssert(code == 200)
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testRegisterByUserName() {
        let expectation = XCTestExpectation(description: "registerByUserName")
        AuthClient().registerByUserName(username: "10242048", password: "111111") { code, _, _ in
            XCTAssert(code == 200)

            // since force login is true we can get detail right after register
            AuthClient().getCurrentUser { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data?.username == "10242048")

                AuthClient().deleteAccount { code, _ in
                    XCTAssert(code == 200)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testRegisterAccountAndLoginAccount() {
        let expectation = XCTestExpectation(description: "registerAccountAndLoginAccount")
        AuthClient().registerByUserName(username: "account", password: "password") { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().loginByAccount(account: "account", password: "password") { code, _, _ in
                XCTAssert(code == 200)
                AuthClient().deleteAccount { code, _ in
                    XCTAssert(code == 200)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLoginByAccount() {
        let expectation = XCTestExpectation(description: "loginByAccount")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().loginByAccount(account: self.account, password: "idontknow") { code, _, data in
                XCTAssert(code == 2333)
                XCTAssert(data == nil)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLogout() {
        let expectation = XCTestExpectation(description: "logout")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().logout { code, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testLogoutWithNotLoggedIn() {
        let expectation = XCTestExpectation(description: "not logged in")

        AuthClient().logout { code, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testGetSecurityLevel() {
        let expectation = XCTestExpectation(description: "getSecurityLevel")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().getSecurityLevel { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data != nil)
                XCTAssert(data!["score"] as! Int == 60)

                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    // MARK: - --------- Get userInfo ----------

    func testGetCurrentUser() {
        let expectation = XCTestExpectation(description: "getCurrentUser")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().getCurrentUser { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testSetCustomUserData() {
        let expectation = XCTestExpectation(description: "setCustomUserData")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            let body: NSDictionary = ["udfs": ["definition": "test", "value": "value"]]
            AuthClient().setCustomUserData(customData: body) { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testGetCustomUserData() {
        let expectation = XCTestExpectation(description: "getCustomUserData")
        AuthClient().loginByAccount(account: account, password: password) { code, _, userInfo in
            XCTAssert(code == 200)
            AuthClient().getCustomUserData(userInfo: userInfo ?? UserInfo()) { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testUpdatePassword() {
        let expectation = XCTestExpectation(description: "updatePassword")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().updatePassword(newPassword: "test", oldPassword: self.password) { code, _, _ in
                XCTAssert(code == 200)
                AuthClient().loginByAccount(account: self.account, password: "test") { code, _, _ in
                    XCTAssert(code == 200)
                    AuthClient().updatePassword(newPassword: self.password, oldPassword: "test") { code, _, _ in
                        XCTAssert(code == 200)
                        expectation.fulfill()
                    }
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testListApplications() {
        let expectation = XCTestExpectation(description: "listApplications")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().listApplications { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data != nil)
                XCTAssert(!data!.isEmpty)

                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testListOrgs() {
        let expectation = XCTestExpectation(description: "listOrgs")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().listOrgs { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data != nil)
                XCTAssert(data!.isEmpty)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testListRoles() {
        let expectation = XCTestExpectation(description: "listRoles")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().listRoles { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data != nil)
                XCTAssert(data!.isEmpty)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testListAuthorizedResources() {
        let expectation = XCTestExpectation(description: "listAuthorizedResources")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().listAuthorizedResources { code, _, data in
                XCTAssert(code == 200)
                XCTAssert(data != nil)
                XCTAssert(data!.isEmpty)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testDeleteAccount() {
        let expectation = XCTestExpectation(description: "deleteAccount")
        AuthClient().registerByUserName(username: "iOSCI", password: "111111") { code, _, _ in
            XCTAssert(code == 200)

            AuthClient().deleteAccount { code, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testPerformanceLoginByAccount() {
        measure {
            let expectation = XCTestExpectation(description: "loginByAccount")
            AuthClient().loginByAccount(account: account, password: password) { _, _, _ in
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: TIMEOUT)
        }
    }

    // MARK: - --------- Update profile ----------

    func testUpdateProfile() {
        let expectation = XCTestExpectation(description: "updateProfile")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().updateProfile(object: ["test": "profile"]) { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    // MARK: - --------- OIDC ----------

    func testOIDCRegisterByUserName() {
        let expectation = XCTestExpectation(description: "OIDC registerByUserName")
        OIDCClient().registerByUserName(username: "OIDCTest", password: password) { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testOIDCLoginByAccount() {
        let expectation = XCTestExpectation(description: "OIDC loginByAccount")
        OIDCClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testOIDCGetUserInfoByAccessToken() {
        let expectation = XCTestExpectation(description: "OIDC getUserInfoByAccessToken")
        OIDCClient().loginByAccount(account: account, password: password) { code, _, userInfo in
            XCTAssert(code == 200)
            OIDCClient().getUserInfoByAccessToken(userInfo: userInfo) { code, _, _ in
                XCTAssert(code == 200)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testOIDCGetNewAccessTokenByRefreshToken() {
        let expectation = XCTestExpectation(description: "OIDC getNewAccessTokenByRefreshToken")
        OIDCClient().loginByAccount(account: "OIDCTest", password: password) { code, _, userInfo in
            XCTAssert(code == 200)
            OIDCClient().getNewAccessTokenByRefreshToken(userInfo: userInfo) { code, _, _ in
                XCTAssert(code == 200)
                AuthClient().deleteAccount { code, _ in
                    XCTAssert(code == 200)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testPerformanceOIDCLoginByAccount() {
        measure {
            let expectation = XCTestExpectation(description: "OIDC performance loginByAccount")
            OIDCClient().loginByAccount(account: account, password: password) { _, _, _ in
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: TIMEOUT)
        }
    }

    func testSendSms() {
        let expectation = XCTestExpectation(description: "sendSMS")
        AuthClient().sendSms(phone: "15647170125") { code, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testSendSmsFaild() {
        let expectation = XCTestExpectation(description: "sendSMS faild")
        AuthClient().sendSms(phone: "123") { code, _ in
            XCTAssert(code == 500)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testBindPhoneFail() {
        let expectation = XCTestExpectation(description: "bindPhoneFail")

        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().bindPhone(phone: self.phone, code: self.phoneCode) { code, _, _ in
                XCTAssert(code == 400)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testUnbindPhone() {
        let expectation = XCTestExpectation(description: "unbindPhone")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().unbindPhone { _, _, _ in
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testSendEmail() {
        let expectation = XCTestExpectation(description: "sendEmail")
        AuthClient().sendEmail(email: emailAddress, scene: "VERIFY_CODE") { code, _ in
            XCTAssert(code == 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testSendEmailRetry() {
        let expectation = XCTestExpectation(description: "sendEmail retry")
        AuthClient().sendEmail(email: "1@authing.com", scene: "VERIFY_CODE") { code, _ in
            XCTAssert(code == 200)
            AuthClient().sendEmail(email: "1@authing.com", scene: "VERIFY_CODE") { code, _ in
                XCTAssert(code == 2080)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }

    func testUnbindEmail() {
        let expectation = XCTestExpectation(description: "unbindEmail")
        AuthClient().loginByAccount(account: account, password: password) { code, _, _ in
            XCTAssert(code == 200)
            AuthClient().unbindEmail { _, _, _ in
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TIMEOUT)
    }
}
