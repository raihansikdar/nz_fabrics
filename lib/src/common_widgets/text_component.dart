import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class TextComponent extends StatelessWidget {
  const TextComponent({
    super.key,
    required this.text,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.strutStyle,
    this.textDirection,
    this.softWrap,
    this.locale,
    this.textScalar,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
    this.height,
    this.leadingDistribution,
    this.foreground,
    this.background,
    this.shadows,
    this.fontFeatures,
    this.fontVariations,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.debugLabel,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
  });

  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final bool? softWrap;
  final Locale? locale;
  final TextScaler? textScalar;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
  final double? height;
  final TextLeadingDistribution? leadingDistribution;
  final Paint? foreground;
  final Paint? background;
  final List<Shadow>? shadows;
  final List<FontFeature>? fontFeatures;
  final List<FontVariation>? fontVariations;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final String? debugLabel;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final String? package;





  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Text(
      text,
      maxLines: maxLines ?? 1,
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      strutStyle: strutStyle,
      textDirection: textDirection,
      softWrap: softWrap,
      locale: locale,
      textScaler: textScalar ,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,

      style: TextStyle(
        color: color ?? const Color(0xFF440003),
        backgroundColor: backgroundColor,
        fontSize: fontSize ?? size.height * k16TextSize,
        fontWeight : fontWeight ?? FontWeight.w500,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        fontVariations: fontVariations,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily ?? 'Inter-Medium',
        fontFamilyFallback: fontFamilyFallback,
        package: package,
      ),
    );
  }
}