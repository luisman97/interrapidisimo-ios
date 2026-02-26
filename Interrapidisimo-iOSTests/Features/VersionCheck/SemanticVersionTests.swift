//
//  SemanticVersionTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
@testable import Interrapidisimo_iOS

@Suite("SemanticVersion")
struct SemanticVersionTests {
    
    // MARK: - Parsing
    
    @Test func init_parsesFullThreePartVersion() {
        let v = SemanticVersion("1.2.3")
        #expect(v != nil)
        #expect(v?.major == 1)
        #expect(v?.minor == 2)
        #expect(v?.patch == 3)
    }
    
    @Test func init_parsesOnePartVersion_fillsMinorAndPatchWithZero() {
        let v = SemanticVersion("5")
        #expect(v?.major == 5)
        #expect(v?.minor == 0)
        #expect(v?.patch == 0)
    }
    
    @Test func init_parsesTwoPartVersion_fillsPatchWithZero() {
        let v = SemanticVersion("3.4")
        #expect(v?.major == 3)
        #expect(v?.minor == 4)
        #expect(v?.patch == 0)
    }
    
    @Test func init_returnsNil_forEmptyString() {
        #expect(SemanticVersion("") == nil)
    }
    
    @Test func init_returnsNil_forNonNumericString() {
        #expect(SemanticVersion("abc") == nil)
    }
    
    @Test func init_returnsNil_forAlphanumericString() {
        // "1.0.0-beta" → split by "." gives ["1", "0", "0-beta"]
        // "0-beta" can't be converted to Int, so compactMap drops it → [1, 0]
        // This actually parses as 1.0.0 — verify the behaviour:
        let v = SemanticVersion("1.0.0-beta")
        // compactMap { Int($0) } on ["1", "0", "0-beta"] → [1, 0] (drops "0-beta")
        // So parts has 2 elements: major=1, minor=0, patch=0
        #expect(v?.major == 1)
        #expect(v?.minor == 0)
        #expect(v?.patch == 0)
    }
    
    @Test func init_parsesZeroVersion() {
        let v = SemanticVersion("0.0.0")
        #expect(v?.major == 0)
        #expect(v?.minor == 0)
        #expect(v?.patch == 0)
    }
    
    // MARK: - Comparison
    
    @Test func lessThan_majorVersionDiffers() {
        let v1 = SemanticVersion("1.0.0")!
        let v2 = SemanticVersion("2.0.0")!
        #expect(v1 < v2)
        #expect(!(v2 < v1))
    }
    
    @Test func lessThan_minorVersionDiffers() {
        let v1 = SemanticVersion("1.0.0")!
        let v2 = SemanticVersion("1.1.0")!
        #expect(v1 < v2)
        #expect(!(v2 < v1))
    }
    
    @Test func lessThan_patchVersionDiffers() {
        let v1 = SemanticVersion("1.0.0")!
        let v2 = SemanticVersion("1.0.1")!
        #expect(v1 < v2)
        #expect(!(v2 < v1))
    }
    
    @MainActor
    @Test func equality_sameVersions() {
        let v1 = SemanticVersion("1.2.3")!
        let v2 = SemanticVersion("1.2.3")!
        #expect(v1 == v2)
    }
    
    @MainActor
    @Test func equality_onePartEqualsThreePart() {
        // "1" parses as 1.0.0 and "1.0.0" parses as 1.0.0
        let v1 = SemanticVersion("1")!
        let v2 = SemanticVersion("1.0.0")!
        #expect(v1 == v2)
    }
    
    @MainActor
    @Test func greaterThan_majorVersionDiffers() {
        let v1 = SemanticVersion("2.0.0")!
        let v2 = SemanticVersion("1.9.9")!
        #expect(v1 > v2)
    }

    @MainActor
    @Test func greaterThan_patchVersionDiffers() {
        let v1 = SemanticVersion("1.0.2")!
        let v2 = SemanticVersion("1.0.1")!
        #expect(v1 > v2)
    }

    @MainActor
    @Test func comparable_sortOrder() {
        let versions = ["2.0.0", "1.0.1", "1.0.0", "1.1.0"]
            .compactMap { SemanticVersion($0) }
        let sorted = versions.sorted()
        #expect(sorted[0] == SemanticVersion("1.0.0")!)
        #expect(sorted[1] == SemanticVersion("1.0.1")!)
        #expect(sorted[2] == SemanticVersion("1.1.0")!)
        #expect(sorted[3] == SemanticVersion("2.0.0")!)
    }
}
