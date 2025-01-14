struct GLErrorChecker {
    static func errorMessage(
        isSuccess: (inout Int32) -> Void,
        getMessage: (Int32, UnsafeMutablePointer<Int8>?) -> Void
    ) -> String? {
        var success: Int32 = 0

        isSuccess(&success);

        guard success != 0 else {
            let maxLen = 512
            let msg = UnsafeMutableBufferPointer<Int8>.allocate(capacity: maxLen)

            defer { msg.deallocate() }

            getMessage(Int32(maxLen), msg.baseAddress)
            return String(cString: msg.baseAddress!)

        }
        return nil
    }

    static func check(
        isSuccess: (inout Int32) -> Void,
        getMessage: (Int32, UnsafeMutablePointer<Int8>?) -> Void,
        makeError: (String) -> Error
    ) throws {
        if let message = errorMessage(isSuccess: isSuccess, getMessage: getMessage) {
            throw makeError(message)
        }
    }
}