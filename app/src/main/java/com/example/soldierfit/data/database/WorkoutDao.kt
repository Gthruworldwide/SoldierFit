package com.example.soldierfit.data.database

import androidx.room.*
import androidx.room.Transaction
import com.example.soldierfit.data.database.CoachInteraction
import kotlinx.coroutines.flow.Flow

@Dao
interface WorkoutDao {
    @Query("SELECT * FROM workouts ORDER BY timestamp DESC")
    fun getAllWorkouts(): Flow<List<Workout>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertWorkout(workout: Workout): Long

    @Delete
    suspend fun deleteWorkout(workout: Workout)

    @Transaction
    @Query("SELECT * FROM workouts WHERE id = :workoutId")
    fun getWorkoutWithExercises(workoutId: Long): Flow<WorkoutWithExercises>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertExercise(exercise: Exercise): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSet(set: ExerciseSet): Long

    @Query("SELECT * FROM exercises WHERE id = :id")
    fun getExerciseById(id: Long): Flow<Exercise?>

    @Query("""
        SELECT w.timestamp as date, MAX(s.weight) as maxWeight 
        FROM workouts w 
        JOIN exercises e ON w.id = e.workoutId 
        JOIN sets s ON e.id = s.exerciseId 
        WHERE e.name = :exerciseName 
        GROUP BY w.id 
        ORDER BY w.timestamp ASC
    """)
    fun getExerciseTrends(exerciseName: String): Flow<List<ExerciseStat>>

    // Coach Interactions
    @Insert
    suspend fun insertCoachInteraction(interaction: CoachInteraction)

    @Query("SELECT * FROM coach_interactions ORDER BY timestamp DESC LIMIT 5")
    fun getRecentInteractions(): Flow<List<CoachInteraction>>
}

data class ExerciseStat(
    val date: Long,
    val maxWeight: Double
)

data class WorkoutWithExercises(
    @Embedded val workout: Workout,
    @Relation(
        entity = Exercise::class,
        parentColumn = "id",
        entityColumn = "workoutId"
    )
    val exercises: List<ExerciseWithSets>
)

data class ExerciseWithSets(
    @Embedded val exercise: Exercise,
    @Relation(
        entity = ExerciseSet::class,
        parentColumn = "id",
        entityColumn = "exerciseId"
    )
    val sets: List<ExerciseSet>
)
