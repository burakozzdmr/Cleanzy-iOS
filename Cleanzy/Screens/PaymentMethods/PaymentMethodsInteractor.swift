//
//  PaymentMethodsInteractor.swift
//  Cleanzy
//

import Foundation

// MARK: - PaymentMethodsInteractor
// NOTE: Backend'de payment endpoints henüz yok.
// Kartlar şimdilik uygulama içi (in-memory) tutulur.

final class PaymentMethodsInteractor {
    weak var presenter: PaymentMethodsInteractorOutputProtocol?

    private var cards: [PaymentCardItem] = [
        PaymentCardItem(holderName: "BURAK ÖZDEMİR", lastFour: "4242", expiryDate: "12/27", isDefault: true),
        PaymentCardItem(holderName: "BURAK ÖZDEMİR", lastFour: "5353", expiryDate: "08/26")
    ]
}

// MARK: - PaymentMethodsInteractorInputProtocol

extension PaymentMethodsInteractor: PaymentMethodsInteractorInputProtocol {
    func fetchCards() {
        presenter?.didFetchCards(cards)
    }

    func deleteCard(at index: Int) {
        guard index < cards.count else { return }
        cards.remove(at: index)
        presenter?.didDeleteCard(at: index)
    }
}
