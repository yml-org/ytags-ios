//
//  TagViewTests.swift
//  YTags
//
//  Created by Dev Karan on 23/02/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YTags

final class TagViewTests: XCTestCase {
    func test_initWithCoder() throws {
        let sut = TagView(coder: try makeCoder(for: UIView()))
        XCTAssertNil(sut)
    }
    
    func test_init_withDefaultValues() {
        let title = "Sample Tag"
        let sut = makeSUT(headerTitle: title)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.titleLabel.text, title)
    }
    
    func test_init_withDefaultValuesWithIcon() throws {
        let title = "Sample Tag"
        let image = try XCTUnwrap(UIImage(systemName: "xmark"))
        let sut = makeSUT(
            appearance: TagView.Appearance(icon: (image, CGSize(width: 22, height: 22))),
            headerTitle: title
        )
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.iconImageView.image, image)
    }
    
    func test_showIcon() throws {
        let sut = makeSUT(headerTitle: "title")
        let backgroundColor: UIColor = .red
        let borderColor: UIColor = .red
        
        XCTAssertTrue(sut.iconImageView.isHidden)
        XCTAssertEqual(sut.backgroundColor, .clear)
        let image = try XCTUnwrap(UIImage(systemName: "xmark"))
        sut.appearance = TagView.Appearance(icon: (image, CGSize(width: 44, height: 44)))
        sut.appearance.backgroundColor = backgroundColor
        sut.appearance.borderColor = borderColor
        
        XCTAssertEqual(sut.backgroundColor, backgroundColor)
        XCTAssertEqual(sut.appearance.borderColor, borderColor)
        XCTAssertFalse(sut.iconImageView.isHidden)
    }
}

private extension TagViewTests {
    func makeSUT(
        appearance: TagView.Appearance = .default,
        headerTitle: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TagView {
        let sut = TagView(title: headerTitle, appearance: appearance)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func makeCoder(for view: UIView) throws -> NSCoder {
        let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
        return try NSKeyedUnarchiver(forReadingFrom: data)
    }
}
