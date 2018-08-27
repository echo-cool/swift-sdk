//
//  BaseTestCase.swift
//  BaseTestCase
//
//  Created by Tang Tianyong on 2/22/16.
//  Copyright © 2016 LeanCloud. All rights reserved.
//

import XCTest
@testable import LeanCloud

class TestObject: LCObject {
    @objc dynamic var numberField: LCNumber?
    @objc dynamic var booleanField: LCBool?
    @objc dynamic var stringField: LCString?
    @objc dynamic var arrayField: LCArray?
    @objc dynamic var dictionaryField: LCDictionary?
    @objc dynamic var objectField: LCObject?
    @objc dynamic var relationField: LCRelation?
    @objc dynamic var geoPointField: LCGeoPoint?
    @objc dynamic var dataField: LCData?
    @objc dynamic var dateField: LCDate?
    @objc dynamic var nullField: LCNull?

    /* The non-LCValue and non-dynamic property cannot be handled. */
    @objc dynamic var nonLCValueField: String?
    var nonDynamicField: LCString?
}

class BaseTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()

        TestObject.register()

        /* App name is "iOS SDK UnitTest". */
        LeanCloud.initialize(
            applicationID:  "nq0awk3lh1dpmbkziz54377mryii8ny4xvp6njoygle5nlyg",
            applicationKey: "6vdnmdkdi4fva9i06lt50s4mcsfhppjpzm3zf5zjc9ty4pdz"
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
