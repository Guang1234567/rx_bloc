part of rx_bloc_generator;

/// The generator.
class RxBlocGeneratorForAnnotation extends GeneratorForAnnotation<RxBloc> {
  /// Allows creating via `const` as well as enforces immutability here.
  const RxBlocGeneratorForAnnotation();

  /// Generates the bloc based on the class with the @RxBloc() annotation.
  /// If either the states or events class is missing the file is not generated.
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // return early if annotation is used for a none class element
    if (element is! ClassElement) {
      // Internal package error
      _logError('The @RxBloc must be used for class only.');
      return null;
    }

    final ClassElement classElement = element as ClassElement;

    final LibraryReader libraryReader = LibraryReader(classElement.library);

    try {
      return (_BuildController(
        mainBloc: classElement,
        annotation: annotation,
        libraryReader: libraryReader,
      )..generate())
          .getFileContent();
    } on _RxBlocGeneratorException catch (e) {
      // User error
      _logError(e.message);
      return null;
    } on FormatterException catch (e) {
      // Format error
      _reportIssue(
        'FormatterException \n' +
            e.errors.map((AnalysisError e) => e.message).join('\n'),
        libraryReader.allElements.first.source.contents.data.toString(),
      );
      return null;
    } on Exception catch (e) {
      // System error
      _reportIssue(
        e.toString(),
        libraryReader.allElements.first.source.contents.data.toString(),
      );
      return null;
    }
  }
}
