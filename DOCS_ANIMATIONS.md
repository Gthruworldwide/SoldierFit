# Adding New Exercise Animations

To add a new exercise animation to SoldierFit, follow these steps:

1.  **Obtain Lottie JSON**: Get the Lottie animation JSON file for the exercise.
2.  **Add to Assets**: Place the JSON file in `app/src/main/assets/animations/`.
    *   Example: `app/src/main/assets/animations/pushup.json`
3.  **Update Database**: Update the `exercises` table (or use the repository) to set the `animationFileName` field to the name of your file (e.g., `"pushup.json"`).
4.  **Localization**: Ensure you also provide `nameAr` and `descriptionAr` for Arabic support.

## Supported Exercises (Planned)
- pushup.json
- squat.json
- plank.json
- burpee.json
- jumping_jack.json
- mountain_climber.json
- lunges.json
- bicycle_crunch.json
- flutter_kick.json
- chair_squat.json

## Component Usage
The `ExerciseAnimation` composable handles the rendering:
```kotlin
ExerciseAnimation(
    animationFileName = "pushup.json",
    modifier = Modifier.size(100.dp)
)
```
