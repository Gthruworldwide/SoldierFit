package com.example.soldierfit.data.database

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "coach_interactions")
data class CoachInteraction(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val timestamp: Long,
    val userMessage: String,
    val coachResponse: String,
    val contextSummary: String // e.g., "Rank: Sergeant, XP: 120, Streak: 5"
)
