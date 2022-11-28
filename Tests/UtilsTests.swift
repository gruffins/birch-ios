//
//  UtilsTests.swift
//  Birch-Unit-Tests
//
//  Created by Ryan Fung on 11/22/22.
//

import Foundation
import Quick
import Nimble

@testable import Birch

class UtilsTest: QuickSpec {
    override func spec() {
        var manager: FileManager!
        var path: URL!

        beforeEach {
            manager = FileManager.default
            let directory = manager.temporaryDirectory
            path = directory.appendingPathComponent(UUID().uuidString)
        }


        describe("dateFormatter()") {
            it("returns iso8601 dates") {
                let date = Date()
                let str = Utils.dateFormatter.string(from: date)
                expect(str).to(match("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z"))

            }
        }

        describe("safeIgnore()") {
            it("ignores errors") {
                Utils.safeIgnore {
                    throw NSError(domain: "com.gruffins.birch", code: 0)
                }
            }
        }

        describe("getDeviceModel()") {
            it("returns a value") {
                expect(Utils.getDeviceModel()).notTo(beEmpty())
            }
        }

        describe("dictionaryToJson()") {
            it("serializes") {
                let dict = ["key": "value"]
                let str = Utils.dictionaryToJson(input: dict)
                expect(str).to(equal("{\"key\":\"value\"}"))
            }
        }

        describe("jsonToDictionary()") {
            it("deserializes") {
                let str = "{\"key\":\"value\"}"
                let dict = Utils.jsonToDictionary(input: str)
                expect(dict?["key"] as? String).to(equal("value"))
            }
        }

        describe("fileSize()") {
            it("returns the file size") {
                manager.createFile(atPath: path.path, contents: "test".data(using: .utf8)!)
                expect(Utils.fileSize(url: path)).to(beGreaterThan(0))
            }
        }

        describe("deleteFile()") {
            it("deletes the file") {
                Utils.createFile(url: path)
                Utils.deleteFile(url: path)
                expect(Utils.fileExists(url: path)).to(beFalse())

            }
        }

        describe("fileExists()") {
            context("the file does exists") {
                it("returns false") {
                    expect(Utils.fileExists(url: path)).to(beFalse())
                }
            }

            context("file does exist") {
                it("returns true") {
                    Utils.createFile(url: path)
                    expect(Utils.fileExists(url: path)).to(beTrue())
                }
            }
        }

        describe("createFile()") {
            it("creates the file") {
                Utils.createFile(url: path)
                expect(Utils.fileExists(url: path)).to(beTrue())
            }
        }

        describe("moveFile()") {
            it("moves the file") {
                let newPath = manager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                Utils.createFile(url: path)
                try Utils.moveFile(from: path, to: newPath)
                expect(Utils.fileExists(url: path)).to(beFalse())
                expect(Utils.fileExists(url: newPath)).to(beTrue())
            }
        }

        describe("mkdirs()") {
            it("creates the directory") {
                let directory = manager.temporaryDirectory.appendingPathComponent("directory", isDirectory: true)
                try Utils.mkdirs(url: directory)
                expect(Utils.fileExists(url: directory)).to(beTrue())
            }
        }

        describe("diskAvailable()") {
            it("returns something") {
                expect(Utils.diskAvailable()).to(beTrue())
            }
        }
    }
}
