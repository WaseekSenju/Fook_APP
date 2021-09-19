

class ChipData {
  final String label;
   bool isSelected;

   ChipData({
    required this.label,
    required this.isSelected,

  });

  ChipData copy({
    required String label,
    required bool isSelected,

  }) =>
      ChipData(
        label: this.label,
        isSelected: this.isSelected,
      );
}

class Chips {
  static final all = <ChipData>[
    ChipData(
      label: 'Football',
      isSelected: false,
    ),
    ChipData(
      label: 'Fortnite',
      isSelected: false,
    ),
    ChipData(
      label: 'Rolex',
      isSelected: false,
    ),
    ChipData(
      label: 'Music',
      isSelected: false,
    ),
    ChipData(
      label: 'Nahmii',
      isSelected: false,
    ),
    ChipData(
      label: 'MMA',
      isSelected: false,
    ),
    ChipData(
      label: 'Anime',
      isSelected: false,
    ),
    ChipData(
      label: 'Football',
      isSelected: false,
    ),
    ChipData(
      label: 'Fortnite',
      isSelected: false,
    ),
    ChipData(
      label: 'Rolex',
      isSelected: false,
    ),
    ChipData(
      label: 'Music',
      isSelected: false,
    ),
    ChipData(
      label: 'Nahmii',
      isSelected: false,
    ),
  ];
}
