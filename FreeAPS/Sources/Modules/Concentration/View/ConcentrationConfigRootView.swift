import SwiftUI
import Swinject

extension ConcentrationConfig {
    struct RootView: BaseView {
        let resolver: Resolver
        @StateObject var state = StateModel()
        @State private var isRemoveAlertPresented = false
        @State private var removeAlert: Alert?

        private var concentrationFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter
        }

        private var conversionFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            return formatter
        }

        private var intFormater: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.allowsFloats = false
            return formatter
        }

        var body: some View {
            Form {
                Section(header: Text("Insulin Concentration")) {
                    HStack {
                        Text("Units per ml ")
                        Spacer()
                        DecimalTextField("100", value: $state.concentration, formatter: concentrationFormatter)
                    }
                }

                Section {
                    Button {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        state.concentration = 100
                        state.conversionFactor = 1.0
                    }
                    label: {
                        Text("Reset to default setting")
                    }
                }

                Section(
                    footer: Text(
                        "Change this setting if you would like to start using an insulin with a different concentration than the standard 100 units/ml (U100) insulin and still would like everything converted to and displayed in insulin units. Every enacted bolus, SMB, temporary basal and every bolus recommendation and ISF and ICR and basal rate setting will then be displayed in standard units.\n\nChanging this setting will also result in an accurate total daily dose (TDD) count.\n\nHowever if you already have been using FreeAPS X with an insulin with non standard concentration with settings adjusted for a non standard insulin concentration using non standard units, please be aware that these settings will have to be changed back to real insulin units again. For you it would therefore ne easier to leave the default units per ml setting, to keep your adjusted (pseudo unit) settings and your current bolus amounts.\n\nIf you want to delete your old TDDs tap the 'Delete TDDs' button below."
                    )
                )
                    {}
            }
            .onAppear(perform: configureView)
            .navigationBarTitle("Insulin Concentration")
            .navigationBarTitleDisplayMode(.automatic)

            Section {
                Text("Delete all TDDs")
                    .foregroundColor(.loopRed)
            }
            .onTapGesture {
                removeAlert = Alert(
                    title: Text("Do you want to delete all of your TDDs?"),
                    primaryButton: .destructive(Text("Delete"), action: { state.delete() }),
                    secondaryButton: .cancel()
                )
                isRemoveAlertPresented = true
            }
            .alert(isPresented: $isRemoveAlertPresented) {
                removeAlert!
            }
        }
    }
}
