

class ChipData {
  final String label;

  const ChipData({
    required this.label,
  });

  ChipData copy({
    required String label,
  }) =>
      ChipData(
        label: this.label,
      );
}

class Chips {
  static final all = <ChipData>[
    ChipData(
      label: 'Football',
    ),
    ChipData(
      label: 'Fortnite',
    ),
    ChipData(
      label: 'Rolex',
    ),
    ChipData(
      label: 'Music',
    ),
    ChipData(
      label: 'Nahmii',
    ),
    ChipData(
      label: 'MMA',
    ),
    ChipData(
      label: 'Anime',
    ),
    ChipData(
      label: 'Football',
    ),
    ChipData(
      label: 'Fortnite',
    ),
    ChipData(
      label: 'Rolex',
    ),
    ChipData(
      label: 'Music',
    ),
    ChipData(
      label: 'Nahmii',
    ),
  ];
}
