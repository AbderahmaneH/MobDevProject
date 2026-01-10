# Change Password Bug Fix

## Issue Description

After implementing email authentication with bcrypt password hashing, the change password functionality stopped working correctly. When users logged in through the backend API, their password field was stored as empty locally, causing password changes to fail and potentially leaving the database password field empty.

## Root Cause

1. **Backend uses bcrypt hashing:** Passwords are hashed with bcrypt on the backend
2. **Local storage doesn't keep passwords:** When users login via backend, the password field is set to empty string (`password: ''`) in the local User model
3. **Old change password logic:** The frontend `changePassword` method was comparing plain text passwords and storing plain text passwords, which doesn't work with bcrypt

## Solution

### Backend Changes

**File:** `backend/src/models/auth.js`

Added new `changePassword()` function that:
- Retrieves the user with their hashed password from the database
- Uses `bcrypt.compare()` to verify the current password
- Uses `bcrypt.hash()` to hash the new password with SALT_ROUNDS
- Updates only the password field in the database

```javascript
async function changePassword(userId, currentPassword, newPassword) {
  // Get user with password
  const { data: user } = await supabase
    .from('users')
    .select('id, password')
    .eq('id', userId)
    .single();
  
  // Verify current password with bcrypt
  const isPasswordValid = await bcrypt.compare(currentPassword, user.password);
  
  if (!isPasswordValid) {
    return { success: false, error: 'Current password is incorrect' };
  }
  
  // Hash new password
  const hashedPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);
  
  // Update password
  await supabase
    .from('users')
    .update({ password: hashedPassword })
    .eq('id', userId);
    
  return { success: true, message: 'Password changed successfully' };
}
```

**File:** `backend/src/routes/auth.js`

Added new endpoint: `POST /api/auth/change-password`
- Accepts: `userId`, `currentPassword`, `newPassword`
- Validates required fields and password length (min 6 characters)
- Calls the `changePassword()` function
- Returns success or error response

### Frontend Changes

**File:** `lib/logic/auth_cubit.dart`

Updated `changePassword()` method to:
1. **Primary:** Call the backend API for password change
2. **Fallback:** Use local database for backward compatibility with legacy users
3. **Error handling:** Detect when user has no local password and suggest using forgot password feature

```dart
Future<void> changePassword({
  required int? userId,
  required String currentPassword,
  required String newPassword,
}) async {
  emit(AuthLoading());

  try {
    // Use backend API for password change to support bcrypt hashing
    final response = await http.post(
      Uri.parse('https://mobdevproject-5qvu.onrender.com/api/auth/change-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      emit(PasswordChanged());
    } else {
      emit(AuthFailure(error: data['error'] ?? 'Password change failed'));
    }
  } catch (e) {
    // Fallback to local database for backward compatibility
    // ... fallback logic for legacy users
  }
}
```

## Testing

### Test Cases

1. **✅ User with bcrypt password:** Change password successfully
   - Login via backend API
   - Go to profile settings
   - Enter current password and new password
   - Password should be changed and hashed with bcrypt

2. **✅ Incorrect current password:** Show error message
   - Try to change password with wrong current password
   - Should show "Current password is incorrect"

3. **✅ New password too short:** Show validation error
   - Try to set a password shorter than 6 characters
   - Should show validation error

4. **✅ Legacy user with plain text password:** Fallback works
   - User has plain text password stored locally
   - Change password should work with local fallback
   - New password stored as plain text (legacy behavior)

5. **✅ User without local password:** Show helpful message
   - User logged in via backend (password field empty)
   - Try to change password when backend is unavailable
   - Should suggest using forgot password feature

## Security Considerations

- ✅ Current password is verified before allowing change
- ✅ New password is hashed with bcrypt before storage
- ✅ Password is never stored or transmitted in plain text (except for legacy fallback)
- ✅ Minimum password length enforced (6 characters)
- ✅ No password enumeration (error messages are generic)

## Backward Compatibility

The solution maintains backward compatibility:
- Users with plain text passwords (legacy) can still use local fallback
- New users and users who logged in via backend use bcrypt
- Graceful degradation when backend is unavailable

## Files Changed

1. `backend/src/models/auth.js` - Added `changePassword()` function
2. `backend/src/routes/auth.js` - Added `/api/auth/change-password` endpoint
3. `lib/logic/auth_cubit.dart` - Updated `changePassword()` to use backend API

## Deployment Notes

1. Deploy backend changes first
2. Then deploy frontend changes
3. Test change password functionality in production
4. Monitor for any errors in backend logs

## Related Issues

- Original issue: Change password not working after bcrypt implementation
- Related PR: Email authentication support (#PR_NUMBER)
- Commit: bdfbaba

## Future Improvements

Consider implementing:
- Rate limiting on password change endpoint
- Password strength requirements (uppercase, numbers, special chars)
- Password history (prevent reusing recent passwords)
- Email notification when password is changed
- Require re-authentication before allowing password change
