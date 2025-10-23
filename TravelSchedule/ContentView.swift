//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Мухаммад Махмудов on 16.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var text = "Загрузка..."

    var body: some View {
        Text(text)
            .padding()
            .onAppear {
                CopyrightService().fetchCopyright { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            text = data.text
                        case .failure(let error):
                            text = "Ошибка: \(error.localizedDescription)"
                        }
                    }
                }
                NearestStationsService().fetchNearestStations(lat: 55.75, lng: 37.61, distance: 10) { result in
                    switch result {
                    case .success(let data):
                        print("✅ NearestStations:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ NearestStations error:", error)
                    }
                }
                SearchService().fetchSearch(from: "c146", to: "c213") { result in
                    switch result {
                    case .success(let data):
                        print("✅ Search:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ Search error:", error)
                    }
                }
                ScheduleService().fetchSchedule(stationCode: "s9600213") { result in
                    switch result {
                    case .success(let data):
                        print("✅ Schedule:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ Schedule error:", error)
                    }
                }
                ThreadService().fetchThread(uid: "some_uid") { result in
                    switch result {
                    case .success(let data):
                        print("✅ Thread:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ Thread error:", error)
                    }
                }
                NearestSettlementService().fetchNearestSettlement(lat: 55.75, lng: 37.61) { result in
                    switch result {
                    case .success(let data):
                        print("✅ NearestSettlement:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ NearestSettlement error:", error)
                    }
                }
                CarrierService().fetchCarrier(code: "RZD") { result in
                    switch result {
                    case .success(let data):
                        print("✅ Carrier:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ Carrier error:", error)
                    }
                }
                StationsListService().fetchStationsList() { result in
                    switch result {
                    case .success(let data):
                        print("✅ StationsList:", String(data: data, encoding: .utf8) ?? "")
                    case .failure(let error):
                        print("❌ StationsList error:", error)
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
