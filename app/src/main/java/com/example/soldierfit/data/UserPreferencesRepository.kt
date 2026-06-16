package com.example.soldierfit.data

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.example.soldierfit.logic.MilitaryCoachLogic
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "user_preferences")

enum class MilitaryRank(val displayNameEn: String, val displayNameAr: String, val minXp: Int) {
    RECRUIT("Recruit", "مستجد", 0),
    PRIVATE("Private", "جندي", 500),
    CORPORAL("Corporal", "عريف", 1700),
    SERGEANT("Sergeant", "رقيب", 4200),
    LIEUTENANT("Lieutenant", "ملازم", 8500),
    CAPTAIN("Captain", "نقيب", 15000),
    MAJOR("Major", "رائد", 25000),
    COLONEL("Colonel", "عقيد", 45000),
    GENERAL("General", "فريق", 75000),
    ELITE_COMMANDER("Elite Commander", "قائد النخبة", 120000);

    companion object {
        fun fromXp(xp: Int): MilitaryRank {
            return entries.lastOrNull { xp >= it.minXp } ?: RECRUIT
        }
    }
}

class UserPreferencesRepository(private val context: Context) {
    private object PreferencesKeys {
        val THEME_MODE = stringPreferencesKey("theme_mode")
        val USE_METRIC = booleanPreferencesKey("use_metric")
        val USER_XP = intPreferencesKey("user_xp")
        val USER_COINS = intPreferencesKey("user_coins")
        val CURRENT_STREAK = intPreferencesKey("current_streak")
        val LAST_WORKOUT_DATE = longPreferencesKey("last_workout_date")
        val DAILY_MISSIONS_JSON = stringPreferencesKey("daily_missions")
        val COMPLETED_WORKOUTS_COUNT = intPreferencesKey("completed_workouts_count")
        val COMPLETED_PROGRAMS_COUNT = intPreferencesKey("completed_programs_count")
        val SEASON_XP = intPreferencesKey("season_xp")
        val UNLOCKED_BADGES_IDS = stringPreferencesKey("unlocked_badges_ids")
    }

    val userXp: Flow<Int> = context.dataStore.data.map { it[PreferencesKeys.USER_XP] ?: 0 }
    val seasonXp: Flow<Int> = context.dataStore.data.map { it[PreferencesKeys.SEASON_XP] ?: 0 }
    val unlockedBadgesIds: Flow<Set<String>> = context.dataStore.data.map { 
        it[PreferencesKeys.UNLOCKED_BADGES_IDS]?.split(",")?.toSet() ?: emptySet() 
    }
    val userCoins: Flow<Int> = context.dataStore.data.map { it[PreferencesKeys.USER_COINS] ?: 0 }
    val currentStreak: Flow<Int> = context.dataStore.data.map { it[PreferencesKeys.CURRENT_STREAK] ?: 0 }
    val dailyMissionsJson: Flow<String?> = context.dataStore.data.map { it[PreferencesKeys.DAILY_MISSIONS_JSON] }
    val completedWorkoutsCount: Flow<Int> = context.dataStore.data.map { it[PreferencesKeys.COMPLETED_WORKOUTS_COUNT] ?: 0 }
    val completedProgramsCount: Flow<Int> = context.dataStore.data.map { it[PreferencesKeys.COMPLETED_PROGRAMS_COUNT] ?: 0 }

    val userRank: Flow<MilitaryRank> = userXp.map { MilitaryCoachLogic.calculateRankFromXp(it) }

    val themeMode: Flow<String> = context.dataStore.data.map { preferences ->
        preferences[PreferencesKeys.THEME_MODE] ?: "system"
    }

    val useMetric: Flow<Boolean> = context.dataStore.data.map { preferences ->
        preferences[PreferencesKeys.USE_METRIC] ?: true
    }

    suspend fun setThemeMode(mode: String) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.THEME_MODE] = mode
        }
    }

    suspend fun setUseMetric(useMetric: Boolean) {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.USE_METRIC] = useMetric
        }
    }

    suspend fun addXp(amount: Int) {
        context.dataStore.edit { preferences ->
            val current = preferences[PreferencesKeys.USER_XP] ?: 0
            preferences[PreferencesKeys.USER_XP] = current + amount
            
            val currentSeason = preferences[PreferencesKeys.SEASON_XP] ?: 0
            preferences[PreferencesKeys.SEASON_XP] = currentSeason + amount
        }
    }

    suspend fun unlockBadge(badgeId: String) {
        context.dataStore.edit { preferences ->
            val current = preferences[PreferencesKeys.UNLOCKED_BADGES_IDS] ?: ""
            val ids = current.split(",").toMutableSet()
            if (ids.add(badgeId)) {
                preferences[PreferencesKeys.UNLOCKED_BADGES_IDS] = ids.joinToString(",")
            }
        }
    }

    suspend fun resetSeason() {
        context.dataStore.edit { preferences ->
            preferences[PreferencesKeys.SEASON_XP] = 0
        }
    }

    suspend fun addCoins(amount: Int) {
        context.dataStore.edit { preferences ->
            val current = preferences[PreferencesKeys.USER_COINS] ?: 0
            preferences[PreferencesKeys.USER_COINS] = current + amount
        }
    }

    suspend fun updateStreak(timestamp: Long) {
        context.dataStore.edit { preferences ->
            val lastDate = preferences[PreferencesKeys.LAST_WORKOUT_DATE] ?: 0L
            val currentStreak = preferences[PreferencesKeys.CURRENT_STREAK] ?: 0
            
            // Simplified streak logic: if last workout was yesterday, increment. 
            // If today, keep. Otherwise, reset to 1.
            // (In a real app, use calendar to check dates properly)
            val millisInDay = 24 * 60 * 60 * 1000
            val diff = timestamp - lastDate
            
            if (diff in (millisInDay + 1)..(2 * millisInDay)) {
                preferences[PreferencesKeys.CURRENT_STREAK] = currentStreak + 1
            } else if (diff > 2 * millisInDay) {
                preferences[PreferencesKeys.CURRENT_STREAK] = 1
            }
            preferences[PreferencesKeys.LAST_WORKOUT_DATE] = timestamp
        }
    }

    suspend fun completeMission(xpReward: Int) {
        addXp(xpReward)
    }

    suspend fun setDailyMissions(json: String) {
        context.dataStore.edit { it[PreferencesKeys.DAILY_MISSIONS_JSON] = json }
    }

    suspend fun incrementCompletedWorkouts() {
        context.dataStore.edit { preferences ->
            val current = preferences[PreferencesKeys.COMPLETED_WORKOUTS_COUNT] ?: 0
            preferences[PreferencesKeys.COMPLETED_WORKOUTS_COUNT] = current + 1
        }
    }

    suspend fun completeProgram() {
        context.dataStore.edit { preferences ->
            val currentCount = preferences[PreferencesKeys.COMPLETED_PROGRAMS_COUNT] ?: 0
            preferences[PreferencesKeys.COMPLETED_PROGRAMS_COUNT] = currentCount + 1
            
            val currentXp = preferences[PreferencesKeys.USER_XP] ?: 0
            preferences[PreferencesKeys.USER_XP] = currentXp + 1000
        }
    }
}
