import CoreLocation

struct Booth: Identifiable {
    let id: String
    let title: String
    let location: CLLocationCoordinate2D
    let closingTime: Date
    var isScanned: Bool = false
}

func createClosingTime(hour: Int, minute: Int) -> Date {
    var dateComponents = DateComponents()
    let currentDate = Date()
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
    dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow!)
    dateComponents.hour = hour
    dateComponents.minute = minute
    return Calendar.current.date(from: dateComponents) ?? Date()
}

var sampleBooths: [Booth] = [
    Booth(id: "1", title: "Booth 1", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), closingTime: createClosingTime(hour: 16, minute: 0), isScanned: false),
    Booth(id: "2", title: "Booth 2", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), closingTime: createClosingTime(hour: 16, minute: 30), isScanned: false),
    Booth(id: "3", title: "Booth 3", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), closingTime: createClosingTime(hour: 16, minute: 0), isScanned: false),
    Booth(id: "4", title: "Booth 4", location: CLLocationCoordinate2D(latitude: 70, longitude: -83.74339895330718), closingTime: createClosingTime(hour: 16, minute: 45), isScanned: false)
]


/*
// Test 1: Invalid Booth
var sampleBooths: [Booth] = [
    Booth(id: "1", title: "Booth 1", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), isScanned: false),
    Booth(id: "2", title: "Booth 2", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), isScanned: false),
    Booth(id: "3", title: "Booth 3", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), isScanned: false),
    Booth(id: "5", title: "Booth 4", location: CLLocationCoordinate2D(latitude: 70, longitude: -83.74339895330718), isScanned: false)
]


// Test 2: Incorrect Location
var sampleBooths: [Booth] = [
Booth(id: "1", title: "Booth 1", location: CLLocationCoordinate2D(latitude: 42.270506029056634, longitude: -83.74339895330718), isScanned: false),
Booth(id: "2", title: "Booth 2", location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), isScanned: false),
Booth(id: "3", title: "Booth 3", location: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298), isScanned: false),
Booth(id: "4", title: "Booth 4", location: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), isScanned: false)
]
*/




