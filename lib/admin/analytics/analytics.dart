import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ANALYTICS',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppTheme.neonGreen,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildCharts(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2,
      children: [
        _buildStatCard('Daily Active Users', '1,234', Icons.people, AppTheme.neonGreen),
        _buildStatCard('Total XP Earned', '45,678', Icons.star, AppTheme.gold),
        _buildStatCard('Missions Completed', '892', Icons.flag, AppTheme.primaryGreen),
        _buildStatCard('Avg Streak', '5.2 days', Icons.local_fire_department, AppTheme.warningOrange),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Row(
      children: [
        Expanded(
          child: _buildChartCard('XP Distribution', _buildXPChart()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildChartCard('Retention Rate', _buildRetentionChart()),
        ),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.militaryGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.neonGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildXPChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 30,
            color: AppTheme.neonGreen,
            title: '30%',
            radius: 50,
          ),
          PieChartSectionData(
            value: 25,
            color: AppTheme.gold,
            title: '25%',
            radius: 50,
          ),
          PieChartSectionData(
            value: 20,
            color: AppTheme.primaryGreen,
            title: '20%',
            radius: 50,
          ),
          PieChartSectionData(
            value: 15,
            color: AppTheme.warningOrange,
            title: '15%',
            radius: 50,
          ),
          PieChartSectionData(
            value: 10,
            color: AppTheme.alertRed,
            title: '10%',
            radius: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildRetentionChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 20),
              const FlSpot(1, 35),
              const FlSpot(2, 45),
              const FlSpot(3, 40),
              const FlSpot(4, 55),
              const FlSpot(5, 60),
            ],
            isCurved: true,
            color: AppTheme.neonGreen,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
