
class HealthCardViewModel {
  HealthCardViewModel(this.value, this.change);
  HealthCardViewModel.changeFromValueBefore(this.value, double valueBefore)
    : change = value != null && valueBefore != null ? value - valueBefore : null;

  final double value;
  final double change;
}
