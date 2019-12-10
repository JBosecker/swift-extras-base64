import XCTest
@testable import Base64

class DecodingTests: XCTestCase {
  
  func testDecodeEmptyString() throws {
    let decoded = try "".base64decoded()
    XCTAssertEqual(decoded.count, 0)
  }

  func testBase64DecodingArrayOfNulls() throws {
    let expected = Array(repeating: UInt8(0), count: 10)
    let decoded  = try "AAAAAAAAAAAAAA==".base64decoded()
    XCTAssertEqual(decoded, expected)
  }

  func testBase64DecodingAllTheBytesSequentially() throws {
    let base64 = "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w=="
    
    let expected = Array(UInt8(0)...UInt8(255))
    let decoded  = try base64.base64decoded()
    
    XCTAssertEqual(decoded, expected)
  }
  
  func testBase64UrlDecodingAllTheBytesSequentially() throws {
    let base64 = "AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0-P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn-AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq-wsbKztLW2t7i5uru8vb6_wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t_g4eLj5OXm5-jp6uvs7e7v8PHy8_T19vf4-fr7_P3-_w=="
    
    let expected = Array(UInt8(0)...UInt8(255))
    let decoded  = try base64.base64decoded(options: .base64UrlAlphabet)
    
    XCTAssertEqual(decoded, expected)
  }
  
  func testBase64DecodingWithPoop() {
    do {
      _ = try "💩".base64decoded()
      XCTFail("This point should not be reached")
    }
    catch Base64.DecodingError.invalidCharacter(_) {
      
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
    
  func testBase64DecodingWithInvalidLength() {
    do {
      _ = try "AAAAA".base64decoded()
      XCTFail("This point should not be reached")
    }
    catch Base64.DecodingError.invalidLength {
      
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testNSStringToDecode() {
    let test = "1234567"
    let nsstring = test.data(using: .utf8)!.base64EncodedString()
    
    XCTAssertNoThrow(try nsstring.base64decoded())
  }
  
}
