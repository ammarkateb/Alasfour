import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoriteHeartButton extends StatefulWidget {
  final bool isFavorite;
  final Future<void> Function()? onPressed;
  final double diameter;

  const FavoriteHeartButton({
    super.key,
    required this.isFavorite,
    this.onPressed,
    this.diameter = 28,
  });

  @override
  State<FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<FavoriteHeartButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late bool _isFavoriteLocal;
  bool _isProcessing = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _isFavoriteLocal = widget.isFavorite;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant FavoriteHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      setState(() {
        _isFavoriteLocal = widget.isFavorite;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onPressed == null || _isProcessing) return;
    setState(() {
      _isProcessing = true;
      _isFavoriteLocal = !_isFavoriteLocal;
    });
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 40));
    await _controller.reverse();
    try {
      await widget.onPressed!.call();
    } catch (e) {
      // Revert optimistic state on error
      if (mounted) {
        setState(() {
          _isFavoriteLocal = !_isFavoriteLocal;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isPressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFE9ECEF);
    final iconColor = _isPressed ? const Color(0xFFFF8FB1) : const Color(0xFFD30000);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        if (_isProcessing) return;
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (_isPressed) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () {
        if (_isPressed) {
          setState(() => _isPressed = false);
        }
      },
      onTap: _isProcessing ? null : _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: widget.diameter,
          height: widget.diameter,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'Design materials/Icons/Frame 2147227093.svg',
              width: widget.diameter * 0.55,
              height: widget.diameter * 0.55,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
