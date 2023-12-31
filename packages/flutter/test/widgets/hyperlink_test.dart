// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

void main() {
  testWidgetsWithLeakTracking('Can tap a hyperlink', (WidgetTester tester) async {
    bool didTapLeft = false;
    final TapGestureRecognizer tapLeft = TapGestureRecognizer()
      ..onTap = () {
        didTapLeft = true;
      };

    bool didTapRight = false;
    final TapGestureRecognizer tapRight = TapGestureRecognizer()
      ..onTap = () {
        didTapRight = true;
      };

    const Key textKey = Key('text');

    await tester.pumpWidget(
      Center(
        child: RichText(
          key: textKey,
          textDirection: TextDirection.ltr,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'xxxxxxxx',
                recognizer: tapLeft,
              ),
              const TextSpan(text: 'yyyyyyyy'),
              TextSpan(
                text: 'zzzzzzzzz',
                recognizer: tapRight,
              ),
            ],
          ),
        ),
      ),
    );

    final RenderBox box = tester.renderObject(find.byKey(textKey));

    expect(didTapLeft, isFalse);
    expect(didTapRight, isFalse);

    await tester.tapAt(box.localToGlobal(Offset.zero) + const Offset(2.0, 2.0));

    expect(didTapLeft, isTrue);
    expect(didTapRight, isFalse);

    didTapLeft = false;

    await tester.tapAt(box.localToGlobal(Offset.zero) + const Offset(30.0, 2.0));

    expect(didTapLeft, isTrue);
    expect(didTapRight, isFalse);

    didTapLeft = false;

    await tester.tapAt(box.localToGlobal(Offset(box.size.width, 0.0)) + const Offset(-2.0, 2.0));

    expect(didTapLeft, isFalse);
    expect(didTapRight, isTrue);
  });
}
