//
//  KardashevStage.swift
//  KardashevGame
//
//  Enum per i tre stadi della scala di Kardašëv
//

import Foundation

enum KardashevStage: Int, Codable, CaseIterable {
    case type1 = 1  // Civiltà planetaria - controllo dell'energia del pianeta
    case type2 = 2  // Civiltà stellare - controllo dell'energia della stella
    case type3 = 3  // Civiltà galattica - controllo dell'energia della galassia
    
    var displayName: String {
        switch self {
        case .type1:
            return "Tipo I - Civiltà Planetaria"
        case .type2:
            return "Tipo II - Civiltà Stellare"
        case .type3:
            return "Tipo III - Civiltà Galattica"
        }
    }
    
    var description: String {
        switch self {
        case .type1:
            return "Sfrutta tutta l'energia disponibile sul tuo pianeta"
        case .type2:
            return "Sfrutta tutta l'energia della tua stella con una Sfera di Dyson"
        case .type3:
            return "Sfrutta tutta l'energia della galassia"
        }
    }
    
    var unlockCost: BigNumber {
        switch self {
        case .type1:
            return BigNumber(0) // Già sbloccato
        case .type2:
            return BigNumber(BalanceConfig.stage1ToStage2UnlockCost)
        case .type3:
            return BigNumber(BalanceConfig.stage2ToStage3UnlockCost)
        }
    }
    
    var clickMultiplier: Double {
        return pow(BalanceConfig.clickMultiplierPerStage, Double(self.rawValue - 1))
    }
}
