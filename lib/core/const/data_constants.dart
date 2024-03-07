import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/model/exercise_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/onboarding/widget/onboarding_title.dart';

class DataConstants {
  // Onboarding
  static final onboardingTiles = [
    OnboardingTitle(
      title: TextConstants.onboarding1Title,
      mainText: TextConstants.onboarding1Description,
      imagePath: PathConstants.onboarding1,
    ),
    OnboardingTitle(
      title: TextConstants.onboarding2Title,
      mainText: TextConstants.onboarding2Description,
      imagePath: PathConstants.onboarding2,
    ),
    OnboardingTitle(
      title: TextConstants.onboarding3Title,
      mainText: TextConstants.onboarding3Description,
      imagePath: PathConstants.onboarding3,
    ),
  ];

  // Workouts
  static final List<WorkoutModel> workouts = [
    WorkoutModel(
        id: 'workout1',
        title: TextConstants.yogaTitle,
        exercises: TextConstants.yogaExercises,
        minutes: TextConstants.yogaMinutes,
        currentProgress: 0,
        progress: 3,
        image: PathConstants.yoga,
        exerciseDataList: [
          ExerciseModel(
            id: 'exercise1',
            title: TextConstants.reclining,
            minutes: TextConstants.recliningMinutes,
            progress: 0,
            video: PathConstants.recliningVideo,
            description: TextConstants.warriorDescription,
            steps: [
              TextConstants.warriorStep1,
              TextConstants.warriorStep2,
              TextConstants.warriorStep1,
              TextConstants.warriorStep2,
              TextConstants.warriorStep1,
              TextConstants.warriorStep2,
            ],
          ),
          ExerciseModel(
            id: 'exercise2',
            title: TextConstants.cowPose,
            minutes: TextConstants.cowPoseMinutes,
            progress: 0,
            video: PathConstants.cowPoseVideo,
            description: TextConstants.warriorDescription,
            steps: [TextConstants.warriorStep1, TextConstants.warriorStep2],
          ),
          ExerciseModel(
            id: 'exercise3',
            title: TextConstants.warriorPose,
            minutes: TextConstants.warriorPoseMinutes,
            progress: 0,
            video: PathConstants.warriorIIVideo,
            description: TextConstants.warriorDescription,
            steps: [TextConstants.warriorStep1, TextConstants.warriorStep2],
          ),
        ]),
  ];

  //Home workout
  static final List<WorkoutModel> homeWorkouts = [
    WorkoutModel(
        id: 'workout1',
        title: TextConstants.cardioExercises,
        exercises: TextConstants.cardioTitle,
        minutes: TextConstants.cardioMinutes,
        currentProgress: 0,
        progress: 3,
        image: PathConstants.cardio,
        exerciseDataList: [
          ExerciseModel(
            id: 'exercise1',
            title: TextConstants.reclining,
            minutes: TextConstants.recliningMinutes,
            progress: 0,
            video: PathConstants.recliningVideo,
            description: TextConstants.warriorDescription,
            steps: [
              TextConstants.warriorStep1,
              TextConstants.warriorStep2,
              TextConstants.warriorStep1,
              TextConstants.warriorStep2,
              TextConstants.warriorStep1,
              TextConstants.warriorStep2,
            ],
          ),
          ExerciseModel(
            id: 'exercise2',
            title: TextConstants.cowPose,
            minutes: TextConstants.cowPoseMinutes,
            progress: 0,
            video: PathConstants.cowPoseVideo,
            description: TextConstants.warriorDescription,
            steps: [TextConstants.warriorStep1, TextConstants.warriorStep2],
          ),
          ExerciseModel(
            id: 'exercise3',
            title: TextConstants.warriorPose,
            minutes: TextConstants.warriorPoseMinutes,
            progress: 0,
            video: PathConstants.warriorIIVideo,
            description: TextConstants.warriorDescription,
            steps: [TextConstants.warriorStep1, TextConstants.warriorStep2],
          ),
        ]),
  ];

  // Reminder
  static List<String> reminderDays = [
    TextConstants.everyday,
    TextConstants.monday_friday,
    TextConstants.weekends,
    TextConstants.monday,
    TextConstants.tuesday,
    TextConstants.wednesday,
    TextConstants.thursday,
    TextConstants.friday,
    TextConstants.saturday,
    TextConstants.sunday,
  ];
}
