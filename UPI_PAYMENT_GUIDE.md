# UPI Payment System Guide

## Overview
This project now uses a **completely free UPI payment system** with manual verification. No transaction fees, no third-party dependencies!

## Features
✅ **100% Free** - No transaction fees  
✅ **Safe & Secure** - Manual verification prevents fraud  
✅ **Easy to Use** - Simple UPI links + admin verification  
✅ **India-Friendly** - Works with all UPI apps  

## How It Works

### 1. User Payment Flow
1. User creates a booking
2. System generates a UPI payment link
3. User clicks the link and pays via any UPI app
4. User uploads payment screenshot
5. Payment goes to "pending verification" status
6. Admin reviews and approves/rejects the payment

### 2. Admin Verification Flow
1. Admin logs into admin panel
2. Views pending payments in "Payment Management"
3. Reviews payment screenshots
4. Approves or rejects payments
5. Booking status updates automatically

## Setup Instructions

### 1. Configure UPI ID
Edit `backend/src/main/resources/application.properties`:
```properties
# Replace with your actual UPI ID
upi.business.id=your-business@upi
upi.business.name=OpenNova
```

### 2. Access Admin Panel
- Go to: `http://localhost:8080/admin-payments.html`
- Login with admin credentials
- Navigate to "Payment Management"

## Payment Statuses

- **pending**: Initial payment created
- **pending_verification**: User uploaded screenshot, waiting for admin
- **completed**: Admin approved the payment
- **failed**: Admin rejected the payment

## Benefits

### For Business
- **Zero Transaction Fees** - Keep 100% of payments
- **Full Control** - Manual verification ensures security
- **No Dependencies** - No third-party payment gateways
- **Easy Setup** - Just configure your UPI ID

### For Users
- **Familiar** - Uses standard UPI apps (GPay, PhonePe, Paytm, etc.)
- **Instant** - No waiting for payment processing
- **Secure** - Screenshot verification ensures transparency

## Security Features

1. **Unique Transaction IDs** - Each payment gets a unique identifier
2. **Screenshot Verification** - Users must upload payment proof
3. **Admin Approval** - Manual review prevents fraud
4. **Audit Trail** - All payment actions are logged

## Troubleshooting

### Payment Link Not Working
- Ensure UPI ID is correctly configured
- Check if UPI ID is active and verified
- Test with a small amount first

### Screenshot Upload Issues
- Ensure image format is supported (JPG, PNG)
- Check file size (max 5MB recommended)
- Verify internet connection

### Admin Panel Access
- Ensure you're logged in as admin
- Check if admin token is valid
- Clear browser cache if needed

## Support

For any issues:
1. Check the application logs
2. Verify UPI ID configuration
3. Test with a small payment first
4. Contact system administrator

---

**Note**: This system is designed for small to medium businesses in India. For high-volume transactions, consider implementing additional automation features. 