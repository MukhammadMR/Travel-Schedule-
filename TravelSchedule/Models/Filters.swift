import Foundation

struct Filters {
    var selectedSlots: Set<DepartureSlot> = []
    var transfers: TransfersFilter = .no

    var hasActiveFilters: Bool {
        if !selectedSlots.isEmpty { return true }
        if transfers == .yes { return true }
        return false
    }
}

