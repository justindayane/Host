//
//  TrayRequestParserProtocol.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 5/31/26.
//

protocol TrayRequestParsing {
    func parse(rawText: String) async -> TrayRequestExtraction
}
