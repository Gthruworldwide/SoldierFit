package com.example.soldierfit.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Stars
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.example.soldierfit.data.MilitaryRank
import com.example.soldierfit.data.database.ExerciseWithSets
import com.example.soldierfit.data.database.ExerciseSet
import com.example.soldierfit.logic.CoachContext
import com.example.soldierfit.logic.MilitaryCoachLogic
import com.example.soldierfit.ui.components.CaptainFitCoach
import com.example.soldierfit.ui.components.ExerciseAnimation

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WorkoutLoggingScreen(
    onBack: () -> Unit,
    onExerciseClick: (Long) -> Unit
) {
    var workoutName by remember { mutableStateOf("MISSION: STRENGTH") }
    val exercises = remember { mutableStateListOf<ExerciseWithSets>() }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text(workoutName, fontWeight = FontWeight.Bold) },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background,
                    titleContentColor = MaterialTheme.colorScheme.primary
                ),
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        },
        floatingActionButton = {
            ExtendedFloatingActionButton(
                onClick = { /* Complete mission logic */ },
                containerColor = MaterialTheme.colorScheme.primary,
                contentColor = MaterialTheme.colorScheme.onPrimary,
                icon = { Icon(Icons.Default.Stars, contentDescription = null) },
                text = { Text("COMPLETE MISSION", fontWeight = FontWeight.Bold) }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item {
                CaptainFitCoach(
                    message = MilitaryCoachLogic.getAdaptiveFeedback(
                        CoachContext(
                            rank = MilitaryRank.RECRUIT, // TODO: Pass actual rank
                            xpEarned = 100, // Placeholder
                            totalXp = 0,
                            streakDays = 5,
                            missionTitle = "Mission Log"
                        )
                    )
                )
            }
            item {
                Text(
                    text = "MISSION ORDERS",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.secondary,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                OutlinedTextField(
                    value = workoutName,
                    onValueChange = { workoutName = it },
                    label = { Text("MISSION CODE NAME") },
                    modifier = Modifier.fillMaxWidth(),
                    textStyle = MaterialTheme.typography.headlineSmall.copy(fontWeight = FontWeight.Bold)
                )
            }

            items(exercises) { exercise ->
                ExerciseCard(exercise, onClick = { onExerciseClick(exercise.exercise.id) })
            }

            item {
                Spacer(modifier = Modifier.height(80.dp)) // FAB spacing
            }
        }
    }
}

@Composable
fun ExerciseCard(exerciseWithSets: ExerciseWithSets, onClick: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        shape = RoundedCornerShape(8.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = exerciseWithSets.exercise.name.uppercase(),
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.ExtraBold,
                        color = MaterialTheme.colorScheme.primary
                    )
                    exerciseWithSets.exercise.nameAr?.let {
                        Text(
                            text = it,
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.secondary
                        )
                    }
                }

                exerciseWithSets.exercise.animationFileName?.let { fileName ->
                    ExerciseAnimation(
                        animationFileName = fileName,
                        modifier = Modifier.size(100.dp)
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(8.dp))

            exerciseWithSets.exercise.description?.let {
                Text(
                    text = it,
                    style = MaterialTheme.typography.bodySmall,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
            }

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                exerciseWithSets.exercise.reps?.let {
                    InfoBadge(label = "REPS", value = it.toString())
                }
                exerciseWithSets.exercise.durationSeconds?.let {
                    InfoBadge(label = "TIME", value = "${it}s")
                }
                exerciseWithSets.exercise.difficulty?.let {
                    InfoBadge(label = "LEVEL", value = it)
                }
            }

            exerciseWithSets.exercise.targetMuscles?.let { muscles ->
                Text(
                    text = "TARGET: ${muscles.joinToString(", ")}",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.outline,
                    modifier = Modifier.padding(top = 8.dp)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            exerciseWithSets.sets.forEachIndexed { index, set ->
                SetRow(index + 1, set)
            }

            Button(
                onClick = { /* Add set logic */ },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.secondary)
            ) {
                Text("ADD SET")
            }
        }
    }
}

@Composable
fun InfoBadge(label: String, value: String) {
    Surface(
        color = MaterialTheme.colorScheme.primaryContainer,
        shape = RoundedCornerShape(4.dp)
    ) {
        Column(modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp), horizontalAlignment = Alignment.CenterHorizontally) {
            Text(label, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.onPrimaryContainer)
            Text(value, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.onPrimaryContainer)
        }
    }
}

@Composable
fun SetRow(setNumber: Int, set: ExerciseSet) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(
            text = "#$setNumber",
            style = MaterialTheme.typography.bodyLarge,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.width(32.dp)
        )

        OutlinedTextField(
            value = set.weight.toString(),
            onValueChange = { },
            label = { Text("KG") },
            modifier = Modifier.weight(1f),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
        )

        OutlinedTextField(
            value = set.reps.toString(),
            onValueChange = { },
            label = { Text("REPS") },
            modifier = Modifier.weight(1f),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
        )

        IconButton(onClick = { }) {
            Icon(Icons.Default.Delete, contentDescription = "Delete Set", tint = MaterialTheme.colorScheme.error)
        }
    }
}
