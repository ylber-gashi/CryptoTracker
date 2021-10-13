import Foundation

class Currency: Codable {
    var asset_id: String? = "nil"
    var name: String? = "nil"
    var type_is_crypto: Int? = 0
    var price_usd: Float? = 0.0

    init(asset_id: String, name: String, type_is_crypto: Int, price_usd: Float) {
        self.asset_id = asset_id
        self.name = name
        self.type_is_crypto = type_is_crypto
        self.price_usd = price_usd
    }

}
