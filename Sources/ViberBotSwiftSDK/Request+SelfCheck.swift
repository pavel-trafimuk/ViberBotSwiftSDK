import Vapor

extension Request {
    public func isValidViberCallback() -> Bool {
        guard
            let headerHash = headers[Constants.signatureHeaderKey].first,
            let signatureFromHeader = headerHash.data(using: .hexadecimal)
        else {
            return false
        }
        guard let bodyRaw = body.data else {
            return false
        }
        let bodyData = Data(buffer: bodyRaw)
        let keyFromApiKey = SymmetricKey(data: Data(viberBot.config.apiKey.utf8))

        let isValid = HMAC<SHA256>.isValidAuthenticationCode(signatureFromHeader,
                                                             authenticating: bodyData,
                                                             using: keyFromApiKey)
        return isValid
    }
}

extension String {
    enum ExtendedEncoding {
        case hexadecimal
    }
    
    func data(using encoding:ExtendedEncoding) -> Data? {
        let hexStr = self.dropFirst(self.hasPrefix("0x") ? 2 : 0)

        guard hexStr.count % 2 == 0 else { return nil }

        var newData = Data(capacity: hexStr.count/2)

        var indexIsEven = true
        for i in hexStr.indices {
            if indexIsEven {
                let byteRange = i...hexStr.index(after: i)
                guard let byte = UInt8(hexStr[byteRange], radix: 16) else { return nil }
                newData.append(byte)
            }
            indexIsEven.toggle()
        }
        return newData
    }
}
