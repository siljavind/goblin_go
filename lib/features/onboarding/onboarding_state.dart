/// Represents the possible states of the onboarding permission flow.
enum OnboardingState {
  loading, // Initial loading state
  awaitingInUse, // Waiting for "While In Use" location permission
  awaitingAlways, // Waiting for "Always" location permission
  error, // Permission denied forever
  granted, // All permissions granted
}
