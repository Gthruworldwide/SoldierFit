package com.example.soldierfit.data

import com.example.soldierfit.data.database.ProgramDao
import com.example.soldierfit.data.database.TrainingProgram
import kotlinx.coroutines.flow.Flow

class ProgramRepository(private val programDao: ProgramDao) {
    val allPrograms: Flow<List<TrainingProgram>> = programDao.getAllPrograms()

    suspend fun insertProgram(program: TrainingProgram) {
        programDao.insertProgram(program)
    }

    suspend fun deleteProgram(program: TrainingProgram) {
        programDao.deleteProgram(program)
    }
}
