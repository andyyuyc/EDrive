//
//  TripRecorder.swift
//  EDrive
//
//  Created by Andy Yu on 2023/3/29.
//

import Foundation
import CoreLocation
import CoreData

class TripRecorder: NSObject, ObservableObject {
    
    @Published var trip: Trip?
    
    private var locationManager: CLLocationManager?
    private var timer: Timer?
    private var distance: CLLocationDistance = 0
    private var startDate: Date?
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.activityType = .automotiveNavigation
        locationManager?.pausesLocationUpdatesAutomatically = true
        locationManager?.allowsBackgroundLocationUpdates = true
        
        // 请求位置权限
        locationManager?.requestAlwaysAuthorization()
    }
    
    func startRecording() {
        // 开始更新位置
        locationManager?.startUpdatingLocation()
        
        // 初始化计时器
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.updateDuration()
        }
    }
    
    func stopRecording() {
        // 停止更新位置
        locationManager?.stopUpdatingLocation()
        
        // 停止计时器
        timer?.invalidate()
        timer = nil
        
        // 创建行程对象
        let newTrip = Trip(context: PersistenceController.shared.container.viewContext)
        newTrip.startDate = startDate
        newTrip.distance = distance
        newTrip.duration = duration
        newTrip.drivingType = Int16(drivingType.rawValue)
        
        // 添加位置数据到行程对象
        if let locations = trip?.locations {
            for location in locations {
                if let locationEntity = location as? LocationEntity {
                    let newLocation = LocationEntity(context: PersistenceController.shared.container.viewContext)
                    newLocation.latitude = locationEntity.latitude
                    newLocation.longitude = locationEntity.longitude
                    newLocation.timestamp = locationEntity.timestamp
                    newLocation.trip = newTrip
                }
            }
        }
        
        // 保存数据
        PersistenceController.shared.save()
        
        // 发布新的行程数据
        trip = newTrip
        
        // 重置记录器
        reset()
    }
    
    func reset() {
        trip = nil
        distance = 0
        startDate = nil
        lastLocation = nil
    }
    
    private func updateDuration() {
        guard let startDate = startDate else { return }
        duration = Date().timeIntervalSince(startDate)
    }
}

extension TripRecorder: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 计算距离和速度
        if let lastLocation = lastLocation {
            let distanceDelta = location.distance(from: lastLocation)
            distance += distanceDelta
            speed = distanceDelta / (Date().timeIntervalSince(lastLocation.timestamp))
        }
        lastLocation = location
        
        // 添加位置数据
        let locationEntity = LocationEntity(context: PersistenceController.shared.container.viewContext)
        locationEntity.latitude = location.coordinate.latitude
        locationEntity.longitude = location.coordinate.longitude
        locationEntity.timestamp = location.timestamp
        trip?.addToLocations(locationEntity)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
