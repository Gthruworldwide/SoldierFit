package com.example.soldierfit.ui.components

import android.view.animation.OvershootInterpolator
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

@Composable
fun XPGainText(
    targetXp: Int,
    modifier: Modifier = Modifier
) {
    val xpValue = remember { Animatable(0f) }
    val scale = remember { Animatable(0.6f) }
    val offsetY = remember { Animatable(20f) }

    LaunchedEffect(targetXp) {
        launch {
            xpValue.animateTo(
                targetValue = targetXp.toFloat(),
                animationSpec = tween(durationMillis = 800, easing = FastOutSlowInEasing)
            )
        }
        launch {
            scale.animateTo(
                targetValue = 1.3f,
                animationSpec = tween(durationMillis = 600, easing = { OvershootInterpolator(2f).getInterpolation(it) })
            )
            scale.animateTo(1.0f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy))
        }
        launch {
            offsetY.animateTo(
                targetValue = 0f,
                animationSpec = tween(durationMillis = 700, easing = FastOutSlowInEasing)
            )
        }
    }

    Text(
        text = "+${xpValue.value.toInt()} XP",
        style = MaterialTheme.typography.displaySmall,
        color = Color(0xFFD4AF37), // Metallic Gold
        fontWeight = FontWeight.Black,
        modifier = modifier
            .graphicsLayer(
                scaleX = scale.value,
                scaleY = scale.value,
                translationY = offsetY.value
            )
    )
}
