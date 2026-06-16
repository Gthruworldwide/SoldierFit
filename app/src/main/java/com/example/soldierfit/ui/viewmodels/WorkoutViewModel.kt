package com.example.soldierfit.ui.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.soldierfit.data.WorkoutRepository
import com.example.soldierfit.data.database.Exercise
import com.example.soldierfit.data.database.ExerciseSet
import com.example.soldierfit.data.database.Workout
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import com.example.soldierfit.data.database.ExerciseStat
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch

class WorkoutViewModel(private val repository: WorkoutRepository) : ViewModel() {
    val workouts: StateFlow<List<Workout>> = repository.allWorkouts
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    private val _selectedExercise = MutableStateFlow("Squat")
    val selectedExercise = _selectedExercise.asStateFlow()

    @OptIn(kotlinx.coroutines.ExperimentalCoroutinesApi::class)
    val exerciseTrends: StateFlow<List<ExerciseStat>> = _selectedExercise
        .flatMapLatest { repository.getExerciseTrends(it) }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    fun selectExercise(name: String) {
        _selectedExercise.value = name
    }

    fun createWorkout(name: String) {
        viewModelScope.launch {
            repository.createWorkout(Workout(name = name, timestamp = System.currentTimeMillis()))
        }
    }
}
