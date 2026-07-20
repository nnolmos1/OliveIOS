import Foundation

enum MedicalCondition: String, CaseIterable, Codable, Identifiable {

    case diabetes = "Type 2 Diabetes"
    case hypertension = "Hypertension"
    case celiac = "Celiac Disease"
    case kidneyDisease = "Kidney Disease"
    case ibs = "IBS"
    case cholesterol = "High Cholesterol"
    case heartDisease = "Heart Disease"

    var id: String { rawValue }

    var icon: String {
        switch self {

        case .diabetes:
            return "drop.fill"

        case .hypertension:
            return "heart.fill"

        case .celiac:
            return "leaf.fill"

        case .kidneyDisease:
            return "cross.case.fill"

        case .ibs:
            return "figure.walk" //Note: change to more relevant icon!

        case .cholesterol:
            return "waveform.path.ecg"

        case .heartDisease:
            return "heart.circle.fill"
        }
    }
}
