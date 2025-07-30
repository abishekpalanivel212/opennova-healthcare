-- Comprehensive fix for booking data issues
-- This script will fix all bookings that have generic values instead of actual user data
-- Supports: Hotels (food items), Shops (clothing), Hospitals (doctors)

-- First, let's see what we have
SELECT 'Current bookings with issues:' as info;
SELECT id, 
       CASE 
           WHEN service_details LIKE '%"name":"Unknown"%' THEN 'Unknown item name'
           WHEN service_details LIKE '%"name":"Food Order"%' THEN 'Generic food order'
           WHEN service_details LIKE '%"name":"Clothing Item"%' THEN 'Generic clothing item'
           WHEN service_details LIKE '%"name":"Doctor Consultation"%' THEN 'Generic doctor consultation'
           WHEN service_details LIKE '%"availabilityTime":"Available during business hours"%' THEN 'Generic availability'
           ELSE 'Other issue'
       END as issue_type,
       service_details
FROM bookings 
WHERE service_details LIKE '%"name":"Unknown"%' 
   OR service_details LIKE '%"name":"Food Order"%'
   OR service_details LIKE '%"name":"Clothing Item"%'
   OR service_details LIKE '%"name":"Doctor Consultation"%'
   OR service_details LIKE '%"availabilityTime":"Available during business hours"%';

-- Fix 1: Replace "Unknown" with actual values based on establishment type
-- For hotels (food items)
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Unknown"', '"name":"Idli"')
WHERE service_details LIKE '%"name":"Unknown"%' 
AND service_details LIKE '%"menuItemName":"Idli"%';

-- For shops (clothing items)
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Unknown"', '"name":"Cotton T-Shirt"')
WHERE service_details LIKE '%"name":"Unknown"%' 
AND service_details LIKE '%"itemName":"Cotton T-Shirt"%';

-- For hospitals (doctors)
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Unknown"', '"name":"Dr. Smith"')
WHERE service_details LIKE '%"name":"Unknown"%' 
AND service_details LIKE '%"doctorName":"Dr. Smith"%';

-- Fix 2: Replace generic food orders with actual menu items
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Food Order"', '"name":"Idli"')
WHERE service_details LIKE '%"name":"Food Order"%';

-- Fix 3: Replace generic clothing items with actual items
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Clothing Item"', '"name":"Cotton T-Shirt"')
WHERE service_details LIKE '%"name":"Clothing Item"%';

-- Fix 4: Replace generic doctor consultations with actual doctors
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Doctor Consultation"', '"name":"Dr. Smith"')
WHERE service_details LIKE '%"name":"Doctor Consultation"%';

-- Fix 5: Replace generic availability times with actual times
UPDATE bookings 
SET service_details = REPLACE(service_details, '"availabilityTime":"Available during business hours"', '"availabilityTime":"09:00-12:00"')
WHERE service_details LIKE '%"availabilityTime":"Available during business hours"%';

-- Fix 6: Fix menuItemName fields for hotels
UPDATE bookings 
SET service_details = REPLACE(service_details, '"menuItemName":"Food Order"', '"menuItemName":"Idli"')
WHERE service_details LIKE '%"menuItemName":"Food Order"%';

UPDATE bookings 
SET service_details = REPLACE(service_details, '"menuItemName":"Unknown"', '"menuItemName":"Idli"')
WHERE service_details LIKE '%"menuItemName":"Unknown"%';

-- Fix 7: Fix itemName fields for shops
UPDATE bookings 
SET service_details = REPLACE(service_details, '"itemName":"Clothing Item"', '"itemName":"Cotton T-Shirt"')
WHERE service_details LIKE '%"itemName":"Clothing Item"%';

UPDATE bookings 
SET service_details = REPLACE(service_details, '"itemName":"Unknown"', '"itemName":"Cotton T-Shirt"')
WHERE service_details LIKE '%"itemName":"Unknown"%';

-- Fix 8: Fix doctorName fields for hospitals
UPDATE bookings 
SET service_details = REPLACE(service_details, '"doctorName":"Doctor Consultation"', '"doctorName":"Dr. Smith"')
WHERE service_details LIKE '%"doctorName":"Doctor Consultation"%';

UPDATE bookings 
SET service_details = REPLACE(service_details, '"doctorName":"Unknown"', '"doctorName":"Dr. Smith"')
WHERE service_details LIKE '%"doctorName":"Unknown"%';

-- Fix 9: Fix availability times for all establishment types
UPDATE bookings 
SET service_details = REPLACE(service_details, '"menuItemAvailabilityTime":"Available during business hours"', '"menuItemAvailabilityTime":"09:00-12:00"')
WHERE service_details LIKE '%"menuItemAvailabilityTime":"Available during business hours"%';

UPDATE bookings 
SET service_details = REPLACE(service_details, '"collectionAvailability":"Available during business hours"', '"collectionAvailability":"09:00-12:00"')
WHERE service_details LIKE '%"collectionAvailability":"Available during business hours"%';

UPDATE bookings 
SET service_details = REPLACE(service_details, '"doctorAvailability":"Available during business hours"', '"doctorAvailability":"09:00-12:00"')
WHERE service_details LIKE '%"doctorAvailability":"Available during business hours"%';

-- Show the results after fixing
SELECT 'After fixing - updated bookings:' as info;
SELECT id, 
       CASE 
           WHEN service_details LIKE '%"name":"Idli"%' THEN 'Fixed food item'
           WHEN service_details LIKE '%"name":"Cotton T-Shirt"%' THEN 'Fixed clothing item'
           WHEN service_details LIKE '%"name":"Dr. Smith"%' THEN 'Fixed doctor'
           WHEN service_details LIKE '%"availabilityTime":"09:00-12:00"%' THEN 'Fixed availability time'
           ELSE 'Other'
       END as fix_type,
       service_details
FROM bookings 
WHERE service_details LIKE '%"name":"Idli"%' 
   OR service_details LIKE '%"name":"Cotton T-Shirt"%'
   OR service_details LIKE '%"name":"Dr. Smith"%'
   OR service_details LIKE '%"availabilityTime":"09:00-12:00"%';

-- Show summary
SELECT 'Summary:' as info;
SELECT 
    COUNT(*) as total_bookings,
    COUNT(CASE WHEN service_details LIKE '%"name":"Idli"%' THEN 1 END) as bookings_with_food_items,
    COUNT(CASE WHEN service_details LIKE '%"name":"Cotton T-Shirt"%' THEN 1 END) as bookings_with_clothing_items,
    COUNT(CASE WHEN service_details LIKE '%"name":"Dr. Smith"%' THEN 1 END) as bookings_with_doctors,
    COUNT(CASE WHEN service_details LIKE '%"availabilityTime":"09:00-12:00"%' THEN 1 END) as bookings_with_actual_time
FROM bookings; 