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
                Task {
                    do {
                        let data = try await CopyrightService().fetchCopyright()
                        await MainActor.run {
                            text = data.text
                        }
                    } catch {
                        await MainActor.run {
                            text = "Ошибка: \(error.localizedDescription)"
                        }
                    }

                    do {
                        let nearestStationsData = try await NearestStationsService()
                            .fetchNearestStations(lat: 55.75, lng: 37.61, distance: 10)
                        print("✅ NearestStations:", String(data: nearestStationsData, encoding: .utf8) ?? "")

                        let searchData = try await SearchService()
                            .fetchSearch(from: "c146", to: "c213")
                        print("✅ Search:", String(data: searchData, encoding: .utf8) ?? "")

                        let scheduleData = try await ScheduleService()
                            .fetchSchedule(stationCode: "s9600213")
                        print("✅ Schedule:", String(data: scheduleData, encoding: .utf8) ?? "")

                        let threadData = try await ThreadService()
                            .fetchThread(uid: "some_uid")
                        print("✅ Thread:", String(data: threadData, encoding: .utf8) ?? "")

                        let nearestSettlementData = try await NearestSettlementService()
                            .fetchNearestSettlement(lat: 55.75, lng: 37.61)
                        print("✅ NearestSettlement:", String(data: nearestSettlementData, encoding: .utf8) ?? "")

                        let carrierData = try await CarrierService()
                            .fetchCarrier(code: "RZD")
                        print("✅ Carrier:", String(data: carrierData, encoding: .utf8) ?? "")

                        let stationsListData = try await StationsListService()
                            .fetchStationsList()
                        print("✅ StationsList:", String(data: stationsListData, encoding: .utf8) ?? "")
                    } catch {
                        print("❌ Debug services error:", error)
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
