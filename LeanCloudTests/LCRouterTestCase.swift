//
//  LCRouterTestCase.swift
//  LeanCloudTests
//
//  Created by Tianyong Tang on 2018/9/7.
//  Copyright © 2018 LeanCloud. All rights reserved.
//

import XCTest
@testable import LeanCloud

class LCRouterTestCase: BaseTestCase {
    
    static let usApplication = try! LCApplication(
        id: BaseTestCase.usApp.id,
        key: BaseTestCase.usApp.key)
    
    var appRouter: AppRouter {
        return LCRouterTestCase.usApplication.appRouter
    }
    
    func testModule() {
        Array<(String, AppRouter.Module)>([
            ("v1/route", .rtm),
            ("/v1/route", .rtm),
            ("push", .push),
            ("/push", .push),
            ("installations", .push),
            ("/installations", .push),
            ("call", .engine),
            ("/call", .engine),
            ("functions", .engine),
            ("/functions", .engine),
            ("user", .api),
            ("/user", .api)
        ]).forEach { (path, module) in
            XCTAssertEqual(appRouter.module(path), module)
        }
    }
    
    func testVersionizedPath() {
        let constant = "\(AppRouter.Configuration.default.apiVersion)/foo"
        ["foo", "/foo"].forEach { (path) in
            XCTAssertEqual(
                appRouter.versionizedPath(path),
                constant)
        }
    }
    
    func testAbsolutePath() {
        let constant = "/foo"
        ["foo", "/foo"].forEach { (path) in
            XCTAssertEqual(
                appRouter.absolutePath(path),
                constant)
        }
    }
    
    func testSchemingURL() {
        Array<(String, String)>([
            ("example.com", "https://example.com"),
            ("http://example.com", "http://example.com"),
            ("https://example.com", "https://example.com"),
            ("example.com:8000", "https://example.com:8000"),
            ("http://example.com:8000", "http://example.com:8000"),
            ("https://example.com:8000", "https://example.com:8000")
        ]).forEach { (url, result) in
            XCTAssertEqual(
                appRouter.schemingURL(url),
                result)
        }
    }
    
    func testAbsoluteURL() {
        Array<(String, String, String)>([
            ("example.com", "foo", "https://example.com/foo"),
            ("example.com/", "foo", "https://example.com/foo"),
            ("example.com/foo", "bar", "https://example.com/foo/bar"),
            ("example.com:8000", "foo", "https://example.com:8000/foo"),
            ("example.com:8000/", "foo", "https://example.com:8000/foo"),
            ("example.com:8000/foo", "bar", "https://example.com:8000/foo/bar"),
            
            ("https://example.com", "foo", "https://example.com/foo"),
            ("https://example.com/", "foo", "https://example.com/foo"),
            ("https://example.com/foo", "bar", "https://example.com/foo/bar"),
            ("https://example.com:8000", "foo", "https://example.com:8000/foo"),
            ("https://example.com:8000/", "foo", "https://example.com:8000/foo"),
            ("https://example.com:8000/foo", "bar", "https://example.com:8000/foo/bar"),
            
            ("http://example.com", "foo", "http://example.com/foo"),
            ("http://example.com/", "foo", "http://example.com/foo"),
            ("http://example.com/foo", "bar", "http://example.com/foo/bar"),
            ("http://example.com:8000", "foo", "http://example.com:8000/foo"),
            ("http://example.com:8000/", "foo", "http://example.com:8000/foo"),
            ("http://example.com:8000/foo", "bar", "http://example.com:8000/foo/bar"),
        ]).forEach { (host, path, result) in
            XCTAssertEqual(
                appRouter.absoluteURL(host, path: path),
                URL(string: result))
        }
    }
    
    func testFallbackURL() {
        XCTAssertEqual(
            appRouter.fallbackURL(module: .api, path: "foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).api.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .api, path: "/foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).api.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .rtm, path: "foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).rtm.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .rtm, path: "/foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).rtm.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .push, path: "foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).push.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .push, path: "/foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).push.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .engine, path: "foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).engine.lncldglobal.com/foo"))
        XCTAssertEqual(
            appRouter.fallbackURL(module: .engine, path: "/foo"),
            URL(string: "https://\("jenSt9nv".lowercased()).engine.lncldglobal.com/foo"))
    }
    
    func testCachedHost() {
        appRouter.cacheTable = nil
        XCTAssertNil(appRouter.cachedHost(module: .api))
        
        delay()
        
        Array<AppRouter.Module>([.api, .push, .rtm, .engine]).forEach { (module) in
            XCTAssertNotNil(appRouter.cachedHost(module: module))
        }
        
        appRouter.cacheTable!.createdTimestamp =
            appRouter.cacheTable!.createdTimestamp! -
            appRouter.cacheTable!.ttl!
        XCTAssertNil(appRouter.cachedHost(module: .api))
    }
    
    func testGetAppRouter() {
        expecting { (exp) in
            appRouter.getAppRouter { (response) in
                XCTAssertTrue(response.isSuccess)
                exp.fulfill()
            }
        }
    }
    
    func testRequestAppRouter() {
        for i in 0...1 {
            if i == 1 {
                XCTAssertTrue(appRouter.isRequesting)
            }
            appRouter.requestAppRouter()
        }
        
        delay()
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: appRouter.cacheFileURL!.path))
        try! LCRouterTestCase.usApplication.set(
            id: LCRouterTestCase.usApplication.id,
            key: LCRouterTestCase.usApplication.key)
        XCTAssertNotNil(appRouter.cacheTable)
    }
    
    func testBatchRequestPath() {
        let constant = "/\(AppRouter.Configuration.default.apiVersion)/foo"
        ["foo", "/foo"].forEach { (path) in
            XCTAssertEqual(
                appRouter.batchRequestPath(path),
                constant)
        }
    }

}
