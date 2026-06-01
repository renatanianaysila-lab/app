class QuizQuestion {
  final String id;
  final String questionText;
  final String imagePath;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.imagePath,
    required this.options,
    required this.correctAnswerIndex,
  });
}