//
//  File.swift
//  
//
//  Created by Maksim on 02.10.2024.
//

import Foundation

public final class StartupMetricsProvider {
    public static let shared = StartupMetricsProvider()

    private var trackPointToTimeMap = [TrackPoint: DispatchTime]()

    public enum TrackPoint {
        case `init`
        case onFirstContentfulPaint

        var isLast: Bool {
            self == .onFirstContentfulPaint
        }
    }

    public func track(_ point: TrackPoint) {
        guard trackPointToTimeMap[point] == nil else {
            assertionFailure("Track point has been sent twice!")
            return
        }

        trackPointToTimeMap[point] = DispatchTime.now()

        if point.isLast {
            sendMetrics()
        }
    }

    private func sendMetrics() {
        guard let initTime = trackPointToTimeMap[.`init`],
              let fcpTime = trackPointToTimeMap[.onFirstContentfulPaint] else {
            assertionFailure("Cannot find metrics reports!")
            return
        }
        let fcpToInitInterval = initTime.distance(to: fcpTime)
        print("FCP TIME: \(fcpToInitInterval.milliseconds)")
    }
}

private extension DispatchTimeInterval {
    var milliseconds: Int {
        switch self {
        case .seconds(let value): return value * 1_000
        case .milliseconds(let value): return value
        case .microseconds(let value): return value / 1_000
        case .nanoseconds(let value): return value / 1_000_000
        case .never: return .max
        @unknown default:
            assertionFailure("Unknown value case is not handled!")
            return .max
        }
    }
}
