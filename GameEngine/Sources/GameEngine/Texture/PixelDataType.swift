import C_GLAD
import C_GLFW
import C_GL

struct PixelDataType: GLConstantRepresentable {
    let gl: UInt32

    static let unsignedByte = m(GL_UNSIGNED_BYTE)
    static let byte = m(GL_BYTE)
    static let unsignedShort = m(GL_UNSIGNED_SHORT)
    static let short = m(GL_SHORT)
    static let unsignedInt = m(GL_UNSIGNED_INT)
    static let int = m(GL_INT)
    static let half_float = m(GL_HALF_FLOAT)
    static let float = m(GL_FLOAT)
    static let unsignedByte_3_3_2 = m(GL_UNSIGNED_BYTE_3_3_2)
    static let unsignedByte_2_3_3_rev = m(GL_UNSIGNED_BYTE_2_3_3_REV)
    static let unsignedShort_5_6_5 = m(GL_UNSIGNED_SHORT_5_6_5)
    static let unsignedShort_5_6_5_rev = m(GL_UNSIGNED_SHORT_5_6_5_REV)
    static let unsignedShort_4_4_4_4 = m(GL_UNSIGNED_SHORT_4_4_4_4)
    static let unsignedShort_4_4_4_4_rev = m(GL_UNSIGNED_SHORT_4_4_4_4_REV)
    static let unsignedShort_5_5_5_1 = m(GL_UNSIGNED_SHORT_5_5_5_1)
    static let unsignedShort_1_5_5_5_rev = m(GL_UNSIGNED_SHORT_1_5_5_5_REV)
    static let unsignedInt_8_8_8_8 = m(GL_UNSIGNED_INT_8_8_8_8)
    static let unsignedInt_8_8_8_8_rev = m(GL_UNSIGNED_INT_8_8_8_8_REV)
    static let unsignedInt_10_10_10_2 = m(GL_UNSIGNED_INT_10_10_10_2)
    static let unsignedInt_2_10_10_10_rev = m(GL_UNSIGNED_INT_2_10_10_10_REV)
}