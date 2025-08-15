# 📢 Political Accountability & Civic Engagement App

_(SDG Goal 16 – Peace, Justice, and Strong Institutions)_

## 📖 Overview

A **Flutter-based mobile app** that enables verified citizens to report local civic issues, collectively validate them, and escalate to the correct authority using an administrative hierarchy. It also highlights **verified completed works** by public representatives to improve transparency during elections.

## 🎯 Objectives

- **Empower citizens** to report and track local issues.
- **Increase transparency** via community validation and public escalation.
- **Reward good governance** by showcasing verified completed work.
- **Build trust** between citizens and representatives.

## 🛠️ Core Features (Expected)

1. **User Verification**
   - Aadhaar-based verification _(sandbox/mock in development)_.
2. **Issue Reporting**
   - Title, description, media (photos/videos), geo-tagged location, category.
3. **Community Validation**
   - Upvotes/downvotes, “I witnessed this” verification by nearby users.
4. **Escalation Engine**
   - Auto-escalates by threshold along an authority tree (Ward → District → State → National).
   - “Nearby districts” expansion for high-impact issues.
5. **Moderator Review**
   - Human review once a report crosses a configurable threshold.
6. **Completed Work Showcase**
   - Representatives post achievements for local verification; once verified, broadcast nationally.
7. **Feed & Locality Scoping**
   - Localized feed by user location; expands in scope after escalation.
8. **Notifications**
   - Status changes, escalation events, moderator decisions, authority responses.
9. **Basic Analytics (MVP)**
   - Issue counts by category/area, SLA/resolution times, top escalations.

## 🧭 Non-Goals (for MVP)

- End-to-end biometric KYC.
- Binding legal ticketing with government portals (can be integrated later).
- Complex gamification/leaderboards.

## 🏗️ Tech Stack (Proposed)

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Auth, Firestore, Storage, Cloud Functions) _or_ Node.js + REST
- **Maps & Geocoding:** Google Maps Platform
- **Auth:** Aadhaar sandbox/mock for development
- **CI/CD:** GitHub Actions / Codemagic (optional)

## 📂 Project Structure (Proposed)

```text
project_root/
├─ lib/
│  ├─ main.dart
│  ├─ app.dart
│  └─ src/
│     ├─ features/
│     │  ├─ auth/
│     │  │  ├─ data/        # adapters, repositories
│     │  │  ├─ domain/      # entities, models
│     │  │  └─ presentation/# screens, widgets, state
│     │  ├─ reports/        # issue reporting & feed
│     │  ├─ escalation/     # thresholds, routing logic
│     │  ├─ moderation/     # moderator tools
│     │  └─ showcase/       # completed works flow
│     ├─ services/          # location, media, api clients
│     ├─ common/            # ui kit, theming, utils
│     └─ routing/           # app routes
├─ assets/
│  ├─ images/
│  └─ icons/
├─ backend/                 # server or cloud functions (if any)
├─ test/                    # unit/widget tests
├─ pubspec.yaml
├─ README.md
└─ .gitignore
```

## 🧩 Data Model (MVP Sketch)

- **User:** `id`, `name`, `aadhaar_verified`, `location`, `roles` (citizen/moderator/admin)
- **Report:** `id`, `author_id`, `title`, `description`, `media_urls[]`, `category`, `geo`, `status`, `upvotes`, `verifications`, `current_level`, `history[]`
- **EscalationRule:** `level`, `threshold`, `radius_km`, `next_level`
- **Showcase:** `id`, `rep_id`, `title`, `description`, `media_urls[]`, `locality`, `verified_votes`, `status`

## 🧱 Roles & Permissions

- **Citizen:** create reports, vote/verify, view feed.
- **Moderator:** review flagged/escalated reports, mark as valid/invalid, request more proof.
- **Admin:** manage escalation rules, categories, authority hierarchy.

## 🔁 Escalation Logic (Example)

1. Report reaches `threshold[level]` in its locality → escalate to next authority level.
2. If impact score or velocity is high, expand visibility to **nearby districts**.
3. Moderator review is triggered at configured levels; invalid reports are rolled back or archived with reason.
4. Authority responses (if integrated) reduce escalation or mark resolved.

## ⚙️ Setup & Run (Flutter)

### Prerequisites

- Flutter SDK (stable), Dart, Android Studio/Xcode setup.
- A Google Maps API key (if using maps).
- Firebase project (if using Firebase).

### Local Development

```bash
# 1) Install dependencies
flutter pub get

# 2) Configure env (see .env.example) and firebase_options.dart if using FlutterFire

# 3) Run
flutter run
```

## 🔐 Environment Variables

Create `.env` or use Flutter flavor configs:

- `GOOGLE_MAPS_API_KEY=`
- `FIREBASE_PROJECT_ID=`
- `AADHAAR_SANDBOX_KEY=` _(mock for dev)_
- `ESCALATION_DEFAULT_THRESHOLD=`

## 🧪 Testing

```bash
flutter test
```

## 🧭 SDG Alignment

Supports **UN SDG 16** by enabling accountable institutions and inclusive participation through verified, auditable citizen reports and transparent escalation.

## 🗺️ Roadmap

- v0.1: Report creation, local feed, upvotes, basic escalation, mock verification.
- v0.2: Moderator dashboard, notifications, showcase verification flow.
- v0.3: Authority directory import, analytics, multi-language UI.
- v1.0: Govt portal integrations, AI-assisted fraud detection.

## 🤝 Contributing

1. Fork & create a feature branch.
2. Write tests where sensible.
3. Open a PR describing the change and screenshots.

## 📝 License

Add your preferred license (e.g., MIT).

---

> Note: Aadhaar integration should use **sandbox/mock** in development and comply with all legal and privacy requirements in production.
