package com.example.soldierfit.logic

import com.example.soldierfit.data.MilitaryRank

enum class CoachState {
    WEAK_PERFORMANCE, NORMAL, HIGH_PERFORMANCE, STREAK_MODE, RANK_UP_MODE
}

data class CoachContext(
    val rank: MilitaryRank,
    val xpEarned: Int,
    val totalXp: Int,
    val streakDays: Int,
    val missionTitle: String = ""
)

object MilitaryCoachLogic {

    fun buildPrompt(context: CoachContext): String {
        return """
            You are a military fitness coach.
            User rank: ${context.rank.displayNameEn}
            XP earned: ${context.xpEarned}
            Total XP: ${context.totalXp}
            Streak: ${context.streakDays}
            Mission: ${context.missionTitle}
            
            Respond like a strict but motivating drill instructor.
            Keep response under 2 sentences.
        """.trimIndent()
    }

    fun getAdaptiveFeedback(context: CoachContext): String {
        // High-level decision engine (Mismatches between XP and Rank)
        return when {
            context.xpEarned < 50 -> "❌ Execution failure on ${context.missionTitle}. Repeat mission with higher intensity, Recruit!"
            context.streakDays >= 7 -> "🔥 Discipline locked. Soldier mode active for ${context.streakDays} days straight! Command approves."
            context.rank.ordinal >= MilitaryRank.CAPTAIN.ordinal -> "⚠️ High rank detected. Precision and leadership are non-negotiable at your level."
            context.xpEarned > 200 -> "✔ Strong performance. You're showing the grit required for the ${MilitaryRank.entries.getOrNull(context.rank.ordinal + 1)?.displayNameEn ?: "next level"}."
            else -> "✔ Mission recorded. Maintain your pace, Soldier."
        }
    }

    /**
     * Non-linear Rank Progression Logic
     * Returns the rank based on total XP using a progressive 1.35x multiplier
     */
    fun calculateRankFromXp(totalXp: Int): MilitaryRank {
        val ranks = MilitaryRank.entries
        var currentXpPool = totalXp
        var level = 0
        var xpNeededForNext = 500

        while (currentXpPool >= xpNeededForNext && level < ranks.size - 1) {
            currentXpPool -= xpNeededForNext
            level++
            xpNeededForNext = (xpNeededForNext * 1.35).toInt()
        }

        return ranks[level]
    }
}
