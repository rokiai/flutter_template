enum Flavor {
  dev,
  staging,
  prod;

  static Flavor get current {
    const value = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    return Flavor.values.firstWhere(
      (f) => f.name == value,
      orElse: () => Flavor.dev,
    );
  }

  bool get showTalker => this == Flavor.dev || this == Flavor.staging;

  String get displayName => switch (this) {
        Flavor.dev => 'App Dev',
        Flavor.staging => 'App Staging',
        Flavor.prod => 'App',
      };
}

abstract final class FlavorConfig {
  static Flavor get flavor => Flavor.current;

  static bool get showTalker => flavor.showTalker;

  static String get displayName => flavor.displayName;
}
