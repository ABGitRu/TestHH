//
//  Vacancie.swift
//  TestHH
//
//  Created by Mac on 12.09.2021.
//

import Foundation

// MARK: - Vacancie
struct Vacancie: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let name: String?
    let salary: Salary?
    let employer: Employer?
}


// MARK: - Employer
struct Employer: Codable {
    let logoUrls: LogoUrls?

    enum CodingKeys: String, CodingKey {
        case logoUrls = "logo_urls"
    }
}

// MARK: - LogoUrls
struct LogoUrls: Codable {
    let the90: String?

    enum CodingKeys: String, CodingKey {
        case the90 = "90"
    }
}

// MARK: - Salary
struct Salary: Codable {
    let from, to: Int?
    let currency: Currency?
    
    enum Currency: String, Codable {
        case rur = "RUR"
        case kzt = "KZT"
        case byr = "BYR"
        case azn = "AZN"
        case eur = "EUR"
        case gel = "GEL"
        case kgs = "KGS"
        case uah = "UAH"
        case usd = "USD"
        case uzs = "UZS"
    }
}


