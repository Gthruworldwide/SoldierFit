package com.example.soldierfit.data.database

import kotlinx.coroutines.flow.first

object DatabaseInitializer {
    
    suspend fun initializeDatabase(
        programDao: ProgramDao,
        workoutDao: WorkoutDao
    ) {
        // Check if programs already exist
        val existingPrograms = programDao.getAllPrograms().first()
        
        if (existingPrograms.isEmpty()) {
            // Add initial training programs
            val initialPrograms = listOf(
                TrainingProgram(
                    name = "Basic Bootcamp",
                    description = "Foundation training for new recruits. Focus on building strength and endurance through fundamental exercises.",
                    difficulty = "Basic"
                ),
                TrainingProgram(
                    name = "Advanced Tactical",
                    description = "Intensive combat-ready training. High-intensity drills and advanced techniques for elite soldiers.",
                    difficulty = "Advanced"
                ),
                TrainingProgram(
                    name = "Elite Special Ops",
                    description = "Maximum intensity program for special forces. Only for the most dedicated soldiers.",
                    difficulty = "Elite"
                ),
                TrainingProgram(
                    name = "Cardio Conditioning",
                    description = "Endurance-focused training to improve cardiovascular health and stamina.",
                    difficulty = "Basic"
                ),
                TrainingProgram(
                    name = "Strength Builder",
                    description = "Muscle and strength development program using progressive overload principles.",
                    difficulty = "Advanced"
                )
            )
            
            initialPrograms.forEach { program ->
                programDao.insertProgram(program)
            }
        }
    }
}
