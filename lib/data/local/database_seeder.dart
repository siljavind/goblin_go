import 'package:drift/drift.dart';

import 'app_database.dart';

class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedDatabaseForDemo() async {
    // Determine the start and end of the current day
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day); // Midnight today
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999); // End of today

    // Check if there are any sessions that started today
    final sessionsTodayExpression = db.outdoorSessions.startTime.isBetweenValues(startOfToday, endOfToday);
    final sessionsTodayQuery = db.select(db.outdoorSessions)..where((tbl) => sessionsTodayExpression);
    final existingSessionsToday = await sessionsTodayQuery.get();

    if (existingSessionsToday.isNotEmpty) {
      print("Database already contains sessions for today. Skipping demo seed.");
      return;
    }

    print("Clearing all existing data before seeding...");
    await clearAllData();

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
          startTime: DateTime.now().subtract(const Duration(hours: 4)),
          endTime: DateTime.now().subtract(const Duration(hours: 3, minutes: 50)),
          duration: const Duration(minutes: 10).inMinutes,
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

  // Helper to clear all data, if you decide to use it before seeding
  Future<void> clearAllData() async {
    print("Clearing all database data...");
    await db.transaction(() async {
      for (var table in db.allTables) {
        await db.delete(table).go();
      }
    });
    print("All data cleared.");
  }
}
