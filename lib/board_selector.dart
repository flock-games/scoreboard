import 'package:flutter/material.dart';

class BoardSelector extends StatefulWidget {
  final void Function(String code) onLoadBoard;
  final void Function() onNewBoard;

  const BoardSelector({
    super.key,
    required this.onLoadBoard,
    required this.onNewBoard,
  });

  @override
  State<BoardSelector> createState() => _BoardSelectorState();
}

class _BoardSelectorState extends State<BoardSelector> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = 'ABCD';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Board Selector',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Board Code',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => widget.onLoadBoard(_controller.text),
                child: const Text('Load'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onNewBoard,
            child: const Text('New Board'),
          ),
        ],
      ),
    ));
  }
}
