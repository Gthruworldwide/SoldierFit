package com.example.soldierfit.logic

import com.example.soldierfit.data.database.ExerciseSet
import com.example.soldierfit.data.database.ExerciseType
import com.example.soldierfit.data.database.ExerciseWithSets
import com.example.soldierfit.data.database.WorkoutRating

object XpEngine {
    
    /**
     * Anti-cheat layer: Validates if the workout parameters are within realistic limits.
     */
    fun validateWorkout(reps: Int, durationMin: Int): Boolean {
        if (reps > 1000) return false
        if (durationMin > 180) return false
        return true
    }

    fun calculateSetXp(
        type: ExerciseType, 
        reps: Int, 
        weight: Double, 
        durationMinutes: Double,
        intensity: Float = 1.0f
    ): Int {
        var baseXP = when (type) {
            ExerciseType.STRENGTH -> {
                (reps * 2.2) + (weight * 0.1) // reps * 2.2 as per production spec
            }
            ExerciseType.CARDIO -> {
                (durationMinutes * 6.0) // duration * 6 as per production spec
            }
            ExerciseType.FLEXIBILITY -> {
                (durationMinutes * 3.5) // duration * 3.5 as per production spec
            }
        }

        // Apply intensity multiplier (1.0 - 2.0)
        baseXP *= intensity.toDouble()

        return baseXP.toInt()
    }

    fun calculateWorkoutXp(
        exercises: List<ExerciseWithSets>,
        rating: WorkoutRating,
        streakDays: Int,
        isHighDifficulty: Boolean
    ): Int {
        var totalXp = 0.0

        for (exerciseWithSets in exercises) {
            val type = exerciseWithSets.exercise.type
            val durationMin = (exerciseWithSets.exercise.durationSeconds ?: 0) / 60.0
            
            // Validate per-exercise for basic anti-cheat
            val totalReps = exerciseWithSets.sets.sumOf { it.reps }
            if (!validateWorkout(totalReps, durationMin.toInt())) continue

            for (set in exerciseWithSets.sets) {
                totalXp += calculateSetXp(
                    type = type, 
                    reps = set.reps, 
                    weight = set.weight, 
                    durationMinutes = durationMin,
                    intensity = if (isHighDifficulty) 1.5f else 1.0f
                )
            }
        }

        // Apply Rating Multiplier
        var finalMultiplier = rating.multiplier
        
        // Streak bonus: 1 + (streak * 0.03), capped at 1.25 (25% bonus)
        val streakBonus = (1.0 + (streakDays * 0.03)).coerceAtMost(1.25)
        finalMultiplier *= streakBonus.toFloat()

        // Complete without stopping bonus (simulated)
        finalMultiplier *= 1.1f

        return (totalXp * finalMultiplier).toInt()
    }
}
