package com.example.soldierfit.ui.screens

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.soldierfit.data.database.ExerciseStat

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AnalyticsScreen(
    stats: List<ExerciseStat>,
    selectedExercise: String,
    onExerciseSelected: (String) -> Unit
) {
    val exercises = listOf("Squat", "Bench Press", "Deadlift", "Overhead Press")

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("PERFORMANCE TRENDS", fontWeight = FontWeight.Black) },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = MaterialTheme.colorScheme.background,
                    titleContentColor = MaterialTheme.colorScheme.primary
                )
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp)
        ) {
            LazyRow(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                items(exercises) { exercise ->
                    FilterChip(
                        selected = exercise == selectedExercise,
                        onClick = { onExerciseSelected(exercise) },
                        label = { Text(exercise.uppercase()) },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = MaterialTheme.colorScheme.primary,
                            selectedLabelColor = Color.Black
                        )
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            if (stats.isEmpty()) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text("NO DATA RECORDED FOR $selectedExercise", color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            } else {
                TacticalChart(stats)
            }
        }
    }
}

@Composable
fun TacticalChart(stats: List<ExerciseStat>) {
    val primaryColor = MaterialTheme.colorScheme.primary
    val gridColor = MaterialTheme.colorScheme.outlineVariant

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .height(300.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Box(modifier = Modifier.padding(16.dp)) {
            Canvas(modifier = Modifier.fillMaxSize()) {
                val width = size.width
                val height = size.height
                val maxWeight = stats.maxOf { it.maxWeight }.toFloat().coerceAtLeast(1f)
                val pointCount = stats.size

                // Draw Grid
                for (i in 0..5) {
                    val y = height - (i * height / 5)
                    drawLine(
                        color = gridColor,
                        start = Offset(0f, y),
                        end = Offset(width, y),
                        strokeWidth = 1f
                    )
                }

                // Draw Trend Line
                if (pointCount > 1) {
                    val path = Path()
                    stats.forEachIndexed { index, stat ->
                        val x = index * (width / (pointCount - 1))
                        val y = height - (stat.maxWeight.toFloat() / maxWeight * height)
                        if (index == 0) path.moveTo(x, y) else path.lineTo(x, y)
                        
                        drawCircle(
                            color = primaryColor,
                            radius = 6f,
                            center = Offset(x, y)
                        )
                    }
                    drawPath(
                        path = path,
                        color = primaryColor,
                        style = Stroke(width = 4f)
                    )
                } else if (pointCount == 1) {
                    val y = height - (stats[0].maxWeight.toFloat() / maxWeight * height)
                    drawCircle(
                        color = primaryColor,
                        radius = 8f,
                        center = Offset(width / 2, y)
                    )
                }
            }
        }
    }
}
