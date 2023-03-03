import SwiftUI

extension ConcentrationConfig {
    final class StateModel: BaseStateModel<Provider> {
        @Published var concentration: Decimal = 0

        override func subscribe() {
            // subscribeSetting(\.deleteTDDs, on: $deleteTDDs) { deleteTDDs = $0 }

            subscribeSetting(\.concentration, on: $concentration.map(Int.init), initial: {
                let value = max(min($0, 200), 100)
                concentration = Decimal(value)
            }, map: {
                $0
            })
        }

        func delete() {
            provider.deleteTDDs()
        }

        func save() {
            provider.save()
        }
    }
}
