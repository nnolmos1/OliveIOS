//
//  MenuAnalysisModels.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/20/26.
//

import Foundation

// MARK: - Complete Analysis

struct MenuAnalysisResult: Codable, Sendable {
    let safe: [AnalyzedMenuItem]
    let caution: [AnalyzedMenuItem]
    let avoid: [AnalyzedMenuItem]
}

// MARK: - Individual Menu Item

struct AnalyzedMenuItem: Codable, Identifiable, Hashable, Sendable {
    let name: String
    let tag: String
    let explanation: String

    var id: String {
        "\(name)|\(tag)|\(explanation)"
    }
}
