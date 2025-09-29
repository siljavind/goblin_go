import 'package:drift/drift.dart';

import 'app_database.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedDatabaseForDemo() async {
    // Check if data already exists to avoid re-seeding every time.
    // We can check one of the tables.
    final existingSessions = await db.select(db.outdoorSessions).get();
    if (existingSessions.isNotEmpty) {
      print("Database already contains data. Skipping demo seed.");
      return;
    }

    print("Seeding database with demo data...");

    // --- Seed OutdoorSessions ---
    // Using companions is often cleaner for inserts
    await db.batch((batch) {
      batch.insertAll(db.outdoorSessions, [
        OutdoorSessionsCompanion.insert(
          startTime: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
          endTime: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
          duration: const Duration(hours: 1).inMinutes, // Store duration in minutes
        ),
        OutdoorSessionsCompanion.insert(
          startTime: DateTime.now().subtract(const Duration(days: 3, hours: 1, minutes: 30)),
          endTime: DateTime.now().subtract(const Duration(days: 3, hours: 0, minutes: 45)),
          duration: const Duration(minutes: 45).inMinutes,
        ),
        OutdoorSessionsCompanion.insert(
          startTime: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
          endTime: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 30)),
          duration: const Duration(hours: 1, minutes: 30).inMinutes,
        ),
        // Add more sessions as needed
      ]);
    });

    // --- Seed DaySummaries ---
    // This will depend on how you calculate XP and streaks.
    // For a demo, you can hardcode some plausible values.
    // Remember dateId is YYYYMMDD integer.
    int dateToInt(DateTime dt) {
      return dt.year * 10000 + dt.month * 100 + dt.day;
    }

    await db.batch((batch) {
      batch.insertAll(db.daySummaries, [
        DaySummariesCompanion.insert(
          dateId: Value(dateToInt(DateTime.now().subtract(const Duration(days: 3)))),
          totalMinutes: 60,
          totalXp: 120, // Example XP
          streak: 1,     // Example streak
        ),
        DaySummariesCompanion.insert(
          dateId: Value(dateToInt(DateTime.now().subtract(const Duration(days: 2)))),
          totalMinutes: 45,
          totalXp: 90,
          streak: 2,
        ),
        DaySummariesCompanion.insert(
          dateId: Value(dateToInt(DateTime.now().subtract(const Duration(days: 1)))),
          totalMinutes: 90,
          totalXp: 180,
          streak: 3,
        ),
        // Add more summaries
      ]);
    });

    print("Demo database seeding complete.");
  }
}
