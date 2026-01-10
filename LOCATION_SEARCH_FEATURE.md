# Location-Based Queue Search Feature

## Overview
Added the ability to search for queues based on the business owner's location, allowing customers to find nearby queues and see distances.

## Features Added

### 1. Distance Calculation
- **Haversine Formula**: Calculates accurate distance between user and business locations
- **Flexible Range**: Default 50km radius, customizable
- **Distance Display**: Shows in meters (<1km) or kilometers

### 2. Location-Based Search
- **Search by Proximity**: Find queues near your current location
- **Filter by Distance**: Only shows queues within specified radius
- **Sort by Distance**: Results automatically sorted by nearest first
- **Combine with Text Search**: Search by name + location simultaneously

### 3. UI Enhancements
- **Location Button**: Toggle icon in app bar (📍)
  - Gray when off
  - Blue when location search is active
- **Distance Badge**: Shows distance on each queue card
- **Enhanced Queue Cards**: Displays business name, address, and distance
- **Permission Handling**: Requests location permission when needed

## How It Works

### For Customers

1. **Enable Location Search**:
   - Open "Join Queue" page
   - Tap the location icon (📍) in the top right
   - Grant location permission when prompted
   - Queues are automatically filtered by distance

2. **View Results**:
   - Queues show distance (e.g., "1.2 km" or "500 m")
   - Sorted by nearest first
   - See business name and full address
   - Check capacity and availability

3. **Search + Location**:
   - Use search bar with location enabled
   - Results filtered by both name AND distance

### Technical Implementation

#### Database Query
```dart
// Fetches queues with business owner location data
searchQueuesByLocation(
  userLatitude: 36.7538,
  userLongitude: 3.0588,
  maxDistanceKm: 50,
  searchQuery: 'optional search term',
)
```

#### Distance Calculation
```dart
// Haversine formula for accurate distance
double distance = _calculateDistance(
  userLat, userLng,
  businessLat, businessLng,
);
// Returns distance in kilometers
```

#### Returns
```dart
[
  {
    'queue': Queue object,
    'distance': 1.2, // km
    'businessName': 'Example Business',
    'address': '123 Main St',
    'city': 'Algiers',
    'area': 'Bab El Oued',
    'latitude': 36.7538,
    'longitude': 3.0588,
  },
  // ... more results
]
```

## Files Modified

### Core Logic
- **lib/database/repositories/queue_repository.dart**
  - Added `searchQueuesByLocation()` method
  - Added `_calculateDistance()` helper (Haversine formula)
  - Added `_degreesToRadians()` helper
  - Imports `dart:math` for calculations

- **lib/logic/customer_cubit.dart**
  - Added `searchQueuesByLocation()` method
  - Filters out already-joined queues
  - Emits `QueuesSearchedByLocation` state

- **lib/logic/customer_state.dart**
  - Added `QueuesSearchedByLocation` state
  - Contains list of results with queue + distance data

### UI Components
- **lib/presentation/customer/join_queue_page.dart**
  - Added location search toggle button
  - Added `_toggleLocationSearch()` method
  - Added `_buildQueueCardWithDistance()` widget
  - Handles location permissions
  - Shows distance badges on queue cards
  - Imports `geolocator` package

### Localization
- **lib/core/localization.dart**
  - Added `'location_permission_denied'` message

## Usage Examples

### Basic Location Search
```dart
// User taps location button
await context.read<CustomerCubit>().searchQueuesByLocation(
  latitude: 36.7538,
  longitude: 3.0588,
  maxDistanceKm: 50,
);
```

### Location + Text Search
```dart
// User searches "cafe" near their location
await context.read<CustomerCubit>().searchQueuesByLocation(
  latitude: 36.7538,
  longitude: 3.0588,
  maxDistanceKm: 50,
  searchQuery: 'cafe',
);
```

### Custom Radius
```dart
// Search within 10km only
await context.read<CustomerCubit>().searchQueuesByLocation(
  latitude: 36.7538,
  longitude: 3.0588,
  maxDistanceKm: 10, // Smaller radius
);
```

## Requirements

### Database
Business owners must have location data:
- `latitude` (REAL)
- `longitude` (REAL)
- `business_address` (TEXT)
- `city` (TEXT)
- `area` (TEXT)

Run the migration: `supabase/sql/add_location_fields.sql`

### Permissions
- **Android**: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
- **iOS**: `NSLocationWhenInUseUsageDescription`

Already configured in:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

## UI Flow

```
Join Queue Page
      │
      ├─ Tap 📍 Location Icon
      │     │
      │     ├─ Request Location Permission
      │     │
      │     ├─ Get Current Location
      │     │
      │     └─ Search Nearby Queues
      │
      └─ Display Results
            │
            ├─ Show Distance Badge (1.2 km)
            ├─ Show Business Name
            ├─ Show Address
            └─ Sort by Nearest First
```

## Benefits

1. **User Experience**
   - Find closest queues instantly
   - Save travel time
   - Discover nearby businesses

2. **Business Visibility**
   - Appear in location searches
   - Attract nearby customers
   - Location-based marketing

3. **Practical Use Cases**
   - Tourist finding nearby restaurants
   - Emergency services location
   - Daily errands optimization
   - Compare wait times at nearby locations

## Performance

- **Efficient Query**: Only fetches active queues with location data
- **Client-Side Filtering**: Distance calculated in-app
- **Sorted Results**: Pre-sorted by distance
- **Indexed Database**: Location columns are indexed for fast queries

## Future Enhancements

### Possible Additions
1. **Map View**: Show queues on an interactive map
2. **Route Navigation**: Directions to business location
3. **Geofencing**: Notifications when near joined queues
4. **Distance Filters**: Let users set custom radius
5. **Area Clustering**: Group nearby businesses
6. **Historical Data**: Popular times/locations
7. **Multi-Location**: Businesses with multiple branches

### Advanced Features
- Real-time location tracking
- Dynamic radius adjustment
- Traffic-aware ETA calculations
- Walking vs driving distance
- Public transit integration

## Testing

### Test Scenarios
1. ✅ Location permission granted
2. ✅ Location permission denied
3. ✅ No GPS signal
4. ✅ No nearby queues
5. ✅ Mixed near and far queues
6. ✅ Search + location combo
7. ✅ Distance display (m vs km)

### Test Data
Create test queues at various distances:
- 0.5 km away
- 2 km away
- 10 km away
- 100 km away (should not appear with 50km default)

## Notes

- Default location: Algiers, Algeria (36.7538, 3.0588)
- Default search radius: 50 kilometers
- Distance accuracy: ±10 meters (GPS dependent)
- Works offline once location obtained
- Uses device GPS, not IP geolocation

---

**Status**: ✅ Fully implemented and tested
**Dependencies**: geolocator, dart:math
**Breaking Changes**: None
