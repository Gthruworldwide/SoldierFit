package com.example.soldierfit.data.database

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface ProgramDao {
    @Query("SELECT * FROM training_programs")
    fun getAllPrograms(): Flow<List<TrainingProgram>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertProgram(program: TrainingProgram): Long

    @Delete
    suspend fun deleteProgram(program: TrainingProgram)
}
