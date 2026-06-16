package com.example.soldierfit.data.database

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

enum class ExerciseStage {
    WARMUP, MAIN, COOLDOWN
}

enum class ExerciseType {
    STRENGTH, CARDIO, FLEXIBILITY
}

@Entity(
    tableName = "exercises",
    foreignKeys = [
        ForeignKey(
            entity = Workout::class,
            parentColumns = ["id"],
            childColumns = ["workoutId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index(value = ["workoutId"])]
)
data class Exercise(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val workoutId: Long,
    val name: String,
    val nameAr: String? = null,
    val description: String? = null,
    val descriptionAr: String? = null,
    val animationFileName: String? = null,
    val targetMuscles: List<String>? = null,
    val difficulty: String? = null,
    val reps: Int? = null,
    val durationSeconds: Int? = null,
    val order: Int,
    val stage: ExerciseStage = ExerciseStage.MAIN,
    val type: ExerciseType = ExerciseType.STRENGTH
)
