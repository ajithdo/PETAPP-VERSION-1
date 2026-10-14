# PawSetu data model (Cloud Firestore)

All collections are **top level** (no subcollections). Parent ids are stored as fields. Dates are Firestore Timestamps. Money is stored in whole rupees (₹) as numbers. Security rules live in `firestore.rules` (deny by default); roles come from the `role` custom claim.

Roles: `owner`, `vet`, `clinic_admin`, `groomer`, `trainer`, `boarder`, `walker`, `seller`, `admin`. Pet-level roles (in `pets.members`): `owner`, `coowner`, `carer`, `viewer`.

| Collection | Key fields | Who reads | Who writes | Indexes |
| --- | --- | --- | --- | --- |
| `users/{uid}` | name, email, phone, role, plan (free/trial/plus), planRenewsAt, trialEndsAt, language, city, easyMode, partnerId, onboarded, addresses[], consents{}, referralCode, deletionRequestedAt | self, partners (name only in UI), admin | self (not role/plan/partnerId), admin, functions | — |
| `pets/{petId}` | ownerId, name, species, breedId, breedOther, birthday, gender, weightKg, colorTag, photoUrl, markings, microchip, neutered, allergies[], dietType, clinicId, insuranceDocId, temperament, archived, archivedReason, archivedAt, memorial, memorialNote, memberIds[], members{uid:{role,name,expiresAt}}, dailyPlan{walks,meals,playMinutes}, qrToken, lost{since,area,lat,lng,note}, foodBagKg, dailyPortionG, foodProductId, foodOpenedAt | members, admin | owner/co-owner (carer: food and weight only) | memberIds (array-contains) |
| `petInvites/{id}` | petId, petName, invitedBy, invitedByName, contact, role, expiresAt (for sitters), token, status (pending/accepted/declined) | signed-in | owner/co-owner | contact, token |
| `activity/{id}` | petId, actorId, actorName, type, detail, createdAt | pet members | pet members | petId + createdAt desc |
| `logs/{id}` | petId, type (walk, play, meal, water, potty, sleep, grooming, training, mood, weight, behaviour), at, byUid, byName, note, photoUrl, data{distanceKm, durationMin, route[{lat,lng}], grams, mood, tags{tag:intensity}, weightKg, source} | pet members | members (viewer may log) | petId + at desc |
| `vaccinations/{id}` | petId, name, doseLabel, dueDate, givenDate, brand, batch, vetName, clinicName, nextDue, certificateDocId, templateKey | members, vets | owner/co-owner/carer | petId + dueDate |
| `medicines/{id}` | petId, name, dose, unit, frequency (once/twice/every_x_hours/weekly/custom), everyHours, times[], startDate, endDate, withFood, stock, refillAt, active | members | carers+ | petId |
| `medicineLogs/{id}` | medicineId, petId, at, status (given/skipped/snoozed), byUid, byName | members | carers+ | medicineId + at |
| `healthEvents/{id}` | petId, type (deworming, flea_tick, vet_visit, symptom, lab, custom_reminder), date, nextDue, title, notes, severity, photos[], diagnosis, docId | members, vets | carers+ | petId + date |
| `reminders/{id}` | ownerId, petId, type, title, at, repeat, channels[], done | owner | owner | ownerId + at |
| `notifications/{id}` | uid, title, body, type, link, read, createdAt | recipient | functions/app | uid + read, uid + createdAt |
| `outbox/{id}` | channel (push/email/sms/whatsapp), to, subject, body, uid, type, createdAt | admin | app (demo), functions | createdAt desc |
| `clinics/{id}` | name, city, area, address, pin, lat, lng, phone, emergencyPhone, is24x7, hours{mon:[open,close]}, rating, reviewCount, species[], services[{id,price,durationMin,mode,payments[]}], consultationFee, teleVet, languages[], vetIds[], slotMinutes, bufferMinutes, capacityPerSlot, holidays[], blocks[], cancellationHours, homeVisitRadiusKm, homeVisitFee, requestWindowHours, enquiriesEnabled, status (pending/approved/rejected/suspended), rejectReason, ownerUid, kycDocs[] | everyone (approved) | clinic admin (not status/rating), admin | city + status |
| `vets/{id}` | clinicId, clinicName, uid, name, qualification, regNo, experienceYears, languages[], species[], teleVet, videoFee, rating, status | signed-in | clinic admin, admin | clinicId |
| `providers/{id}` | type (groomer/trainer/boarder/walker), name, city, area, address, lat, lng, phone, uid, rating, reviewCount, species[], services[{id,price,durationMin,mode,payments[]}], packages[], homeVisit, atCentre, radiusKm, travelFee, hours{}, slotMinutes, bufferMinutes, capacityPerSlot, holidays[], cancellationHours, requestWindowHours, languages[], status, kycDocs[] | everyone (approved) | provider (not status), admin | type + city + status |
| `bookings/{id}` | ownerId, ownerName, petId, petName, kind (vet/groomer/trainer/boarder/walker), providerId, providerName, vetId, serviceId, start, end, mode (instant/request), status (pending/confirmed/declined/expired/cancelled/completed), proposedTimes[], suggestedTime, respondBy, paymentOption (online/at_clinic), paymentStatus, price, travelFee, platformFee, commission, payout, packageId, homeVisit, address, notes, symptoms, photos[], partnerUids[], reviewId, walkRoute[], updates[{at,text,photoUrl}], createdAt | owner, family, partner, admin | createBooking function; owner/partner update status (never money fields) | ownerId + start, providerId + start, partnerUids + status |
| `reviews/{id}` | targetType (clinic/provider/product/vet), targetId, ownerId, ownerName, bookingId/orderId, rating, text, reply, replyAt, status (visible/hidden/reported), createdAt | everyone | verified owner (after completed booking/delivery), partner reply, admin | targetId + createdAt |
| `conversations/{id}` | type (chat/televet/enquiry), participantIds[], participants{uid:{name,role}}, petId, bookingId, consultationId, lastMessage, lastAt, unread{uid:n}, muted{uid:bool}, blockedBy[], typing{uid:at} | participants, admin | participants | participantIds + lastAt |
| `messages/{id}` | conversationId, senderId, senderName, type (text/photo/pdf/voice/system), text, url, durationSec, createdAt, readBy[] | participants | participants (tele-vet via function) | conversationId + createdAt |
| `consultations/{id}` | ownerId, petId, vetId, vetName, status (queued/active/ended), mode (chat/video), problem, photos[], plan, limits{messages,words,hours}, messagesUsed, startedAt, endsAt, consentAt, rating, prescriptionId, privateNotes | owner, vets, admin | sendTeleVetMessage/startConsultation functions, vet | ownerId + startedAt, status |
| `prescriptions/{id}` | consultationId, petId, vetId, vetName, qualification, regNo, clinicName, items[{medicine,dose,frequency,duration,instructions}], followUp, notes, createdAt | pet members, vets | vet | petId + createdAt |
| `documents/{id}` | ownerId, petId, type (vaccination, insurance, lab, prescription, invoice, licence, adoption, travel, other), title, tags[], url, contentType, expiry, extracted{}, createdAt | owner, pet members | owner | ownerId + createdAt, petId |
| `shareLinks/{id}` | ownerId, petId, docIds[], expiresAt, pin, revoked, accessLog[{at,ip}], createdAt | link holder (via function in live) | owner | — |
| `insurance/{id}` | petId, ownerId, provider, policyNo, cover, premium, start, renewal, docId, claims[{id,date,amount,status,checklist{}}] | pet members | owner | petId |
| `album/{id}` | petId, ownerId, type (photo/video), url, caption, takenAt, favourite, albums[], milestone (birthday/gotcha/first_walk/first_vaccine/custom), durationSec, sizeBytes | pet members | members | petId + takenAt desc |
| `products/{id}` | name, brand, category, subcategory, species[], lifeStages[], breedSizes[], price, mrp, stock, sellerId, partnerId, affiliateUrl, rating, reviewCount, description, ingredients, packKg, deliveryDays, returnable, active | everyone | seller (own), admin | category, sellerId |
| `sellers/{id}` | name, city, uid, status, phone, email, gstin, returnPolicy, rating, kycDocs[] | everyone | seller (not status), admin | — |
| `partners/{id}` | name (affiliate store), url, commissionPercent, clicks, status | everyone | admin | — |
| `carts/{uid}` | items[{productId, qty}] | self | self | — |
| `orders/{id}` | ownerId, petId, items[{productId,name,sellerId,qty,price,commission}], subtotal, discount, coupon, deliveryFee, total, commission, sellerUids[], address{}, slot, status (placed/packed/shipped/out_for_delivery/delivered/cancelled/return_requested/returned), timeline[{status,at}], paymentStatus, invoiceNo, createdAt | owner, sellers in order, admin | createOrder function; status updates by seller/owner | ownerId + createdAt, sellerUids + createdAt |
| `subscriptions/{id}` | ownerId, petId, productId, everyWeeks, nextAt, active | owner | owner | ownerId |
| `expenses/{id}` | ownerId, petId, category (vet, grooming, training, boarding, walking, food, supplies, insurance, other), amount, date, note, source (booking/order/manual), sourceId | owner | owner, functions | ownerId + date |
| `devices/{id}` | ownerId, petId, type (gps_collar, activity_tracker, feeder, fountain, camera, litter_box), name, vendor, status, battery, data{}, safeZone{lat,lng,radiusM}, pairedAt | pet members | members | petId |
| `sosLogs/{id}` | uid, petId, at, lat, lng, area, source (gps/last_known/chosen) | admin | owner | at desc |
| `lostReports/{id}` | petId, ownerId, status (lost/found), since, area, lat, lng, note, alertsSent, sightings[] | everyone (public pet page) | owner | status |
| `tickets/{id}` | uid, role, subject, body, linkType (booking/order/chat), linkId, status (open/in_progress/resolved), assignee, messages[{by,text,at}], refund{amount,status}, createdAt | raiser, admin | raiser, admin | uid, status |
| `reports/{id}` | type (chat/review/content), targetId, reporterId, reason, status (open/actioned/dismissed), createdAt | admin | reporter, admin | status |
| `coupons/{code}` | percent, flat, minOrder, validTill, uses, maxUses, active | signed-in | admin | — |
| `config/app` | plans{plusMonthly,plusYearly,trialDays}, limits{free{},plus{}}, commission{}, flags{} | everyone | admin | — |
| `config/vaccineTemplates`, `config/firstAid` | admin-editable content | everyone | admin | — |
| `auditLog/{id}` | actorId, action, targetId, details, createdAt | admin | admin, functions | createdAt desc |
| `analyticsDaily/{yyyy-mm-dd}` | users, pets, bookings, orderValue, commission, subscriptions, sos | admin | functions (seed in V1) | — |
| `demoAccounts/{uid}` | standalone demo only: email, password, phone, emailVerified | nobody (rules deny) | — | — |

## Storage layout
- `users/{uid}/pets/{petId}/photo.jpg`, `users/{uid}/vault/{docId}`, `users/{uid}/album/{itemId}`, `users/{uid}/chat/{messageId}`
- `public/{uid}/...` partner photos

## Notes
- Money fields on bookings and orders are written only by Cloud Functions (`createBooking`, `createOrder`) in emulator/live mode; the standalone demo runs the same Dart rules on the device.
- Tele-vet limits are enforced by the `sendTeleVetMessage` function; the free-plan numbers come from `config/app.limits`.
