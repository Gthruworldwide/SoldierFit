package com.example.soldierfit.data.database

import androidx.room.TypeConverter

class Converters {
    @TypeConverter
    fun fromStringList(value: List<String>?): String? {
        return value?.joinToString(",")
    }

    @TypeConverter
    fun toStringList(value: String?): List<String>? {
        return value?.split(",")?.map { it.trim() }
    }

    @TypeConverter
    fun fromWorkoutRating(value: WorkoutRating?): String? {
        return value?.name
    }

    @TypeConverter
    fun toWorkoutRating(value: String?): WorkoutRating? {
        return value?.let { WorkoutRating.valueOf(it) }
    }

    @TypeConverter
    fun fromExerciseStage(value: ExerciseStage?): String? {
        return value?.name
    }

    @TypeConverter
    fun toExerciseStage(value: String?): ExerciseStage? {
        return value?.let { ExerciseStage.valueOf(it) }
    }

    @TypeConverter
    fun fromExerciseType(value: ExerciseType?): String? {
        return value?.name
    }

    @TypeConverter
    fun toExerciseType(value: String?): ExerciseType? {
        return value?.let { ExerciseType.valueOf(it) }
    }
}
