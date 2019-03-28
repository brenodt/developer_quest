import 'package:dev_rpg/src/style_sphinx/fonts.dart';
import 'package:dev_rpg/src/style_sphinx/kittens.dart';
import 'package:dev_rpg/src/style_sphinx/row_question.dart';
import 'package:dev_rpg/src/style_sphinx/success_route.dart';
import 'package:dev_rpg/src/style_sphinx/text_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainAxisQuestion extends StatefulWidget {
  final EdgeInsets iconPadding;
  final double iconSize;

  const MainAxisQuestion({
    Key key,
    this.iconPadding = const EdgeInsets.all(4),
    this.iconSize = 100,
  }) : super(key: key);

  @override
  _MainAxisQuestionState createState() => _MainAxisQuestionState();
}

class _MainAxisQuestionState extends State<MainAxisQuestion>
    with TickerProviderStateMixin {
  MainAxisAlignment _mainAxisAlignment;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    // Create the animation controller to drive the offset animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create an animation to move icons up and down using a Tween that is
    // driven by the controller
    _offsetAnimation = _controller.drive(Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: const Offset(0, 0.05),
    ));

    // Create an animation to change the color of the Dropdown hint that is
    // driven by the controller
    _colorAnimation = _controller.drive(ColorTween(
      begin: Colors.black12,
      end: Colors.black,
    ));

    // Start the animation and ensure it repeats indefinitely
    _controller
      ..forward()
      ..repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = <KittyType>[
      KittyType.blue,
      KittyType.brown,
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 24.0,
                top: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const JoystixText(
                    '''Select the correct mainAxisAlignment to move the kitties to their beds''',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    children: [
                      DropdownButton<MainAxisAlignment>(
                        hint: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, _) {
                            return MonoText(
                              'Alignment',
                              style: TextStyle(
                                color: _colorAnimation.value,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                        items: const [
                          DropdownMenuItem<MainAxisAlignment>(
                            child: MonoText(
                              'center',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: MainAxisAlignment.center,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: MonoText(
                              'start',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: MainAxisAlignment.start,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: MonoText(
                              'end',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: MainAxisAlignment.end,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: MonoText(
                              'spaceAround',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: MainAxisAlignment.spaceAround,
                          ),
                          DropdownMenuItem<MainAxisAlignment>(
                            child: MonoText(
                              'spaceBetween',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            value: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                        value: _mainAxisAlignment,
                        onChanged: (mainAxisAlignment) async {
                          setState(() {
                            _mainAxisAlignment = mainAxisAlignment;
                          });

                          if (_mainAxisAlignment == MainAxisAlignment.center) {
                            final animation =
                                await Navigator.push<Animation<double>>(
                              context,
                              SuccessRoute(
                                child: TextBubble(
                                  bottomPadding: 28,
                                  child: Column(
                                    children: const [
                                      JoystixText(
                                        '''You've done it!''',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 16),
                                      JoystixText(
                                        '''A Column widget displays its children one after the next in a vertical direction.''',
                                      ),
                                      SizedBox(height: 16),
                                      ProceedButton(),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            animation.addListener(() {
                              if (animation.isDismissed) {
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => const RowQuestion(),
                                  ),
                                );
                              }
                            });
                          }
                        },
                      ),
                      const MonoText('(')
                    ],
                    crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                  const MonoText('  children: <Widget>['),
                  const MonoText('    Image.asset(\'blue_kitty.png\')'),
                  const MonoText('    Image.asset(\'brown_kitty.png\')'),
                  const MonoText('  ],'),
                  const MonoText('),'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(color: Colors.grey[300]),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildExpected(children),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildResult(children),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(List<KittyType> kittens) {
    final bouncingChildren = kittens.map((type) {
      return Padding(
        padding: widget.iconPadding,
        child: SlideTransition(
          position: _offsetAnimation,
          child: SizedBox(
            child: Kitty(type: type),
            width: widget.iconSize,
            height: widget.iconSize,
          ),
        ),
      );
    }).toList();

    return Column(
      children: bouncingChildren,
      mainAxisAlignment: _mainAxisAlignment,
    );
  }

  Widget _buildExpected(List<KittyType> kittens) {
    return Column(
      children: kittens.map((type) {
        return Padding(
          padding: widget.iconPadding,
          child: SizedBox(
            width: widget.iconSize,
            height: widget.iconSize,
            child: KittyBed(
              type: type,
            ),
          ),
        );
      }).toList(),
    );
  }
}
