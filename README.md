# S3SignerAWS

## ⚠️ No support is provided for this package ⚠️

This is a fork of a no-longer maintained library. Neither the original author, nor the owner of this repository will
provide any support at all for using this. Use at your own risk, and please don't file issues or ask for help.

## Description

Generates V4 authorization headers and pre-signed URLs for authenticating AWS S3 REST API calls.

### Features
- [x] Pure Swift
- [x] All required headers generated automatically
- [x] V4 Authorization header
- [x] V4 pre-signed URL
- [x] Support DELETE/GET/HEAD/PUT/POST
- [x] Single chunk uploads
- [ ] Multiple chunk uploads

## Table of Contents
  - [Integration](#integration)
  - [Usage](#usage)
    - [V4 Authorization Header](#v4-authorization-header)
    - [V4 Pre-Signed URL](#v4-pre-signed-url)

## Integration
**Swift Package Manager**

To install with swift package manager, add the package to your `Package.swift` file:
```swift
Import PackageDescription

  let package = Package(
    name: "Your_Project_Name",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/armadsen/S3SignerAWS.git", from: "4.0.0")
    ]
  )  
  ```
## Usage

**NOTE ABOUT PAYLOAD:**

Requests can either have a signed payload or an unsigned payload.

* If you know the request will not have a payload, set the Payload property to none. This tells s3 that the signature was created with no payload intended
* If you are not sure what the exact payload will be, set payload property to unsigned. This tells s3 when you made the signature, there was a possibility of a payload but you weren't sure what specific object will be uploaded.
* `Payload` enum:

    ```swift
    public enum Payload {
      case data(Data)
      case none
      case unsigned
    }
    ```
To begin working with the S3SignerAWS class, initialize an instance similar to example shown below:

```swift
let s3Signer = S3SignerAWS(accessKey: "YOUR_AWS_PUBLIC_KEY", secretKey: "YOUR_AWS_SECRET_KEY", region: .usStandard_usEast1)  
```
**NOTE -** Hardcoding Secret Keys on client is _not_ recommended for security reasons.

### V4 Authorization Header
For both V4 Authorization Header and Pre-Signed URL, you can add additional headers as needed for your specific use case.

GET

```swift
do {
  guard let url = URL(string: "https://s3.amazonaws.com/bucketName/testUploadImage.png") else { throw someError }
  let headers = try s3Signer.authHeaderV4(httpMethod: .get, urlString: url.absoluteString, headers: [:], payload: .none)          
  var request = URLRequest(url: url)
  request.httpMethod = HTTPMethod.get.rawValue
  headers.forEach { request.setValue($0.key, forHTTPHeaderField: $0.value) }
      // make network request
    } catch {
      //handle error
    }
  }
  ```
PUT

```swift
do {
  let bytesObject = try someDataObject.makeBytes()
  guard let url = URL(string: "https://s3.amazonaws.com/bucketName/testUploadImage.png") else { throw someError }
  let headers = try s3Signer.authHeadersV4(httpMethod: .put, urlString: url.absoluteString, headers: [:], payload: .bytes(bytesObject))
  var request = URLRequest(url: url)
  request.httpMethod = HTTPMethod.put.rawValue
  request.httpBody = Data(bytes: bytesObject)
  headers.forEach { request.setValue($0.key, forHTTPHeaderField: $0.value) }
      // make network request
    } catch {
    //handle error
    }
  }
  ```
DELETE

```swift
do {
  guard let url = URL(string: "https://s3.amazonaws.com/bucketName/testUploadImage.png") else { throw someError }
  let headers = try s3Signer.authHeadersV4(httpMethod: .delete, urlString: url.absoluteString, headers: [:], payload: .none)
  var request = URLRequest(url: url)
  request.httpMethod = HTTPMethod.delete.rawValue
  headers.forEach { request.setValue($0.key, forHTTPHeaderField: $0.value) }
      // make network request
    } catch {
      //handle error
    }
  }
```

### V4 Pre-Signed URL

Similar to the ease of generating authentication headers, to generate a pre-signed url:
```swift
let presignedURL = signer.presignedURLV4(httpMethod: HTTPMethod, urlString: String, expiration: TimeFromNow, headers: [String: String]) -> String
  ```
