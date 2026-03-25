/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/command_runner_base.dart';

import 'dart:io';
import 'package:http/http.dart' as http;

// TODO: Export any libraries intended for clients of this package.

class CommandRunner {
  final version = '0.0.1';

  Future<void> run(List<String> arguments) async {
    print("CommandRunner running package $arguments");

    if (arguments.isEmpty || arguments.first == 'help') {
      this.printUsage();
    } else if (arguments.first == 'version') {
      print('Dartpedia CLI version $version');

    } else if (arguments.first == 'wikipedia') {
      final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
      this.searchWikipedia(inputArgs);
    } else {
      this.printUsage();
    }
  }

  void printUsage() {
    print(
      "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
    );
  }

  void searchWikipedia(List<String>? arguments) async {
    final String? articleTitle;

    if (arguments == null || arguments.isEmpty) {
      print('Please provide an article title.');

      final inputFromStdin = stdin.readLineSync();

      if (inputFromStdin == null || inputFromStdin.isEmpty) {
        print('No article title provided. Exiting.');
        return;
      }
      articleTitle = inputFromStdin;
    } else {
      articleTitle = arguments.join(' ');
    }

    print('Looking up articles about "$articleTitle". Please wait.');

    var articleContent = await this.getWikipediaArticle(articleTitle);
    print(articleContent);
  }

  Future<String> getWikipediaArticle(String articleTitle) async {
    final url = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/summary/$articleTitle',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    }

    return 'Error: Failed to fetch article "$articleTitle". Status code ${response.statusCode}';
  }
}
