package com.example.soldierfit.ui.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.soldierfit.data.ProgramRepository
import com.example.soldierfit.data.database.TrainingProgram
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn

class ProgramViewModel(private val repository: ProgramRepository) : ViewModel() {
    val programs: StateFlow<List<TrainingProgram>> = repository.allPrograms
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())
}
