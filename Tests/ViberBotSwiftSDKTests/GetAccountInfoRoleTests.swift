import XCTest
@testable import ViberBotSwiftSDK

final class GetAccountInfoRoleTests: XCTestCase {
    func testSuperadminIsAdminAndAdminIsParticipant() throws {
        let json = """
        {
          "status": 0,
          "status_message": "ok",
          "id": "pa:1",
          "name": "Kate",
          "uri": "kate",
          "subscribers_count": 2,
          "members": [
            {"id": "super-1", "name": "Owner", "role": "superadmin"},
            {"id": "admin-1", "name": "Admin", "role": "admin"},
            {"id": "legacy-1", "name": "Legacy", "role": "participant"}
          ]
        }
        """
        let info = try JSONDecoder().decode(GetAccountInfo.self, from: Data(json.utf8))

        XCTAssertTrue(info.isAdmin("super-1"))
        XCTAssertFalse(info.isParticipant("super-1"))

        XCTAssertFalse(info.isAdmin("admin-1"))
        XCTAssertTrue(info.isParticipant("admin-1"))

        XCTAssertFalse(info.isAdmin("legacy-1"))
        XCTAssertFalse(info.isParticipant("legacy-1"))
    }
}
