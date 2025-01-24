import C_GLAD
import C_GL

extension Texture {
    struct Format: GLConstantRepresentable {
        let gl: UInt32

        static let red = m(GL_RED)
        static let rg = m(GL_RG)
        static let rgb = m(GL_RGB)
        static let bgr = m(GL_BGR)
        static let rgba = m(GL_RGBA)
        static let bgra = m(GL_BGRA)
        static let redInteger = m(GL_RED_INTEGER)
        static let rgInteger = m(GL_RG_INTEGER)
        static let rgbInteger = m(GL_RGB_INTEGER)
        static let bgrInteger = m(GL_BGR_INTEGER)
        static let rgbaInteger = m(GL_RGBA_INTEGER)
        static let bgraInteger = m(GL_BGRA_INTEGER)
        static let stencilIndex = m(GL_STENCIL_INDEX)
        static let depthComponent = m(GL_DEPTH_COMPONENT)
        static let depthStencil = m(GL_DEPTH_STENCIL)

        var channels: Int {
            switch self {
                case .red: return 1
                case .redInteger: return 1
                case .rg: return 2
                case .rgInteger: return 2
                case .rgb, .bgr: return 3
                case .rgbInteger, .bgrInteger: return 3
                case .rgba, .bgra: return 4
                case .rgbaInteger, .bgraInteger: return 4
                case .depthComponent: return 1
                case .depthStencil: return 2
                case .stencilIndex: fatalError("Not implemented")
                default: fatalError("Unexpected Format")
            }
        }
    }

    struct InternalFormat: GLConstantRepresentable {
        let gl: UInt32

        enum Base { // RGBA, Depth and Stencil Values | Internal Components
            static let depth_component = m(GL_DEPTH_COMPONENT) // Depth | D
            static let depth_stencil = m(GL_DEPTH_STENCIL) // Depth, Stencil | D, S
            static let red = m(GL_RED) // Red R
            static let rg = m(GL_RG) // Red, Green | R, G
            static let rgb = m(GL_RGB) // Red, Green, Blue | R, G, B
            static let rgba = m(GL_RGBA) // Red, Green, Blue, Alpha | R, G, B, A
        }

        enum Sized { // Base | Red Bits | Green Bits |  Blue Bits | Alpha Bits | Shared Bits
            static let r8 = m(GL_R8) // GL_RED | 8
            static let r8SNorm = m(GL_R8_SNORM) // GL_RED | s8
            static let r16 = m(GL_R16) // GL_RED | 16
            static let r16SNorm = m(GL_R16_SNORM) // GL_RED | s16
            static let rg8 = m(GL_RG8) // GL_RG | 8 | 8
            static let rg8SNorm = m(GL_RG8_SNORM) // GL_RG | s8 | s8
            static let rg16 = m(GL_RG16) // GL_RG | 16 | 16
            static let rg16SNorm = m(GL_RG16_SNORM) // GL_RG | s16 | s16 
            static let r3g3b2 = m(GL_R3_G3_B2) // GL_RGB | 3 | 3 | 2
            static let rgb4 = m(GL_RGB4) // GL_RGB | 4 | 4 | 4
            static let rgb5 = m(GL_RGB5) // GL_RGB | 5 | 5 | 5
            static let rgb8 = m(GL_RGB8) // GL_RGB | 8 | 8 | 8
            static let rgb8SNorm = m(GL_RGB8_SNORM) // GL_RGB | s8 | s8 | s8
            static let rgb10 = m(GL_RGB10) // GL_RGB | 10 | 10 | 10
            static let rgb12 = m(GL_RGB12) // GL_RGB | 12 | 12 | 12
            static let rgb16SNorm = m(GL_RGB16_SNORM) // GL_RGB | 16 | 16 | 16
            static let rgba2 = m(GL_RGBA2) // GL_RGB | 2 | 2 | 2 | 2
            static let rgba4 = m(GL_RGBA4) // GL_RGB | 4 | 4 | 4 | 4
            static let rgb5a1 = m(GL_RGB5_A1) // GL_RGBA | 5 | 5 | 5 | 1
            static let rgba8 = m(GL_RGBA8) // GL_RGBA | 8 | 8 | 8 | 8
            static let rgba8SNorm = m(GL_RGBA8_SNORM) // GL_RGBA | s8 | s8 | s8 | s8
            static let rgb10a2 = m(GL_RGB10_A2) // GL_RGBA | 10 | 10 | 10 | 2
            static let rgb10a2ui = m(GL_RGB10_A2UI) // GL_RGBA | ui10 | ui10 | ui10 | ui2
            static let rgba12 = m(GL_RGBA12) // GL_RGBA | 12 | 12 | 12 | 12
            static let rgba16 = m(GL_RGBA16) // GL_RGBA | 16 | 16 | 16 | 16
            static let srgb8 = m(GL_SRGB8) // GL_RGB | 8 | 8 | 8
            static let srgb8alpha8 = m(GL_SRGB8_ALPHA8) // GL_RGBA | 8 | 8 | 8 | 8
            static let r16f = m(GL_R16F) // GL_RED | f16
            static let rg16f = m(GL_RG16F) // GL_RG | f16 | f16
            static let rgb16f = m(GL_RGB16F) // GL_RGB | f16 | f16 | f16    
            static let rgba16f = m(GL_RGBA16F) // GL_RGBA | f16 | f16 | f16 | f16
            static let r32f = m(GL_R32F) // GL_RED | f32
            static let rg32f = m(GL_RG32F) // GL_RG | f32 | f32
            static let rgb32f = m(GL_RGB32F) // GL_RGB | f32 | f32 | f32
            static let rgba32f = m(GL_RGBA32F) // GL_RGBA | f32 | f32 | f32 | f32
            static let r11fg11fb10f = m(GL_R11F_G11F_B10F) // GL_RGB | f11 | f11 | f10
            static let rgb9e5 = m(GL_RGB9_E5) // GL_RGB | 9 | 9 | 9 | 5
            static let r8i = m(GL_R8I) // GL_RED | i8
            static let r8ui = m(GL_R8UI) // GL_RED | ui8
            static let r16i = m(GL_R16I) // GL_RED | i16
            static let r16ui = m(GL_R16UI) // GL_RED | ui16
            static let r32i = m(GL_R32I) // GL_RED | i32
            static let r32ui = m(GL_R32UI) // GL_RED | ui32
            static let rg8i = m(GL_RG8I) // GL_RG | i8 | i8
            static let rg8ui = m(GL_RG8UI) // GL_RG | ui8 | ui8
            static let rg16i = m(GL_RG16I) // GL_RG | i16 | i16
            static let rg16ui = m(GL_RG16UI) // GL_RG | ui16 | ui16
            static let rg32i = m(GL_RG32I) // GL_RG | i32 | i32 
            static let rg32ui = m(GL_RG32UI) // GL_RG | ui32 | ui32
            static let rgb8i = m(GL_RGB8I) // GL_RGB | i8 | i8 | i8
            static let rgb8ui = m(GL_RGB8UI) // GL_RGB | ui8 | ui8 | ui8
            static let rgb16i = m(GL_RGB16I) // GL_RGB | i16 | i16 | i16
            static let rgb16ui = m(GL_RGB16UI) // GL_RGB | ui16 | ui16 | ui16
            static let rgb32i = m(GL_RGB32I) // GL_RGB | i32 | i32 | i32
            static let rgb32ui = m(GL_RGB32UI) // GL_RGB | ui32 | ui32 | ui32
            static let rgba8i = m(GL_RGBA8I) // GL_RGBA | i8 | i8 | i8 | i8
            static let rgba8ui = m(GL_RGBA8UI) // GL_RGBA | ui8 | ui8 | ui8 | ui8
            static let rgba16i = m(GL_RGBA16I) // GL_RGBA | i16 | i16 | i16 | i16
            static let rgba16ui = m(GL_RGBA16UI) // GL_RGBA | ui16 | ui16 | ui16 | ui16
            static let rgba32i = m(GL_RGBA32I) // GL_RGBA | i32 | i32 | i32 | i32
            static let rgba32ui = m(GL_RGBA32UI) // GL_RGBA | ui32 | ui32 | ui32 | ui32
        }

        enum Compressed { // Base Internal Format | Type
            static let red = m(GL_COMPRESSED_RED) //| GL_RED | Generic
            static let rg = m(GL_COMPRESSED_RG) //| GL_RG | Generic
            static let rgb = m(GL_COMPRESSED_RGB) //| GL_RGB | Generic
            static let rgba = m(GL_COMPRESSED_RGBA) //| GL_RGBA | Generic
            static let srgb = m(GL_COMPRESSED_SRGB) //| GL_RGB | Generic
            static let srgbAlpha = m(GL_COMPRESSED_SRGB_ALPHA) //| GL_RGBA | Generic
            static let redRgtc1 = m(GL_COMPRESSED_RED_RGTC1) //| GL_RED | Specific
            static let signedRedRgtc1 = m(GL_COMPRESSED_SIGNED_RED_RGTC1) //| GL_RED | Specific
            static let rgRgtc2 = m(GL_COMPRESSED_RG_RGTC2) //| GL_RG | Specific
            static let signedRgRgtc2 = m(GL_COMPRESSED_SIGNED_RG_RGTC2) //| GL_RG | Specific
            static let rgbaBptcUnorm = m(GL_COMPRESSED_RGBA_BPTC_UNORM) //| GL_RGBA | Specific
            static let srgbAlphaBptcUnorm = m(GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM) //| GL_RGBA | Specific
            static let rgbBptcSignedFloat = m(GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT) //| GL_RGB | Specific
            static let rgbBptcUnsignedFloat = m(GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT) //| GL_RGB | Specific
        }
    }
}
