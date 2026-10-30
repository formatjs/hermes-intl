import XCTest

final class IntlScreenTests: XCTestCase {
  func testEveryNativeIntlAPI() {
    continueAfterFailure = false
    let app = XCUIApplication()
    app.launch()

    let names = [
      "Hermes", "native install", "getCanonicalLocales", "supportedValuesOf",
      "Locale", "PluralRules", "ListFormat", "DisplayNames", "Segmenter",
      "Collator", "NumberFormat", "RelativeTimeFormat", "DateTimeFormat",
      "DurationFormat",
    ]
    for name in names {
      let row = app.staticTexts.matching(identifier: "\(name): PASS").firstMatch
      XCTAssertTrue(row.waitForExistence(timeout: 60), name)
      XCTAssertFalse(row.frame.isEmpty, name)
      XCTAssertTrue(app.frame.contains(row.frame), "\(name): \(row.frame)")
      if app.statusBars.firstMatch.exists {
        XCTAssertGreaterThanOrEqual(row.frame.minY, app.statusBars.firstMatch.frame.maxY, name)
      }
    }
    XCTAssertEqual(app.staticTexts.matching(NSPredicate(format: "label ENDSWITH ': FAIL'")).count, 0)
    let screenshot = XCTAttachment(screenshot: app.screenshot())
    screenshot.name = "intl-screen"
    screenshot.lifetime = .keepAlways
    add(screenshot)
  }
}
