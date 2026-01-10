# OpenStreetMap Setup Guide

## Overview
This app uses **OpenStreetMap** with the `flutter_map` package - a completely free and open-source mapping solution that requires **NO API KEYS**!

## Why OpenStreetMap?

✅ **Completely Free** - No credit card, no billing, no limits
✅ **No API Keys** - Works out of the box
✅ **Open Source** - Community-driven mapping data
✅ **Privacy Friendly** - No tracking or data collection
✅ **Global Coverage** - Maps for the entire world

## Setup Steps

### 1. Dependencies (Already Added)

The following packages are already in your `pubspec.yaml`:

```yaml
dependencies:
  flutter_map: ^7.0.2        # OpenStreetMap widget
  latlong2: ^0.9.1           # Lat/Long coordinates
  geocoding: ^3.0.0          # Address <-> Coordinates
  geolocator: ^13.0.0        # Get current location
```

### 2. Permissions (Already Configured)

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to help you select your business address</string>
```

### 3. Install and Run

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# For iOS, install pods
cd ios
pod install
cd ..

# Run the app
flutter run
```

### 4. Update Supabase Database

Run the SQL script in your Supabase SQL Editor:
```sql
-- Copy and paste contents from: supabase/sql/add_location_fields.sql
```

## Features

### Interactive Map
- **Tap to select location** - Click anywhere on the map
- **Drag marker** - Move the pin to precise location
- **Current location** - Automatically detects your location
- **Zoom & Pan** - Navigate the map easily

### Address Autocomplete
- Uses OpenStreetMap Nominatim for geocoding
- Converts coordinates to addresses
- Free and unlimited usage

## How It Works

### 1. Map Tiles
The app loads map tiles from OpenStreetMap servers:
```
https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

### 2. Geocoding
Converts coordinates to addresses using the `geocoding` package which uses:
- iOS: Apple's native geocoding
- Android: Android's native geocoding
- Both are free and don't require API keys!

### 3. Location Detection
Uses device GPS via the `geolocator` package to find current location.

## Testing the Feature

1. **Run the app**: `flutter run`
2. **Sign up as Business Owner**
3. **Tap**: "Tap to select location on map"
4. **See**: OpenStreetMap loads automatically
5. **Select**: Tap anywhere or drag the marker
6. **Confirm**: Click "Confirm Location"
7. **Fill**: Complete address details
8. **Save**: Location stored in database

## Troubleshooting

### Map tiles not loading
- **Check internet connection** - Map tiles load from internet
- **Wait a moment** - First load may be slow
- **Try different network** - Some networks block tile servers

### Location permission denied
- **Android**: Grant permission in app settings
- **iOS**: Grant permission when prompted
- **Check**: Device location services are enabled

### Build errors
```bash
# Clean build
flutter clean
flutter pub get

# iOS specific
cd ios
pod deintegrate
pod install
cd ..

# Run again
flutter run
```

### Marker not draggable
The marker is draggable via pan gestures. If it's not working:
- Try tapping to select a new location instead
- The drag functionality works best on real devices

## Advantages Over Google Maps

| Feature | OpenStreetMap | Google Maps |
|---------|---------------|-------------|
| **Cost** | Free forever | Requires billing |
| **API Key** | Not needed | Required |
| **Setup Time** | 2 minutes | 15-30 minutes |
| **Data Privacy** | Your data stays private | Tracked by Google |
| **Limits** | Unlimited | Limited free tier |
| **Offline** | Can cache tiles | Limited offline support |

## Performance Tips

### 1. Tile Caching
The app automatically caches map tiles for better performance.

### 2. Custom Tile Server
If you need better performance, you can host your own tile server:
```dart
TileLayer(
  urlTemplate: 'https://your-tile-server.com/{z}/{x}/{y}.png',
)
```

### 3. Reduce Tile Quality
For slower connections, use lower resolution tiles:
```dart
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  tileSize: 256, // Default
)
```

## Alternative Tile Providers

You can use different map styles by changing the tile URL:

### 1. OpenStreetMap Standard (Default)
```dart
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
```

### 2. OpenStreetMap HOT (Humanitarian)
```dart
urlTemplate: 'https://tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
```

### 3. OpenTopoMap (Topographic)
```dart
urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png'
```

### 4. Stadia Maps Alidade (Smooth styling)
```dart
urlTemplate: 'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png'
```

## Important Notes

### OpenStreetMap Usage Policy
- ✅ Free for all uses
- ✅ No attribution required in app (though appreciated)
- ✅ Unlimited tile requests (be reasonable)
- ❌ Don't scrape/download bulk data
- ❌ Don't overload servers (implement caching)

### Data Accuracy
OpenStreetMap data is:
- Community-maintained
- Very accurate in major cities
- May have gaps in remote areas
- Constantly improving

## Resources

- **OpenStreetMap**: https://www.openstreetmap.org
- **flutter_map Documentation**: https://docs.fleaflet.dev
- **Tile Servers**: https://wiki.openstreetmap.org/wiki/Tile_servers
- **OSM Community**: https://community.openstreetmap.org

## Support

If you encounter issues:
1. Check internet connection
2. Verify permissions are granted
3. Try `flutter clean && flutter pub get`
4. Test on a real device
5. Check the flutter_map GitHub issues

---

**That's it!** No API keys, no billing, no complicated setup. Just install and run! 🎉
