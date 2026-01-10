# Testing Guide for Password Reset Fixes

This document provides step-by-step instructions to test the password reset and email delivery fixes.

## Prerequisites
- Backend server running at https://mobdevproject-5qvu.onrender.com
- SendGrid API key configured in environment variables
- Flutter app installed on test device
- Test user account with email access

## Test Scenarios

### Test 1: Complete Password Reset Flow (Critical)

**Purpose:** Verify that users can reset their password and immediately login with the new password.

**Steps:**
1. Open the Flutter app
2. On login screen, tap "Forgot Password?"
3. Enter your email address
4. Verify you receive the reset email (check spam folder if not in inbox)
5. Click the reset link in the email
6. On the reset page, enter a new password (at least 6 characters)
7. Confirm the new password
8. Click "Reset Password"
9. Verify you're redirected to the success page with:
   - ✓ Success icon with animation
   - ✓ "Password Reset Successful!" heading
   - ✓ Message about using new password to login
10. Close the success page
11. Return to the Flutter app
12. Login with your phone number and NEW password
13. Verify login is successful

**Expected Result:** ✅ Login works immediately with the new password

**If Test Fails:**
- Check backend logs for errors
- Verify backend API is accessible
- Check if user's password was updated in database

---

### Test 2: Email Deliverability

**Purpose:** Verify that password reset emails don't go to spam and have proper formatting.

**Steps:**
1. Request a password reset for multiple email providers:
   - Gmail account
   - Outlook/Hotmail account
   - Yahoo Mail account (if available)
2. For each email:
   - Check inbox first (Goal: Should be here)
   - Check spam/junk folder (Should NOT be here)
   - Check promotions tab for Gmail (Acceptable)

**Expected Result:** 
- ✅ Email arrives in inbox (or promotions tab for Gmail)
- ❌ Email should NOT be in spam folder

**Email Content Verification:**
1. Open the password reset email
2. Verify it displays properly:
   - ✓ QNow logo emoji (🕐)
   - ✓ Gradient header (purple/blue)
   - ✓ Clear "Reset My Password" button
   - ✓ Link text is readable and properly formatted
   - ✓ Security notice about 1-hour expiration
   - ✓ Footer with QNow branding
3. Click the "Reset My Password" button
4. Verify it opens the reset page correctly

**If Emails Go to Spam:**
- Follow instructions in `backend/SENDGRID_SETUP.md`
- Set up Domain Authentication in SendGrid (most important)
- Configure SPF, DKIM, DMARC records
- Test again after 24-48 hours

---

### Test 3: Expired Reset Token

**Purpose:** Verify user-friendly error messages for expired tokens.

**Method 1: Wait for Expiration (Slow)**
1. Request a password reset
2. Wait 61+ minutes (token expires in 1 hour)
3. Click the reset link
4. Attempt to reset password

**Method 2: Manual Database Edit (Fast)**
1. Request a password reset
2. Manually update `reset_token_expiry` in database to past timestamp
3. Click the reset link
4. Attempt to reset password

**Expected Error Message:**
```
This reset link has expired. Please request a new password reset link.
```

**Should NOT See:**
- ❌ Any mention of "database" or "reset_token columns"
- ❌ Technical error messages
- ❌ SQL or database terminology

---

### Test 4: Invalid Reset Token

**Purpose:** Verify error handling for invalid tokens.

**Steps:**
1. Use a reset URL with an invalid token:
   ```
   https://mobdevproject-5qvu.onrender.com/reset-password?token=invalid-token-12345
   ```
2. Try to reset password

**Expected Error Message:**
```
This reset link has expired or is invalid. Please request a new password reset link.
```

---

### Test 5: Success Page Display

**Purpose:** Verify the success page displays correctly.

**Steps:**
1. Complete a successful password reset
2. On the success page, verify:
   - ✓ QNow emoji logo (🕐)
   - ✓ Green checkmark icon with animation
   - ✓ "Password Reset Successful!" heading
   - ✓ Success message about using new password
   - ✓ "Close This Page" button
   - ✓ Auto-close note in gray text
   - ✓ Gradient purple/blue styling matches app theme
3. Click the "Close This Page" button
4. Verify page closes or shows appropriate message

**Expected Result:** ✅ Page looks professional and matches app branding

---

### Test 6: Backward Compatibility

**Purpose:** Verify existing users can still login.

**Note:** This test is only relevant if there are users who registered before this fix.

**Steps:**
1. Use an account that was created BEFORE this password reset fix
2. Login with the original password
3. Verify login works

**Expected Result:** ✅ Existing users can still login with their original passwords

**Technical Note:** The Flutter login now tries backend API first, then falls back to local database for backward compatibility.

---

### Test 7: Password Reset for Different Account Types

**Purpose:** Verify password reset works for both customer and business accounts.

**Steps:**
1. Test password reset for a customer account:
   - Request reset
   - Complete reset
   - Login as customer
2. Test password reset for a business account:
   - Request reset
   - Complete reset
   - Login as business owner

**Expected Result:** ✅ Both account types can reset passwords and login

---

## Common Issues and Solutions

### Issue: Email not received
**Solutions:**
1. Check spam/junk folder
2. Verify email address is correct
3. Check SendGrid activity log for delivery status
4. Verify SENDGRID_API_KEY is set correctly
5. Check backend logs for email sending errors

### Issue: Reset link doesn't work
**Solutions:**
1. Check if token has expired (1 hour limit)
2. Verify APP_URL environment variable is set correctly
3. Check backend logs for errors
4. Ensure backend server is running

### Issue: Password reset successful but can't login
**Solutions:**
1. Verify backend API is accessible from Flutter app
2. Check network connectivity
3. Review backend logs for login errors
4. Verify phone number format is correct
5. Check if account type (customer/business) matches

### Issue: Success page doesn't display
**Solutions:**
1. Check browser console for JavaScript errors
2. Verify `/reset-success` route is configured in server.js
3. Check if `reset-success.html` exists in `backend/public/` folder
4. Clear browser cache and try again

---

## Performance Benchmarks

Expected timings for password reset flow:
- Email delivery: < 30 seconds
- Reset page load: < 2 seconds
- Password reset API call: < 1 second
- Redirect to success page: < 1 second
- Login with new password: < 2 seconds

Total expected time: < 2 minutes for complete flow

---

## Security Checklist

Verify the following security measures:
- [ ] Reset tokens expire after 1 hour
- [ ] Tokens are randomly generated (32 bytes)
- [ ] Passwords are hashed with bcrypt (10 salt rounds)
- [ ] Reset links use HTTPS
- [ ] Error messages don't reveal if email exists
- [ ] Passwords are never stored in plain text
- [ ] Old passwords are invalidated after reset
- [ ] Reset tokens are cleared after use

---

## Reporting Issues

If any test fails, collect the following information:
1. Which test scenario failed
2. Exact error message shown
3. Screenshots of the issue
4. Backend logs (if accessible)
5. Browser console errors (for web pages)
6. Steps to reproduce

Then create an issue with this information for investigation.

---

## Success Criteria

All tests pass if:
- ✅ Users can reset their password and login immediately
- ✅ Emails arrive in inbox (not spam)
- ✅ Success page displays correctly
- ✅ Error messages are user-friendly
- ✅ Both customer and business accounts work
- ✅ Backward compatibility maintained
