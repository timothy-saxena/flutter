# Flutter experiments 6 and 8: learn from zero

These four standalone programs cover all four syllabus parts. Any working code is accepted by your teacher, according to your clarification. The examples retain the required concepts while removing decorative details and repeated app classes. They are based on the supplied syllabus and lab material; they cannot guarantee an examiner's mark.

## 1. What to open

| Part | Code file | What you demonstrate |
| --- | --- | --- |
| 6(a) | [exp6a_custom_widget.dart](exp6a_custom_widget.dart) | A custom `ProfileCard`, reused for two people |
| 6(b) | [exp6b_theme.dart](exp6b_theme.dart) | App-wide theme settings and a local text style |
| 8(a) | [exp8a_size_animation.dart](exp8a_size_animation.dart) | A square grows and shrinks using AnimatedContainer |
| 8(b) | [exp8b_fade_slide.dart](exp8b_fade_slide.dart) | Separate squares fade and slide when the Animate button is pressed |

Study in this order: **6(a), 6(b), 8(a), 8(b)**. Each file is an independent program. Do not paste all four into one file: they each contain their own `main()`.

## 2. Running a program

In the exam, open the lab's existing Flutter project. Replace the contents of `lib/main.dart` with ONE complete program and run it. To change experiments, replace the whole file and stop/restart the app. This also reruns animation initialization.

On your Mac, your current project is `first_flutter/flutter_application_1`. The new files are already inside its `lib/exam_prep_6_8` folder. From that project's terminal, you can run a file without replacing your existing main.dart:

```sh
flutter run -d chrome -t lib/exam_prep_6_8/exp6a_custom_widget.dart
```

Change the last filename for the other programs. These programs need only Flutter's built-in material library: no images, downloads, extra packages, or internet requests at runtime. A configured Flutter project and SDK are still required. The same Dart code works on Windows; the local folder path differs.

## 3. The foundation: Flutter builds a screen from widgets

**Dart** is the language. **Flutter** supplies the widgets used to create the screen. A **widget** describes a piece of the user interface, such as text, a button, a card, or a layout.

Imagine assembling a screen from boxes inside boxes:

```text
MaterialApp                 App settings and Material support
  MyPage                    Our screen
    Scaffold                Basic screen layout
      appBar: AppBar        Top title bar
      body: Column          Main content arranged vertically
        ProfileCard         First person's card
        ProfileCard         Second person's card
```

`child:` holds one widget. `children: [...]` holds a list of widgets. `body:` is the Scaffold's main content area. `title:` names the content used as a title. These are named arguments: the word before the colon says which setting you are supplying.

### Read the common opening

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyPage()));
}
```

- `import` makes Flutter's Material widgets available.
- `main()` is where execution begins.
- `void` means the function does not return a result.
- `runApp(...)` starts displaying the supplied widget.
- `MaterialApp(...)` provides app-level Material support and settings.
- `home: MyPage()` makes our `MyPage` widget the initial screen.

An object is a particular instance created from a class. `MyPage` is a class; `MyPage()` creates an instance of it. You do not need a separate `MyApp` class just to wrap `MaterialApp`, so these examples omit it.

### Symbols you will keep seeing

| Syntax | Meaning here |
| --- | --- |
| `class MyPage` | Defines our widget type |
| `extends StatelessWidget` | Uses Flutter's base for a widget without its own mutable State object |
| `@override` | We are providing our implementation of an inherited method |
| `Widget build(BuildContext context)` | A method that returns the widgets to display |
| `context` | Identifies this widget's location in the widget tree |
| `return` | Sends the result back to the caller |
| `()` | Function/constructor arguments, or method parameters |
| `{}` | A class/function body; inside parameters, also used for named parameters |
| `[]` | A list, such as a list of child widgets |
| `;` | Ends a statement |
| `const` | Creates a constant object when the supplied values allow it |
| `super.key` | Passes an optional widget identity key to Flutter's parent constructor |

Keep `const MyPage({super.key});` as the standard constructor line. You do not need to invent a key for these exercises. A StatelessWidget can still rebuild when its parent or inherited settings change; it simply does not manage a separate mutable State object of its own.

## 4. Experiment 6(a): shorter custom widget

**Expected output:** two cards with person icons, one showing Rahul and another showing Krishna.

Use the updated `exp6a_custom_widget.dart`. This version builds the screen directly inside main, so it does not need the separate MyPage class described in the general foundation above. There is just one custom class: ProfileCard.

### Create the screen

MaterialApp contains a Scaffold. The Scaffold supplies a title bar and a body. Its Column arranges these two widgets vertically:

```dart
ProfileCard('Rahul'),
ProfileCard('Krishna'),
```

Each line creates a card using the same custom widget, with a different name.

### Store the supplied name

```dart
final String name;
const ProfileCard(this.name, {super.key});
```

String means text. final means the name is assigned once for that card object. The constructor ProfileCard receives the supplied text and this.name stores it in the card's name field. Here the name is a positional argument: write `ProfileCard('Rahul')`, without `name:`. super.key passes an optional identification key to Flutter.

### Define the appearance once

```dart
return Card(
  child: ListTile(
    leading: const Icon(Icons.person),
    title: Text(name),
  ),
);
```

Card provides the card surface. ListTile places the person icon on the left and the name beside it. Text(name) displays the supplied name. Text('name') would display the literal word name.

ProfileCard extends StatelessWidget because it has no changing State object to manage. Its build method returns the UI for that card.

**Why it meets 6(a):** it defines a custom widget class for a specific UI element, accepts input, and reuses the widget with different values.

**Practise:** change Rahul to your name, then add a third ProfileCard inside children. Recreate the code in this order: import/main, screen with two card calls, custom class, name field/constructor, build method.

**Viva answer:** "A custom widget is a reusable UI component created by the developer. My ProfileCard accepts a name and displays a card with a person icon. I reuse it with different names."

## 5. Experiment 6(b): shorter themes and custom styles

Use `exp6b_theme.dart`. It needs only main(), with no custom classes.

**Output:** a pale yellow screen, a blue title bar with white text, and a red, bold Welcome message of font size 30 in the center.

Two ideas cover the requirement:

1. **ThemeData inside MaterialApp:** shared appearance settings. scaffoldBackgroundColor sets the default screen background; appBarTheme sets the default title-bar background and foreground colors. The Scaffold and AppBar use these settings without being given their own colors.
2. **TextStyle inside Text:** a local custom style. fontSize, color, and fontWeight customize the Welcome message.

No Theme.of(context) lookup is needed because Scaffold and AppBar automatically consume their theme settings. Center places the Text in the center of the body.

**Practise:** change Colors.yellow.shade100 to Colors.green.shade100 to change the theme background. Change the TextStyle color to Colors.purple to change only the Welcome message.

**Viva:** "A theme provides shared default appearance settings. A custom style changes an individual widget. I use ThemeData for screen and title-bar colors, and TextStyle for the message."

## 6. Experiment 8(a): button-controlled size animation

This is the selected version: StatefulWidget, `double size = 50`, AnimatedContainer, and an Animate button. It uses the same basic structure as 8(b).

**Output:** a 50-by-50 blue square. Press Animate to grow it to 200-by-200 over two seconds. Press again to shrink it back.

The button runs:

```dart
setState(() {
  size = size == 50 ? 200 : 50;
});
```

Read this as: if size equals 50, set it to 200; otherwise set it to 50. `==` compares; `=` assigns. setState asks Flutter to rebuild using the new target size. AnimatedContainer animates its width and height to that target over its duration. No manual controller, initState, or dispose is needed.

**Viva:** "AnimatedContainer animates changes to its properties. I change its target width and height using setState."

## 7. Experiment 8(b): button-controlled fade and slide

Learn the same page structure as 8(a). Replace the size variable with `double value = 0`, and replace AnimatedContainer with AnimatedOpacity and AnimatedSlide. Both use the same value and a two-second duration.

**Output:** initially the blue square is invisible, while the red square is visible. Press Animate: blue fades in and red slides right by its own width. Press again: blue fades out and red returns to its normal position. The invisible blue square still reserves layout space.

```dart
value = value == 0 ? 1 : 0;
```

This switches the target between 0 and 1. The button changes it inside setState, just like 8(a).

- `AnimatedOpacity(opacity: value, ...)`: 0 means invisible, 1 means fully visible. Flutter animates intermediate opacity values.
- `AnimatedSlide(offset: Offset(value, 0), ...)`: the first coordinate is horizontal displacement and the second is vertical displacement. Offset(0, 0) is the normal position; Offset(1, 0) is one child-width to its right. With a 100-wide square, that means a 100 logical-pixel shift.
- `Duration(seconds: 2)` controls both animations' time.

The value variable changes to the new target immediately. The animation widgets display the gradual transition. You do not need to write a controller, tween, initState, or dispose yourself.

**Practise:** change Offset(value, 0) to Offset(0, value) to slide down and back up. Change the duration to four seconds to slow the effects down.

**Viva:** "AnimatedOpacity changes visibility, and AnimatedSlide changes position. setState changes their targets, and Flutter handles the animations automatically."

If only fade or only slide is asked, remove the other Animated widget and keep the variable and button. If scale is specifically requested, an optional third child is:

```dart
AnimatedScale(
  scale: value,
  duration: const Duration(seconds: 2),
  child: const FlutterLogo(size: 60),
),
```

## 8. How to practise without memorizing blindly

For each program:

1. Read the expected output before reading the code.
2. Run it and see whether the output matches.
3. Explain each block aloud using the guide.
4. Change one value and predict what will happen before running.
5. Close the reference and type the program yourself.
6. Compare and fix the blocks you forgot. Repeat once.

Learn the common screen structure first. Then remember the unique requirement:

| Part | The block you must be able to explain |
| --- | --- |
| 6(a) | ProfileCard class, its constructor, and reuse with different values |
| 6(b) | ThemeData for shared colors and TextStyle for the Welcome message |
| 8(a) | AnimatedContainer, duration, and the size change inside setState |
| 8(b) | AnimatedOpacity, AnimatedSlide, and switching value between 0 and 1 |

Common mistakes: missing commas between named arguments; missing `required` values; quoting variable names; putting two programs in one file; forgetting setState when changing size/value; confusing target values with intermediate displayed values. Use a full restart when switching examples.

## References

Local requirements: `Flutter_syllabus.pdf`, experiment 6 text files, and `exp8/Flutter-labsession-8.pdf` in the Flutter course folder.

- [Flutter: Theme.of and the location of BuildContext](https://api.flutter.dev/flutter/material/Theme/of.html)
- [Flutter: AnimationController and its lifecycle](https://api.flutter.dev/flutter/animation/AnimationController-class.html)
- [Flutter: SlideTransition offsets](https://api.flutter.dev/flutter/widgets/SlideTransition-class.html)
- [Flutter: animations overview](https://docs.flutter.dev/ui/animations/overview)

- [Flutter: AnimatedContainer](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html)
- [Flutter: AnimatedOpacity](https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html)
- [Flutter: AnimatedSlide](https://api.flutter.dev/flutter/widgets/AnimatedSlide-class.html)
