package com.example.soldierfit.data.database

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "training_programs")
data class TrainingProgram(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val name: String,
    val description: String,
    val difficulty: String // e.g., Basic, Advanced, Elite
)
