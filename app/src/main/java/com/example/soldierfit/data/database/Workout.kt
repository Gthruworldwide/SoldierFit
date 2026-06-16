package com.example.soldierfit.data.database

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

enum class WorkoutRating(val multiplier: Float, val displayName: String) {
    BRONZE(1.0f, "Bronze"),
    SILVER(1.2f, "Silver"),
    GOLD(1.5f, "Gold"),
    ELITE(2.0f, "Elite")
}

@Entity(
    tableName = "workouts",
    foreignKeys = [
        ForeignKey(
            entity = TrainingProgram::class,
            parentColumns = ["id"],
            childColumns = ["programId"],
            onDelete = ForeignKey.SET_NULL
        )
    ],
    indices = [Index(value = ["programId"])]
)
data class Workout(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val programId: Long? = null,
    val name: String,
    val timestamp: Long,
    val notes: String? = null,
    val rating: WorkoutRating? = null,
    val isCompleted: Boolean = false
)
