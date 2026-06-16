package com.example.soldierfit.logic

import java.util.Calendar
import java.util.concurrent.TimeUnit

object SeasonManager {

    /**
     * Calculates the current season ID based on months since a fixed start date (e.g., Jan 2024).
     */
    fun getCurrentSeasonId(): Int {
        val startCalendar = Calendar.getInstance().apply {
            set(2024, Calendar.JANUARY, 1)
        }
        val currentCalendar = Calendar.getInstance()
        
        val diffMillis = currentCalendar.timeInMillis - startCalendar.timeInMillis
        val diffDays = TimeUnit.MILLISECONDS.toDays(diffMillis)
        
        return (diffDays / 30).toInt() + 1
    }

    /**
     * Calculates days remaining in the current 30-day season.
     */
    fun getDaysRemaining(): Int {
        val startCalendar = Calendar.getInstance().apply {
            set(2024, Calendar.JANUARY, 1)
        }
        val currentCalendar = Calendar.getInstance()
        val diffMillis = currentCalendar.timeInMillis - startCalendar.timeInMillis
        val diffDays = TimeUnit.MILLISECONDS.toDays(diffMillis)
        
        return (30 - (diffDays % 30)).toInt()
    }
}
