-- Keep a log of any SQL queries you execute as you solve the mystery.


-- Show description, Notes Theft of the CS50 duck took place at 10:15am
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = "Chamberlin Street";
-- Get how the actvity is describe
-- NOTES: Sometime within ten minutes of the theft,
-- I saw the thief get into a car in the courthouse parking lot and drive away.
-- If you have security footage from the courthouse parking lot,
-- you might want to look for cars that left the parking lot in that time frame.

-- I don't know the thief's name, but it was someone I recognized.
-- Earlier this morning, before I arrived at the courthouse,
-- I was walking by the ATM on "Fifer Street" and saw the thief there "withdrawing" some money.

-- As the thief was leaving the courthouse, they "called someone who talked to them for less than a minute".
-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville "tomorrow".
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.

SELECT transcript * FROM interviews WHERE month = 7 AND day = 28 AND transcript LIKE "%the courthouse%"
-- Eugene  ATM on Fifer Street.
-- Raymond In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow., 29

-- Ruth Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away.
-- If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.

SELECT distinct * FROM people WHERE license_plate in (
SELECT license_plate FROM courthouse_security_logs
WHERE activity = "exit" AND month = 7 AND day = 28 AND hour = 10 AND minute BETWEEN 15 AND 25);
--     id | name      | phone_number   | passport_number | license_plate
-- 221103 | Patrick   | (725) 555-4692 | 2963008352      | 5P2BI95
-- 243696 | Amber     | (301) 555-4174 | 7526138472      | 6P58WS2
-- 396669 | Elizabeth | (829) 555-5269 | 7049073643      | L93JTIZ
-- 398010 | Roger     | (130) 555-0289 | 1695452385      | G412CB7
-- 467400 | Danielle  | (389) 555-5198 | 8496433585      | 4328GD8
-- 514354 | Russell   | (770) 555-1861 | 3592750733      | 322W7JE
-- 560886 | Evelyn    | (499) 555-9472 | 8294398571      | 0NTHK55
-- 686048 | Ernest    | (367) 555-5533 | 5773159633      | 94KL13X

SELECT * FROM atm_transactions WHERE atm_location = "Fifer Street" AND month = 7 AND day = 28 AND transaction_type = "withdraw";
-- id  | account_number | year | month | day | atm_location | transaction_type | amount
-- 246 | 28500762       | 2020 |  7    | 28  | Fifer Street | withdraw         | 48
-- 264 | 28296815       | 2020 |  7    | 28  | Fifer Street | withdraw         | 20
-- 266 | 76054385       | 2020 |  7    | 28  | Fifer Street | withdraw         | 60
-- 267 | 49610011       | 2020 |  7    | 28  | Fifer Street | withdraw         | 50
-- 269 | 16153065       | 2020 |  7    | 28  | Fifer Street | withdraw         | 80
-- 288 | 25506511       | 2020 |  7    | 28  | Fifer Street | withdraw         | 20
-- 313 | 81061156       | 2020 |  7    | 28  | Fifer Street | withdraw         | 30
-- 336 | 26013199       | 2020 |  7    | 28  | Fifer Street | withdraw         | 35

SELECT DISTINCT caller,receiver FROM phone_calls WHERE month = 7 AND day = 28 AND duration <= 59;
-- caller         | receiver
-- (130) 555-0289 | (996) 555-8899
-- (499) 555-9472 | (892) 555-8872
-- (367) 555-5533 | (375) 555-8161
-- (499) 555-9472 | (717) 555-1342
-- (286) 555-6063 | (676) 555-6554
-- (770) 555-1861 | (725) 555-3243
-- (031) 555-6622 | (910) 555-3251
-- (826) 555-1652 | (066) 555-9701
-- (338) 555-6650 | (704) 555-2131

SELECT distinct caller, receiver FROM phone_calls WHERE month = 7 AND day = 28 AND duration <= 59 AND caller in (
SELECT distinct phone_number FROM people WHERE license_plate in (
SELECT license_plate FROM courthouse_security_logs WHERE activity = "exit" AND month = 7 AND day = 28 AND hour between 8 AND 13));
-- caller         | receiver
-- (130) 555-0289 | (996) 555-8899
-- (499) 555-9472 | (892) 555-8872
-- (367) 555-5533 | (375) 555-8161
-- (499) 555-9472 | (717) 555-1342
-- (286) 555-6063 | (676) 555-6554
-- (770) 555-1861 | (725) 555-3243

SELECT * FROM people WHERE phone_number in (SELECT distinct caller FROM phone_calls WHERE duration <= 59
AND caller in (SELECT distinct phone_number FROM people
WHERE license_plate in (SELECT license_plate FROM courthouse_security_logs
WHERE activity = "exit" AND month = 7 AND day = 28 AND hour between 8 AND 13)));
-- id     | name     | phone_number     | passport_number | license_plate
-- 282425 | Martha   | (007) 555-2874   |                 | O784M2U
-- 398010 | Roger    | (130) 555-0289   | 1695452385      | G412CB7
-- 449774 | Madison  | (286) 555-6063   | 1988161715      | 1106N58
-- 514354 | Russell  | (770) 555-1861   | 3592750733      | 322W7JE
-- 560886 | Evelyn   | (499) 555-9472   | 8294398571      | 0NTHK55
-- 620297 | Peter    | (751) 555-6567   | 9224308981      | N507616
-- 686048 | Ernest   | (367) 555-5533   | 5773159633      | 94KL13X
-- 864400 | Berthold | (375) 555-8161   |                 | 4V16VO0




SELECT * FROM flights WHERE day = 29 AND id in (SELECT flight_id FROM passengers WHERE passport_number in (
SELECT passport_number FROM people WHERE phone_number in (
SELECT distinct caller FROM phone_calls WHERE duration <= 59 AND caller in (
SELECT distinct phone_number FROM people WHERE license_plate in (
SELECT license_plate
from courthouse_security_logs WHERE activity = "exit" AND month = 7 AND day = 28 AND hour between 8 AND 13))))) ORDER BY hour LIMIT 1;
-- id | origin_airport_id | destination_airport_id | year | month | day | hour | minute
-- 36 |                 8 |                      4 | 2020 |     7 |  29 |    8 | 20

SELECT * FROM airports FROM id in (SELECT destination_airport_id FROM flights WHERE day = 29 AND id in(
SELECT flight_id FROM passengers WHERE passport_number in (
SELECT passport_number FROM people WHERE phone_number in (
SELECT distinct caller FROM phone_calls WHERE duration <= 59
AND caller in (
SELECT distinct phone_number FROM people
WHERE license_plate in (
SELECT license_plate FROM courthouse_security_logs
WHERE activity = "exit" AND month = 7 AND day = 28 AND hour between 8 AND 13))))) ORDER BY hour LIMIT 1);

-- id | abbreviation |        full_name | city
-- 4  |          LHR | Heathrow Airport | London


-- ,people.phone_number
SELECT DISTINCT people.name FROM airports
join passengers
JOIN courthouse_security_logs
join flights
JOIN phone_calls
JOIN people
ON courthouse_security_logs.activity = "exit"
AND courthouse_security_logs.day = 28
AND courthouse_security_logs.month = 7
AND courthouse_security_logs.hour = 10
AND courthouse_security_logs.minute BETWEEN 15 AND 25
AND courthouse_security_logs.license_plate = people.license_plate
AND people.passport_number = passengers.passport_number
AND phone_calls.caller = people.phone_number
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration < 59
AND airports.id  = flights.destination_airport_id
AND flights.month = 7
and flights.day = 29
AND flights.hour <= 8
AND flights.minute = 20
AND passengers.flight_id = flights.id
ORDER BY flights.hour, people.name ASC ;
-- name   | phone_number
-- Ernest | (367) 555-5533


SELECT name FROM people WHERE phone_number in (
SELECT receiver FROM phone_calls WHERE caller = "(367) 555-5533" AND day= 28 AND month = 7 AND duration < 60);

-- name
-- Berthold
