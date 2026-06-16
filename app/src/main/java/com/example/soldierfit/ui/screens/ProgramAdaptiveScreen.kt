package com.example.soldierfit.ui.screens

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.material3.adaptive.ExperimentalMaterial3AdaptiveApi
import androidx.compose.material3.adaptive.layout.ListDetailPaneScaffold
import androidx.compose.material3.adaptive.layout.ListDetailPaneScaffoldRole
import androidx.compose.material3.adaptive.navigation.rememberListDetailPaneScaffoldNavigator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.example.soldierfit.data.database.TrainingProgram
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3AdaptiveApi::class)
@Composable
fun ProgramAdaptiveScreen(
    programs: List<TrainingProgram>
) {
    val navigator = rememberListDetailPaneScaffoldNavigator<TrainingProgram>()
    val scope = rememberCoroutineScope()

    BackHandler(navigator.canNavigateBack()) {
        scope.launch {
            navigator.navigateBack()
        }
    }

    ListDetailPaneScaffold(
        directive = navigator.scaffoldDirective,
        value = navigator.scaffoldValue,
        listPane = {
            ProgramListScreen(
                programs = programs,
                onProgramClick = { program ->
                    scope.launch {
                        navigator.navigateTo(ListDetailPaneScaffoldRole.Detail, program)
                    }
                }
            )
        },
        detailPane = {
            val content = navigator.currentDestination?.contentKey
            if (content != null) {
                ProgramDetail(program = content)
            } else {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text("SELECT A PROGRAM", style = MaterialTheme.typography.titleLarge)
                }
            }
        }
    )
}

@Composable
fun ProgramDetail(program: TrainingProgram) {
    Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(32.dp)
        ) {
            Text(
                text = program.name.uppercase(),
                style = MaterialTheme.typography.displaySmall,
                fontWeight = FontWeight.Black,
                color = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.height(16.dp))
            Badge(
                containerColor = when(program.difficulty) {
                    "Elite" -> MaterialTheme.colorScheme.error
                    "Advanced" -> MaterialTheme.colorScheme.tertiary
                    else -> MaterialTheme.colorScheme.secondary
                }
            ) {
                Text(program.difficulty.uppercase(), color = androidx.compose.ui.graphics.Color.Black, modifier = Modifier.padding(horizontal = 8.dp))
            }
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "OPERATIONAL INTEL",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.secondary
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = program.description,
                style = MaterialTheme.typography.bodyLarge
            )
            Spacer(modifier = Modifier.height(32.dp))
            Button(
                onClick = { /* Start program */ },
                modifier = Modifier.fillMaxWidth(),
                shape = androidx.compose.foundation.shape.CutCornerShape(8.dp)
            ) {
                Text("DEPLOY MISSION", fontWeight = FontWeight.Bold)
            }
        }
    }
}
