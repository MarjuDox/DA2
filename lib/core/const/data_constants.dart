import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/model/exercise_model.dart';
import 'package:diabetes/model/workout_model.dart';
import 'package:diabetes/screens/onboarding/widget/onboarding_title.dart';

class DataConstants {
  // Onboarding
  static final onboardingTiles = [
    const OnboardingTitle(
      title: TextConstants.onboarding1Title,
      mainText: TextConstants.onboarding1Description,
      imagePath: PathConstants.onboarding1,
    ),
    const OnboardingTitle(
      title: TextConstants.onboarding2Title,
      mainText: TextConstants.onboarding2Description,
      imagePath: PathConstants.onboarding2,
    ),
    const OnboardingTitle(
      title: TextConstants.onboarding3Title,
      mainText: TextConstants.onboarding3Description,
      imagePath: PathConstants.onboarding3,
    ),
  ];

  // Workouts
  static final List<WorkoutModel> workouts = [
    WorkoutModel(
        id: 'yoga1',
        title: TextConstants.yogaTitle1,
        exercises: TextConstants.yogaExercises1,
        minutes: TextConstants.yogaMinutes1,
        currentProgress: 0,
        progress: 5,
        image: PathConstants.yoga,
        exerciseDataList: [
          ExerciseModel(
            id: 'downdogwalk',
            title: TextConstants.downDogWalk,
            minutes: TextConstants.downDogWalkMinutes,
            seconds: TextConstants.downDogWalkSeconds,
            progress: 0,
            video: PathConstants.downDogWalk,
            description: TextConstants.downDogWalkDescription,
            steps: [
              TextConstants.downDogWalkStep1,
              TextConstants.downDogWalkStep2,
              TextConstants.downDogWalkStep3,
              TextConstants.downDogWalkStep4,
            ],
          ),
          ExerciseModel(
            id: 'downdogwave',
            title: TextConstants.downDogWave,
            minutes: TextConstants.downDogWaveMinutes,
            seconds: TextConstants.downDogWalkSeconds,
            progress: 0,
            video: PathConstants.downDogWave,
            description: TextConstants.downDogWaveDescription,
            steps: [
              TextConstants.downDogWaveStep1,
              TextConstants.downDogWaveStep2,
              TextConstants.downDogWaveStep3,
              TextConstants.downDogWaveStep4,
            ],
          ),
          ExerciseModel(
            id: 'lungeHoldleftleg',
            title: TextConstants.lungeHoldLeftLeg,
            minutes: TextConstants.lungeHoldLeftLegMinutes,
            seconds: TextConstants.lungeHoldLeftLegSeconds,
            progress: 0,
            video: PathConstants.lungeHoldLeftLeg,
            description: TextConstants.lungeHoldLeftLegDescription,
            steps: [
              TextConstants.lungeHoldLeftLegStep1,
              TextConstants.lungeHoldLeftLegStep2,
              TextConstants.lungeHoldLeftLegStep3,
              TextConstants.lungeHoldLeftLegStep4,
              TextConstants.lungeHoldLeftLegStep5,
              TextConstants.lungeHoldLeftLegStep6,
              TextConstants.lungeHoldLeftLegStep7,
            ],
          ),
          ExerciseModel(
            id: 'siderotation',
            title: TextConstants.sideRotation,
            minutes: TextConstants.sideRotationMinutes,
            seconds: TextConstants.sideRotationSeconds,
            progress: 0,
            video: PathConstants.sideRotation,
            description: TextConstants.sideRotationDescription,
            steps: [
              TextConstants.sideRotationStep1, 
              TextConstants.sideRotationStep2, 
              TextConstants.sideRotationStep3, 
              TextConstants.sideRotationStep4,],
          ),
          ExerciseModel(
            id: 'warriorstretchrightside',
            title: TextConstants.warriorStretchRightSide1,
            minutes: TextConstants.warriorStretchRightSideMinutes1,
            seconds: TextConstants.warriorStretchRightSideSeconds1,
            progress: 0,
            video: PathConstants.warriorStretchRightSide1,
            description: TextConstants.warriorStretchRightSideDescription1,
            steps: [
              TextConstants.warriorStretchRightSide1Step1,
              TextConstants.warriorStretchRightSide1Step2,
              TextConstants.warriorStretchRightSide1Step3,
              TextConstants.warriorStretchRightSide1Step4,
            ],
          ),
        ]),
  ];

  //Home workout
  static final List<WorkoutModel> homeWorkouts = [
    WorkoutModel(
        id: 'yoga1',
        title: TextConstants.yogaTitle1,
        exercises: TextConstants.yogaExercises1,
        minutes: TextConstants.yogaMinutes1,
        currentProgress: 0,
        progress: 5,
        image: PathConstants.yoga,
        exerciseDataList: [
          ExerciseModel(
            id: 'downdogwalk',
            title: TextConstants.downDogWalk,
            minutes: TextConstants.downDogWalkMinutes,
            seconds: TextConstants.downDogWalkSeconds,
            progress: 0,
            video: PathConstants.downDogWalk,
            description: TextConstants.downDogWalkDescription,
            steps: [
              TextConstants.downDogWalkStep1,
              TextConstants.downDogWalkStep2,
              TextConstants.downDogWalkStep3,
              TextConstants.downDogWalkStep4,
            ],
          ),
          ExerciseModel(
            id: 'downdogwave',
            title: TextConstants.downDogWave,
            minutes: TextConstants.downDogWaveMinutes,
            seconds: TextConstants.downDogWalkSeconds,
            progress: 0,
            video: PathConstants.downDogWave,
            description: TextConstants.downDogWaveDescription,
            steps: [
              TextConstants.downDogWaveStep1,
              TextConstants.downDogWaveStep2,
              TextConstants.downDogWaveStep3,
              TextConstants.downDogWaveStep4,
            ],
          ),
          ExerciseModel(
            id: 'lungeHoldleftleg',
            title: TextConstants.lungeHoldLeftLeg,
            minutes: TextConstants.lungeHoldLeftLegMinutes,
            seconds: TextConstants.lungeHoldLeftLegSeconds,
            progress: 0,
            video: PathConstants.lungeHoldLeftLeg,
            description: TextConstants.lungeHoldLeftLegDescription,
            steps: [
              TextConstants.lungeHoldLeftLegStep1,
              TextConstants.lungeHoldLeftLegStep2,
              TextConstants.lungeHoldLeftLegStep3,
              TextConstants.lungeHoldLeftLegStep4,
              TextConstants.lungeHoldLeftLegStep5,
              TextConstants.lungeHoldLeftLegStep6,
              TextConstants.lungeHoldLeftLegStep7,
            ],
          ),
          ExerciseModel(
            id: 'siderotation',
            title: TextConstants.sideRotation,
            minutes: TextConstants.sideRotationMinutes,
            seconds: TextConstants.sideRotationSeconds,
            progress: 0,
            video: PathConstants.sideRotation,
            description: TextConstants.sideRotationDescription,
            steps: [
              TextConstants.sideRotationStep1, 
              TextConstants.sideRotationStep2, 
              TextConstants.sideRotationStep3, 
              TextConstants.sideRotationStep4,],
          ),
          ExerciseModel(
            id: 'warriorstretchrightside',
            title: TextConstants.warriorStretchRightSide1,
            minutes: TextConstants.warriorStretchRightSideMinutes1,
            seconds: TextConstants.warriorStretchRightSideSeconds1,
            progress: 0,
            video: PathConstants.warriorStretchRightSide1,
            description: TextConstants.warriorStretchRightSideDescription1,
            steps: [
              TextConstants.warriorStretchRightSide1Step1,
              TextConstants.warriorStretchRightSide1Step2,
              TextConstants.warriorStretchRightSide1Step3,
              TextConstants.warriorStretchRightSide1Step4,
            ],
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
