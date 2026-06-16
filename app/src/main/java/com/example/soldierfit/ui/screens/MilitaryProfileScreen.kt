package com.example.soldierfit.ui.screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Badge
import androidx.compose.material.icons.filled.FitnessCenter
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Stars
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.soldierfit.data.Badge
import com.example.soldierfit.data.BadgeSystem
import com.example.soldierfit.data.MilitaryRank
import com.example.soldierfit.ui.components.MilitaryIDCard

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MilitaryProfileScreen(
    rank: MilitaryRank,
    xp: Int,
    workouts: Int,
    programs: Int,
    streak: Int = 0,
    seasonXp: Int = 0,
    unlockedBadgeIds: Set<String> = emptySet(),
    onBack: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("MILITARY DOSSIER", fontWeight = FontWeight.Black) }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            MilitaryIDCard(
                rank = rank,
                xp = xp,
                streak = streak,
                userName = "Operator"
            )

            Spacer(modifier = Modifier.height(24.dp))

            Button(
                onClick = { /* Share logic */ },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp)
            ) {
                Icon(Icons.Default.Stars, contentDescription = null)
                Spacer(modifier = Modifier.width(8.dp))
                Text("SHARE MILITARY DOSSIER", fontWeight = FontWeight.Bold)
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Stats Grid
            Row(modifier = Modifier.fillMaxWidth()) {
                ProfileStatCard(
                    icon = Icons.Default.Stars,
                    label = "TOTAL XP",
                    value = xp.toString(),
                    modifier = Modifier.weight(1f)
                )
                ProfileStatCard(
                    icon = Icons.Default.FitnessCenter,
                    label = "WORKOUTS",
                    value = workouts.toString(),
                    modifier = Modifier.weight(1f)
                )
            }
            Row(modifier = Modifier.fillMaxWidth()) {
                ProfileStatCard(
                    icon = Icons.Default.List,
                    label = "PROGRAMS",
                    value = programs.toString(),
                    modifier = Modifier.weight(1f)
                )
                ProfileStatCard(
                    icon = Icons.Default.Badge,
                    label = "HONORS",
                    value = unlockedBadgeIds.size.toString(),
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Season Progress
            Text(
                text = "SEASON 1 PROGRESS",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Black,
                modifier = Modifier.fillMaxWidth()
            )
            Card(
                modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("BATTLE PASS LVL ${ (seasonXp / 500) + 1 }", fontWeight = FontWeight.Bold)
                        Text("$seasonXp / 500 XP")
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                    LinearProgressIndicator(
                        progress = { (seasonXp % 500) / 500f },
                        modifier = Modifier.fillMaxWidth(),
                        color = MaterialTheme.colorScheme.secondary
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Badges Gallery
            Text(
                text = "MILITARY HONORS",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Black,
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(12.dp))
            
            val unlockedBadges = BadgeSystem.ALL_BADGES.filter { it.id in unlockedBadgeIds }
            
            if (unlockedBadges.isEmpty()) {
                Text(
                    "No honors earned yet. Continue your service.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.outline,
                    modifier = Modifier.fillMaxWidth().padding(vertical = 16.dp)
                )
            } else {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    unlockedBadges.forEach { badge ->
                        BadgeIcon(badge)
                    }
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Rewards Section
            Text(
                text = "BATTLE PASS REWARDS",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Black,
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(8.dp))
            
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                RewardItem(level = 1, title = "Tactical Skin: Forest", isUnlocked = seasonXp >= 100)
                RewardItem(level = 5, title = "Badge: Night Operative", isUnlocked = seasonXp >= 2500)
                RewardItem(level = 10, title = "Mission: Elite Stealth", isUnlocked = seasonXp >= 5000)
            }

            Spacer(modifier = Modifier.height(32.dp))

            Text(
                text = "SERVICE RECORD",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.fillMaxWidth()
            )
            
            // Placeholder for service record items
            repeat(3) {
                Card(
                    modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
                ) {
                    ListItem(
                        headlineContent = { Text("Promotion to ${rank.displayNameEn}") },
                        supportingContent = { Text("Service date: 2026-06-16") },
                        leadingContent = { Icon(Icons.Default.Stars, contentDescription = null) }
                    )
                }
            }
        }
    }
}

@Composable
fun BadgeIcon(badge: Badge) {
    Surface(
        modifier = Modifier.size(64.dp),
        shape = CircleShape,
        color = MaterialTheme.colorScheme.surfaceVariant,
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.secondary)
    ) {
        Box(contentAlignment = Alignment.Center) {
            Text(badge.icon, fontSize = 32.sp)
        }
    }
}

@Composable
fun RewardItem(level: Int, title: String, isUnlocked: Boolean) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = if (isUnlocked) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface
        )
    ) {
        ListItem(
            headlineContent = { Text("LVL $level: $title", fontWeight = FontWeight.Bold) },
            leadingContent = {
                Icon(
                    if (isUnlocked) Icons.Default.Stars else Icons.Default.Lock,
                    contentDescription = null,
                    tint = if (isUnlocked) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.outline
                )
            },
            colors = ListItemDefaults.colors(containerColor = Color.Transparent)
        )
    }
}

@Composable
fun ProfileStatCard(
    icon: ImageVector,
    label: String,
    value: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.padding(8.dp),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.primary)
            Spacer(modifier = Modifier.height(8.dp))
            Text(label, style = MaterialTheme.typography.labelSmall)
            Text(value, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Black)
        }
    }
}
