//
//  MenuAnalysisModels.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/20/26.
//

import Foundation

struct MenuAnalysisResult: Codable {
    let safe: [AnalyzedMenuItem]
    let caution: [AnalyzedMenuItem]
    let avoid: [AnalyzedMenuItem]
}

struct AnalyzedMenuItem: Codable, Identifiable {
    let name: String
    let tag: String
    let explanation: String

    var id: String {
        "\(name)-\(tag)"
    }
}
