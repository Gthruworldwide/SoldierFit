package com.example.soldierfit.data

data class Badge(
    val id: String,
    val title: String,
    val description: String,
    val icon: String, // Emoji or resource ID
    val requirementDescription: String
)

object BadgeSystem {
    val ALL_BADGES = listOf(
        Badge("iron_soldier", "Iron Soldier", "Complete 1000 total reps", "🦾", "1000 Total Reps"),
        Badge("consistency_king", "Consistency King", "Maintain a 7-day streak", "👑", "7 Day Streak"),
        Badge("night_operative", "Night Operative", "Complete 3 workouts after 10 PM", "🌙", "3 Night Missions"),
        Badge("beast_mode", "Beast Mode", "Earn 500 XP in a single day", "👹", "500 XP in 1 Day")
    )

    fun checkUnlocks(
        totalReps: Int,
        currentStreak: Int,
        nightWorkouts: Int,
        maxDailyXp: Int
    ): List<Badge> {
        val unlocked = mutableListOf<Badge>()
        if (totalReps >= 1000) unlocked.add(ALL_BADGES[0])
        if (currentStreak >= 7) unlocked.add(ALL_BADGES[1])
        if (nightWorkouts >= 3) unlocked.add(ALL_BADGES[2])
        if (maxDailyXp >= 500) unlocked.add(ALL_BADGES[3])
        return unlocked
    }
}
