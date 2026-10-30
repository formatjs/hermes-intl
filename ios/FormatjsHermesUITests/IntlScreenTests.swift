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
      XCTAssertTrue(app.staticTexts["\(name): PASS"].waitForExistence(timeout: 60), name)
    }
    XCTAssertEqual(app.staticTexts.matching(NSPredicate(format: "label ENDSWITH ': FAIL'")).count, 0)
    let screenshot = XCTAttachment(screenshot: app.screenshot())
    screenshot.name = "intl-screen"
    screenshot.lifetime = .keepAlways
    add(screenshot)
  }
}
