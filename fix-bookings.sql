-- Fix existing bookings to show actual user data instead of generic values
-- This script will update bookings that have "Unknown" or generic values

-- First, let's see what we have
SELECT id, service_details FROM bookings WHERE service_details LIKE '%"name":"Unknown"%' OR service_details LIKE '%"name":"Food Order"%';

-- Update bookings to replace "Unknown" with actual menu item names if they exist
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Unknown"', '"name":"Idli"')
WHERE service_details LIKE '%"name":"Unknown"%' 
AND service_details LIKE '%"menuItemName":"Idli"%';

-- Update bookings to replace "Food Order" with actual menu item names if they exist
UPDATE bookings 
SET service_details = REPLACE(service_details, '"name":"Food Order"', '"name":"Idli"')
WHERE service_details LIKE '%"name":"Food Order"%' 
AND service_details LIKE '%"menuItemName":"Idli"%';

-- Update availability times to show actual times instead of generic ones
UPDATE bookings 
SET service_details = REPLACE(service_details, '"availabilityTime":"Available during business hours"', '"availabilityTime":"09:00-12:00"')
WHERE service_details LIKE '%"availabilityTime":"Available during business hours"%' 
AND service_details LIKE '%"menuItemAvailabilityTime":"09:00-12:00"%';

-- Show the results after the update
SELECT id, service_details FROM bookings WHERE service_details LIKE '%"name":"Idli"%' OR service_details LIKE '%"availabilityTime":"09:00-12:00"%'; 