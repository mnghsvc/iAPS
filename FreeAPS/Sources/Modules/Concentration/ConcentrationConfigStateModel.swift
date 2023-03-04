import SwiftUI

extension ConcentrationConfig {
    final class StateModel: BaseStateModel<Provider> {
        @Published var concentration: Decimal = 0
        @Published var conversionFactor: Decimal = 0

        override func subscribe() {
            subscribeSetting(\.concentration, on: $concentration.map(Int.init), initial: {
                let value = max(min($0, 500), 10)
                concentration = Decimal(value)
            }, map: {
                $0
            })

            subscribeSetting(\.conversionFactor, on: $conversionFactor, initial: { _ in
                let value = concentration / 100
                conversionFactor = value
            })
        }

        func delete() {
            provider.deleteTDDs()
        }
    }
}
