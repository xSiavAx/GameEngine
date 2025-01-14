@MainActor
func main() {
    do {
        _ = try Application()
    } catch {
        print("Error \(error)")
    }
}

main()
