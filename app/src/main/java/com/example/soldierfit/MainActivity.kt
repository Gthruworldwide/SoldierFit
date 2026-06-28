package com.example.soldierfit

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Analytics
import androidx.compose.material.icons.filled.CameraAlt
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.List
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation3.runtime.NavEntry
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.runtime.rememberNavBackStack
import androidx.navigation3.ui.NavDisplay
import com.example.soldierfit.data.ProgramRepository
import com.example.soldierfit.data.UserPreferencesRepository
import com.example.soldierfit.data.WorkoutRepository
import com.example.soldierfit.data.database.AppDatabase
import com.example.soldierfit.data.database.DatabaseInitializer
import com.example.soldierfit.logic.CoachContext
import com.example.soldierfit.logic.MilitaryCoachLogic
import com.example.soldierfit.ui.components.CaptainFitCoach
import com.example.soldierfit.ui.components.XPGainText
import com.example.soldierfit.ui.screens.AnalyticsScreen
import com.example.soldierfit.ui.screens.CameraSessionScreen
import com.example.soldierfit.ui.screens.ExerciseDetailScreen
import com.example.soldierfit.ui.screens.MilitaryProfileScreen
import com.example.soldierfit.ui.screens.ProgramAdaptiveScreen
import com.example.soldierfit.ui.screens.RankLadderScreen
import com.example.soldierfit.ui.screens.WorkoutLoggingScreen
import com.example.soldierfit.ui.theme.SoldierFitTheme
import com.example.soldierfit.ui.viewmodels.ProgramViewModel
import com.example.soldierfit.ui.viewmodels.WorkoutViewModel
import kotlinx.serialization.Serializable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.background
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.BorderStroke
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.window.DialogProperties
import androidx.compose.foundation.border
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.soldierfit.data.MilitaryRank
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

@Serializable
object DashboardRoute : NavKey

@Serializable
object StartWorkoutRoute : NavKey

@Serializable
object TrainingPlansRoute : NavKey

@Serializable
object ProgressRoute : NavKey

@Serializable
object AiCoachRoute : NavKey

@Serializable
object AchievementsRoute : NavKey

@Serializable
object SettingsRoute : NavKey

@Serializable
data class ExerciseDetailRoute(val exerciseId: Long) : NavKey

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        val database = AppDatabase.getDatabase(this)
        val userPreferencesRepository = UserPreferencesRepository(this)
        val workoutRepository = WorkoutRepository(database.workoutDao(), userPreferencesRepository)
        val programRepository = ProgramRepository(database.programDao())

        // Initialize database with sample data
        GlobalScope.launch {
            DatabaseInitializer.initializeDatabase(database.programDao(), database.workoutDao())
        }

        setContent {
            SoldierFitTheme {
                val backStack = rememberNavBackStack(DashboardRoute)
                val userXp by userPreferencesRepository.userXp.collectAsStateWithLifecycle(initialValue = 0)
                val seasonXp by userPreferencesRepository.seasonXp.collectAsStateWithLifecycle(initialValue = 0)
                val unlockedBadgeIds by userPreferencesRepository.unlockedBadgesIds.collectAsStateWithLifecycle(initialValue = emptySet())
                val userRank by userPreferencesRepository.userRank.collectAsStateWithLifecycle(initialValue = MilitaryRank.RECRUIT)
                val userCoins by userPreferencesRepository.userCoins.collectAsStateWithLifecycle(initialValue = 0)
                val currentStreak by userPreferencesRepository.currentStreak.collectAsStateWithLifecycle(initialValue = 0)
                val completedWorkouts by userPreferencesRepository.completedWorkoutsCount.collectAsStateWithLifecycle(initialValue = 0)
                val completedPrograms by userPreferencesRepository.completedProgramsCount.collectAsStateWithLifecycle(initialValue = 0)
                
                var previousRank by remember { mutableStateOf<MilitaryRank?>(null) }
                var showPromotionDialog by remember { mutableStateOf(false) }
                var promotedTo by remember { mutableStateOf<MilitaryRank?>(null) }

                LaunchedEffect(userRank) {
                    if (previousRank != null && userRank.ordinal > previousRank!!.ordinal) {
                        promotedTo = userRank
                        showPromotionDialog = true
                    }
                    previousRank = userRank
                }

                if (showPromotionDialog && promotedTo != null) {
                    AlertDialog(
                        onDismissRequest = { showPromotionDialog = false },
                        confirmButton = {
                            Button(
                                onClick = { showPromotionDialog = false },
                                modifier = Modifier.fillMaxWidth(),
                                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.secondary)
                            ) {
                                Text("AT EASE, SOLDIER", fontWeight = FontWeight.Black)
                            }
                        },
                        properties = DialogProperties(usePlatformDefaultWidth = false),
                        modifier = Modifier.fillMaxSize().padding(16.dp),
                        title = { 
                            Text(
                                "🎖️ PROMOTION UNLOCKED", 
                                fontWeight = FontWeight.Black,
                                modifier = Modifier.fillMaxWidth(),
                                textAlign = TextAlign.Center
                            ) 
                        },
                        text = {
                            Column(
                                horizontalAlignment = Alignment.CenterHorizontally,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Box(
                                    modifier = Modifier
                                        .size(140.dp)
                                        .border(4.dp, MaterialTheme.colorScheme.secondary, CircleShape)
                                        .padding(8.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text("⭐", fontSize = 80.sp)
                                }
                                
                                Spacer(modifier = Modifier.height(24.dp))
                                
                                Text(
                                    text = "PROMOTED TO",
                                    style = MaterialTheme.typography.labelLarge,
                                    color = MaterialTheme.colorScheme.outline
                                )
                                Text(
                                    text = promotedTo!!.displayNameEn.uppercase(),
                                    style = MaterialTheme.typography.displayMedium,
                                    color = MaterialTheme.colorScheme.primary,
                                    fontWeight = FontWeight.Black
                                )
                                Text(
                                    text = promotedTo!!.displayNameAr,
                                    style = MaterialTheme.typography.headlineMedium,
                                    color = MaterialTheme.colorScheme.secondary
                                )

                                Spacer(modifier = Modifier.height(32.dp))
                                
                                XPGainText(targetXp = promotedTo!!.minXp)
                                
                                Spacer(modifier = Modifier.height(24.dp))
                                
                                CaptainFitCoach(message = "Outstanding performance! You've proven your worth in the field.")
                            }
                        }
                    )
                }

                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    bottomBar = {
                        val currentKey = backStack.lastOrNull()
                        if (currentKey !is ExerciseDetailRoute) {
                            NavigationBar {
                                NavigationBarItem(
                                    selected = currentKey is DashboardRoute,
                                    onClick = { if (currentKey !is DashboardRoute) backStack.add(DashboardRoute) },
                                    icon = { Icon(Icons.Default.Home, contentDescription = "Dashboard") },
                                    label = { Text("DASHBOARD") }
                                )
                                NavigationBarItem(
                                    selected = currentKey is StartWorkoutRoute,
                                    onClick = { if (currentKey !is StartWorkoutRoute) backStack.add(StartWorkoutRoute) },
                                    icon = { Icon(Icons.Default.FitnessCenter, contentDescription = "Start Workout") },
                                    label = { Text("WORKOUT") }
                                )
                                NavigationBarItem(
                                    selected = currentKey is TrainingPlansRoute,
                                    onClick = { if (currentKey !is TrainingPlansRoute) backStack.add(TrainingPlansRoute) },
                                    icon = { Icon(Icons.Default.List, contentDescription = "Training Plans") },
                                    label = { Text("PLANS") }
                                )
                                NavigationBarItem(
                                    selected = currentKey is ProgressRoute,
                                    onClick = { if (currentKey !is ProgressRoute) backStack.add(ProgressRoute) },
                                    icon = { Icon(Icons.Default.Analytics, contentDescription = "Progress") },
                                    label = { Text("PROGRESS") }
                                )
                                NavigationBarItem(
                                    selected = currentKey is AiCoachRoute,
                                    onClick = { if (currentKey !is AiCoachRoute) backStack.add(AiCoachRoute) },
                                    icon = { Icon(Icons.Default.CameraAlt, contentDescription = "AI Coach") },
                                    label = { Text("AI COACH") }
                                )
                            }
                        }
                    }
                ) { innerPadding ->
                    NavDisplay(
                        backStack = backStack,
                        modifier = Modifier.padding(innerPadding),
                        onBack = { if (backStack.size > 1) backStack.removeAt(backStack.size - 1) }
                    ) { key ->
                        when (key) {
                            is DashboardRoute -> NavEntry(key) { 
                                HomeScreen(
                                    rank = userRank,
                                    xp = userXp,
                                    coins = userCoins,
                                    streak = currentStreak,
                                    onRankLadderClick = { backStack.add(AchievementsRoute) }
                                ) 
                            }
                            is StartWorkoutRoute -> NavEntry(key) {
                                WorkoutLoggingScreen(
                                    onBack = { backStack.removeAt(backStack.size - 1) },
                                    onExerciseClick = { exerciseId ->
                                        backStack.add(ExerciseDetailRoute(exerciseId))
                                    }
                                )
                            }
                            is ExerciseDetailRoute -> NavEntry(key) {
                                val exercise by workoutRepository.getExerciseById(key.exerciseId)
                                    .collectAsStateWithLifecycle(initialValue = null)
                                exercise?.let {
                                    ExerciseDetailScreen(
                                        exercise = it,
                                        onBack = { backStack.removeAt(backStack.size - 1) }
                                    )
                                } ?: Box(
                                    modifier = Modifier.fillMaxSize(),
                                    contentAlignment = Alignment.Center
                                ) {
                                    CircularProgressIndicator()
                                }
                            }
                            is TrainingPlansRoute -> NavEntry(key) {
                                val viewModel: ProgramViewModel = viewModel { ProgramViewModel(programRepository) }
                                val programs by viewModel.programs.collectAsStateWithLifecycle()
                                ProgramAdaptiveScreen(
                                    programs = programs
                                )
                            }
                            is ProgressRoute -> NavEntry(key) {
                                val viewModel: WorkoutViewModel = viewModel { WorkoutViewModel(workoutRepository) }
                                val stats by viewModel.exerciseTrends.collectAsStateWithLifecycle()
                                val selectedExercise by viewModel.selectedExercise.collectAsStateWithLifecycle()
                                AnalyticsScreen(
                                    stats = stats,
                                    selectedExercise = selectedExercise,
                                    onExerciseSelected = { viewModel.selectExercise(it) }
                                )
                            }
                            is AiCoachRoute -> NavEntry(key) {
                                CameraSessionScreen()
                            }
                            is AchievementsRoute -> NavEntry(key) {
                                MilitaryProfileScreen(
                                    rank = userRank,
                                    xp = userXp,
                                    workouts = completedWorkouts,
                                    programs = completedPrograms,
                                    streak = currentStreak,
                                    seasonXp = seasonXp,
                                    unlockedBadgeIds = unlockedBadgeIds,
                                    onBack = { backStack.removeAt(backStack.size - 1) }
                                )
                            }
                            is SettingsRoute -> NavEntry(key) {
                                RankLadderScreen(
                                    currentRank = userRank,
                                    currentXp = userXp,
                                    onBack = { backStack.removeAt(backStack.size - 1) }
                                )
                            }
                            else -> NavEntry(key) { Text("Unknown Route") }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun HomeScreen(
    rank: MilitaryRank,
    xp: Int,
    coins: Int,
    streak: Int,
    onRankLadderClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Header
        Row(
            modifier = Modifier.fillMaxWidth().padding(bottom = 16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = "DAILY OPERATIONS",
                    style = MaterialTheme.typography.labelLarge,
                    fontWeight = FontWeight.Black,
                    color = MaterialTheme.colorScheme.primary
                )
                Text(
                    text = "JUNE 16, 2026", // Simulated date
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.outline
                )
            }
            
            Surface(
                color = MaterialTheme.colorScheme.secondaryContainer,
                shape = RoundedCornerShape(8.dp)
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    Text("🔥", fontSize = 16.sp)
                    Text(
                        text = "$streak DAY STREAK",
                        style = MaterialTheme.typography.labelMedium,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSecondaryContainer
                    )
                }
            }
        }

        CaptainFitCoach(
            message = MilitaryCoachLogic.getAdaptiveFeedback(
                CoachContext(
                    rank = rank,
                    xpEarned = 0, // In home, we just want a greeting or general feedback
                    totalXp = xp,
                    streakDays = streak,
                    missionTitle = "Today's Operations"
                )
            ),
            modifier = Modifier.padding(bottom = 16.dp)
        )

        // Rank Overview Card
        Card(
            modifier = Modifier.fillMaxWidth().padding(bottom = 24.dp),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
        ) {
            Row(
                modifier = Modifier.padding(16.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Surface(
                    modifier = Modifier.size(48.dp),
                    shape = CircleShape,
                    color = MaterialTheme.colorScheme.primary
                ) {
                    Box(contentAlignment = Alignment.Center) {
                        Text("⭐", fontSize = 24.sp)
                    }
                }
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = rank.displayNameEn.uppercase(),
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Black
                    )
                    Text(
                        text = "$xp XP COLLECTED",
                        style = MaterialTheme.typography.labelSmall
                    )
                }
                Button(
                    onClick = onRankLadderClick,
                    shape = RoundedCornerShape(4.dp),
                    contentPadding = PaddingValues(horizontal = 8.dp)
                ) {
                    Text("DOSSIER", fontSize = 10.sp)
                }
            }
        }

        Text(
            text = "ACTIVE MISSIONS",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Black,
            modifier = Modifier.fillMaxWidth().padding(bottom = 12.dp)
        )

        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            item {
                MissionCard(
                    title = "Operation: Iron Push",
                    description = "Perform 50 push-ups across 3 sets.",
                    reward = "120 XP",
                    difficulty = "MEDIUM",
                    progress = 0.7f
                )
            }
            item {
                MissionCard(
                    title = "Operation: Silent Plank",
                    description = "Maintain a 60-second plank.",
                    reward = "80 XP",
                    difficulty = "EASY",
                    progress = 0.0f
                )
            }
            item {
                MissionCard(
                    title = "Operation: Squat Storm",
                    description = "Perform 100 squats to build leg endurance.",
                    reward = "250 XP",
                    difficulty = "HARD",
                    progress = 0.3f
                )
            }
        }
    }
}

@Composable
fun MissionCard(
    title: String,
    description: String,
    reward: String,
    difficulty: String,
    progress: Float
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        border = if (progress >= 1.0f) BorderStroke(1.dp, MaterialTheme.colorScheme.secondary) else null
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = title.uppercase(),
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Black,
                    color = MaterialTheme.colorScheme.primary
                )
                Badge(
                    containerColor = when (difficulty) {
                        "HARD" -> Color(0xFFD32F2F)
                        "MEDIUM" -> Color(0xFFF57C00)
                        else -> Color(0xFF388E3C)
                    }
                ) {
                    Text(difficulty, color = Color.White)
                }
            }
            
            Text(
                text = description,
                style = MaterialTheme.typography.bodySmall,
                modifier = Modifier.padding(vertical = 8.dp)
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    LinearProgressIndicator(
                        progress = { progress },
                        modifier = Modifier.fillMaxWidth().height(4.dp),
                        color = MaterialTheme.colorScheme.secondary,
                        trackColor = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.1f)
                    )
                    Text(
                        text = "REWARD: $reward",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.secondary,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(top = 4.dp)
                    )
                }
                Spacer(modifier = Modifier.width(16.dp))
                Button(
                    onClick = { /* Start mission */ },
                    shape = RoundedCornerShape(4.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (progress >= 1.0f) Color.Gray else MaterialTheme.colorScheme.primary
                    )
                ) {
                    Text(if (progress >= 1.0f) "DONE" else if (progress > 0) "RESUME" else "START", fontSize = 12.sp)
                }
            }
        }
    }
}

@Composable
fun DashboardStatCard(label: String, value: String, modifier: Modifier = Modifier) {
    Card(
        modifier = modifier,
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(label, style = MaterialTheme.typography.labelSmall)
            Text(value, style = MaterialTheme.typography.titleLarge, color = MaterialTheme.colorScheme.onSecondaryContainer)
        }
    }
}
