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
                        "Change this setting if you would like to start using an insulin with a non standard concentration, but still would like to have everything displayed in insulin units. Every enacted bolus, SMB, temporary basal, bolus recommendation, ISF, ICR and basal rate setting will then be displayed in real insulin units.\n\nChanging this setting will also result in an accurate total daily dose (TDD) count, even after change of insulin.\n\nHowever if you already have been using a non standard concentration with all settings in psudo units, please be aware that these settings will have to be changed back to reflect insulin units again, and for you it would perhaps be easier to leave the default setting as is, keeping your pseudo units and pseudo bolus amounts.\n\nTo delete all of the old TDDs you can tap the delete button below."
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
