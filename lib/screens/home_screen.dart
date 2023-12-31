import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _rotation = 0;
  TextEditingController _userSubmittedText = TextEditingController();
  String _cypheredText = '';

  String _rotateString(String input, int rotation) {
    const int alphabetLength = 26;
    final buffer = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      final codeUnit = input.codeUnitAt(i);

      if (_isLetter(codeUnit)) {
        final base =
            _isUpperCase(codeUnit) ? 'A'.codeUnitAt(0) : 'a'.codeUnitAt(0);
        final rotated =
            ((codeUnit - base + rotation) % alphabetLength + alphabetLength) %
                alphabetLength;
        buffer.writeCharCode(rotated + base);
      } else {
        buffer
            .writeCharCode(codeUnit); // Non-letter characters remain unchanged
      }
    }

    return buffer.toString();
  }

  bool _isLetter(int codeUnit) {
    return (codeUnit >= 'A'.codeUnitAt(0) && codeUnit <= 'Z'.codeUnitAt(0)) ||
        (codeUnit >= 'a'.codeUnitAt(0) && codeUnit <= 'z'.codeUnitAt(0));
  }

  bool _isUpperCase(int codeUnit) {
    return codeUnit >= 'A'.codeUnitAt(0) && codeUnit <= 'Z'.codeUnitAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: kIsWeb ? false : true,
      appBar: AppBar(
        title: const Text('Bernie The Cypher'),
      ),
      body: SafeArea(
        bottom: kIsWeb ? false : true,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: null,
                  controller: _userSubmittedText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter text to cypher',
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Rotation'),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('A', style: Theme.of(context).textTheme.bodyLarge),
                  Icon(Icons.arrow_forward),
                  Text(_rotateString('A', _rotation),
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _rotation == 0
                        ? null
                        : () {
                            setState(() {
                              _rotation--;
                            });
                          },
                  ),
                  Text(
                    '$_rotation',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      setState(() {
                        _rotation++;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: _cypheredText.isEmpty
                      ? Text(
                          'Results will show here',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : SelectableText(
                          _cypheredText,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _userSubmittedText.clear();
                      _cypheredText = '';
                    });
                  },
                  child: Text('Clear'),
                ),
                const Gap(15),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _cypheredText = _rotateString(
                          _userSubmittedText.text, _rotation * -1);
                    });
                  },
                  child: Text('Decrypt'),
                ),
                const Gap(15),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _cypheredText =
                          _rotateString(_userSubmittedText.text, _rotation);
                    });
                  },
                  child: Text('Encrypt'),
                ),
              ],
            ),
            kIsWeb ? const Gap(20) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
