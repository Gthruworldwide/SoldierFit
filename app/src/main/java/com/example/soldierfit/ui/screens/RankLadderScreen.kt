package com.example.soldierfit.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.soldierfit.data.MilitaryRank

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RankLadderScreen(
    currentRank: MilitaryRank,
    currentXp: Int,
    onBack: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("RANK PROGRESSION", fontWeight = FontWeight.Black) },
                colors = TopAppBarDefaults.topAppBarColors(
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
                .background(MaterialTheme.colorScheme.background)
        ) {
            // Header Stats
            RankHeader(currentRank, currentXp)

            Spacer(modifier = Modifier.height(16.dp))

            // Rank Ladder
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 24.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp),
                contentPadding = PaddingValues(bottom = 32.dp)
            ) {
                items(MilitaryRank.entries) { rank ->
                    RankLadderItem(
                        rank = rank,
                        isCurrent = rank == currentRank,
                        isUnlocked = currentXp >= rank.minXp
                    )
                }
            }
        }
    }
}

@Composable
fun RankHeader(rank: MilitaryRank, xp: Int) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant),
        shape = RoundedCornerShape(12.dp)
    ) {
        Row(
            modifier = Modifier.padding(24.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            // Progress Ring Simulation
            Box(contentAlignment = Alignment.Center) {
                val nextRank = MilitaryRank.entries.getOrNull(rank.ordinal + 1)
                val progress = if (nextRank != null) {
                    val range = nextRank.minXp - rank.minXp
                    (xp - rank.minXp).toFloat() / range.toFloat()
                } else 1.0f

                CircularProgressIndicator(
                    progress = { progress },
                    modifier = Modifier.size(80.dp),
                    strokeWidth = 8.dp,
                    color = MaterialTheme.colorScheme.secondary,
                    trackColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.2f)
                )
                Text(
                    text = "${(progress * 100).toInt()}%",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Black
                )
            }

            Column {
                Text(
                    text = rank.displayNameEn.uppercase(),
                    style = MaterialTheme.typography.headlineMedium,
                    fontWeight = FontWeight.Black,
                    color = MaterialTheme.colorScheme.primary
                )
                Text(
                    text = "$xp XP COLLECTED",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
fun RankLadderItem(
    rank: MilitaryRank,
    isCurrent: Boolean,
    isUnlocked: Boolean
) {
    val backgroundColor = when {
        isCurrent -> MaterialTheme.colorScheme.primaryContainer
        isUnlocked -> MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
        else -> MaterialTheme.colorScheme.surface.copy(alpha = 0.3f)
    }

    val borderColor = when {
        isCurrent -> MaterialTheme.colorScheme.secondary
        isUnlocked -> MaterialTheme.colorScheme.primary.copy(alpha = 0.5f)
        else -> Color.Transparent
    }

    val contentColor = when {
        isUnlocked -> MaterialTheme.colorScheme.onSurface
        else -> MaterialTheme.colorScheme.onSurface.copy(alpha = 0.4f)
    }

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(backgroundColor)
            .border(2.dp, borderColor, RoundedCornerShape(8.dp))
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Icon
        Surface(
            modifier = Modifier.size(40.dp),
            shape = CircleShape,
            color = if (isUnlocked) MaterialTheme.colorScheme.primary else Color.Gray.copy(alpha = 0.5f)
        ) {
            Box(contentAlignment = Alignment.Center) {
                if (isUnlocked) {
                    Icon(Icons.Default.Star, contentDescription = null, tint = Color.Black)
                } else {
                    Icon(Icons.Default.Lock, contentDescription = null, tint = Color.White, modifier = Modifier.size(20.dp))
                }
            }
        }

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = rank.displayNameEn.uppercase(),
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = contentColor
            )
            Text(
                text = rank.displayNameAr,
                style = MaterialTheme.typography.bodySmall,
                color = contentColor.copy(alpha = 0.7f)
            )
        }

        Text(
            text = "${rank.minXp} XP",
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold,
            color = if (isUnlocked) MaterialTheme.colorScheme.secondary else Color.Gray
        )
    }
}
