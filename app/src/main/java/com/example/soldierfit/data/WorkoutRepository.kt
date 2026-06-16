package com.example.soldierfit.data

import com.example.soldierfit.data.database.Exercise
import com.example.soldierfit.data.database.ExerciseSet
import com.example.soldierfit.data.database.Workout
import com.example.soldierfit.data.database.WorkoutDao
import com.example.soldierfit.data.database.WorkoutWithExercises
import com.example.soldierfit.data.database.WorkoutRating
import com.example.soldierfit.logic.XpEngine
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first

class WorkoutRepository(
    private val workoutDao: WorkoutDao,
    private val userPreferencesRepository: UserPreferencesRepository
) {
    val allWorkouts: Flow<List<Workout>> = workoutDao.getAllWorkouts()

    fun getWorkoutWithExercises(workoutId: Long): Flow<WorkoutWithExercises> {
        return workoutDao.getWorkoutWithExercises(workoutId)
    }

    suspend fun createWorkout(workout: Workout): Long {
        val id = workoutDao.insertWorkout(workout)
        userPreferencesRepository.addXp(50) // Reward for starting/finishing workout (simplified)
        userPreferencesRepository.updateStreak(workout.timestamp)
        return id
    }

    suspend fun addExercise(exercise: Exercise): Long {
        return workoutDao.insertExercise(exercise)
    }

    suspend fun addSet(set: ExerciseSet): Long {
        val id = workoutDao.insertSet(set)
        // Set individual XP can still be added or we can wait for workout completion
        userPreferencesRepository.addXp(5) 
        return id
    }

    suspend fun completeWorkout(workoutId: Long, rating: WorkoutRating, isHighDifficulty: Boolean = false) {
        val workoutWithExercises = workoutDao.getWorkoutWithExercises(workoutId).first()
        val streakDays = userPreferencesRepository.currentStreak.first()
        
        val earnedXp = XpEngine.calculateWorkoutXp(
            exercises = workoutWithExercises.exercises,
            rating = rating,
            streakDays = streakDays,
            isHighDifficulty = isHighDifficulty
        )

        userPreferencesRepository.addXp(earnedXp)
        userPreferencesRepository.incrementCompletedWorkouts()
    }

    suspend fun deleteWorkout(workout: Workout) {
        workoutDao.deleteWorkout(workout)
    }

    fun getExerciseTrends(exerciseName: String) = workoutDao.getExerciseTrends(exerciseName)

    fun getExerciseById(id: Long): Flow<Exercise?> {
        return workoutDao.getExerciseById(id)
    }
}
