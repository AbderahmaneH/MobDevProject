# Quick Start Guide - Location Feature

## Immediate Steps Required

### Step 1: Update Supabase Database (2 minutes)

1. Open Supabase Dashboard: https://supabase.com
2. Go to SQL Editor
3. Copy contents of: `supabase/sql/add_location_fields.sql`
4. Paste and run in SQL Editor
5. Verify columns were added to users table

### Step 2: Install Dependencies (1 minute)

```bash
flutter clean
flutter pub get
```

For iOS:
```bash
cd ios
pod install
cd ..
```

### Step 3: Test the App (5 minutes)

```bash
# Run the app
flutter run

# Or for specific device
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

## What Changed?

### For Business Owners:
- Instead of typing address → They now select location on a map
- After selecting on map → They fill complete address details
- Location is saved with GPS coordinates

### Data Stored:
- Latitude & Longitude (precise location)
- Full address, area, city, state, pincode
- Optional landmark

## Testing the Feature

1. Run app and tap "Sign Up"
2. Select "Business Owner"
3. Fill: Name, Phone, Email, Business Name
4. Tap: "Tap to select location on map"
5. Select location on map (tap or drag marker)
6. Tap: "Confirm Location"
7. Fill: Complete address details
8. Tap: "Save Address"
9. Complete signup with password
10. Account created! ✅

## Troubleshooting

**Map not showing?**
→ Check internet connection (OpenStreetMap tiles load from internet)
→ Clear cache: `flutter clean && flutter pub get`

**Location not working?**
→ Grant location permission when prompted
→ Test on real device (not emulator)

**Build errors?**
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

## Important Files

- 📄 `OPENSTREETMAP_SETUP.md` - Setup guide
- 📄 `supabase/sql/add_location_fields.sql` - Database migration
- 🗂️ `lib/presentation/common/map_location_picker.dart` - Map screen
- 🗂️ `lib/presentation/common/address_details_page.dart` - Address form

## Need Help?

1. Read: `OPENSTREETMAP_SETUP.md` for detailed instructions
2. Check: Internet connection for map tiles
3. Verify: Location permissions are granted
4. Test: On real device for best results

---

**Note**: This app uses OpenStreetMap which is completely free and requires no API keys!
