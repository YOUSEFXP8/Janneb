# CrashAssist 🚗

> A mobile application that streamlines car accident reporting in Jordan — replacing paper forms and long waits with a fast, digital, evidence-backed process.

---

## The Problem

Reporting a car accident in Jordan currently means:
- Waiting up to an hour for a traffic officer
- Manually filling paper forms at the scene
- Disputes between drivers with no neutral record
- Insurance claims delayed by missing or inconsistent reports

CrashAssist fixes this.

---

## What It Does

Drivers involved in an accident can:
1. **Create a shared session** — a unique QR code and join code is generated instantly
2. **Link both drivers** — the other driver scans the QR or types the code to join the same session
3. **Capture evidence** — minimum 2 photos required, GPS location captured automatically
4. **Submit independently** — each driver fills their details and statement on their own time
5. **Track their case** — real-time status updates from report to verdict
6. **Download the verdict** — officer uploads the official PDF report

---

## Features

| Feature | Description |
|---------|-------------|
| 🔗 QR Session Sharing | Link both drivers to the same accident via QR or 6-character code |
| 📍 Auto GPS Location | Captured automatically — cannot be edited manually |
| 📸 Photo Evidence | Minimum 2 photos required, stored in secure cloud storage |
| 📝 Independent Statements | Each driver submits their own account independently |
| 📊 Status Tracking | Pending → Under Review → Officer Assigned → Completed |
| 📄 Officer Report | Officer uploads PDF verdict, drivers can download it |
| 🚗 Vehicle Management | Register multiple vehicles, select the relevant one per accident |
| 🆘 Emergency Access | One-tap call to police, ambulance, or insurance |
| 🔔 Notifications | Alerts for every status change and case update |
| 🔐 Biometric Login | Optional fingerprint / face ID for faster secure access |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Supabase |
| Database | PostgreSQL |
| Authentication | Supabase Auth |
| File Storage | Supabase Storage |
| State Management | Provider |
| Navigation | GoRouter |
| Location | Device GPS |

---

## Database Schema

```
user               — national_id, name, phone, dob, gender, auth_id
car                — car_registration_id, national_id, plate, vin, insurance...
accident           — accident_id, lat, long, status, join_code, date
accident_party     — party_id, accident_id, national_id, car_id, statement, role
accident_media     — media_id, accident_id, file_url, media_type
officer_report     — report_id, accident_id, file_url, officer_name, notes
```

---

## Security

- Row Level Security (RLS) enforced at the database level on every table
- Users can only access their own profile, vehicles, and accidents
- Accident data visible only to verified parties of that session
- Storage buckets are private — all file access requires authentication
- Officer reports can only be uploaded via the service role

---

## Project Structure

```
lib/
├── data/
│   ├── models/          # Data models (AccidentReport, etc.)
│   └── services/        # Supabase service classes
├── providers/           # State management (AuthProvider, ReportProvider)
├── screens/             # All app screens
│   ├── auth/            # Login, register, profile setup
│   ├── home/            # Home, notifications
│   ├── report/          # Accident reporting flow
│   ├── reports/         # Reports history
│   └── emergency/       # Emergency services
└── main.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK
- Supabase project
- Android / iOS device or emulator

### Setup

1. Clone the repo
```bash
git clone https://github.com/YOUSEFXP8/Janneb.git
cd Janneb
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Supabase — add your project URL and anon key to your Supabase client initialization

4. Run the app
```bash
flutter run
```

---

## Team

| Name | Role |
|------|------|
| Yousef Moaawia Yaequp | Flutter Developer |
| Abdullah | Database Administrator |
| Sohaib | UI/UX Designer |

---

## Status

**Active development** — built for the Crown Prince Foundation Prize 2026.

Core reporting flow, authentication, vehicle management, and backend are complete. Officer dashboard and final UI polish in progress.

---

> Built in Jordan, for Jordan. 🇯🇴
