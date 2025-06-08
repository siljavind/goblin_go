// lib/features/onboarding/onboarding_state.dart
/// Represents the possible states of the onboarding permission flow.
enum OnboardingState {
  awaitingInUse, // Waiting for "While In Use" location permission
  awaitingAlways, // Waiting for "Always" location permission
  error, // Permission denied forever
  granted, // All permissions granted
}
