enum ConcentrationConfig {
    enum Config {}
}

protocol ConcentrationConfigProvider {
    func deleteTDDs()
    func save()
}
