protocol Scene {
    func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws
    func draw(delta: Float) throws
}