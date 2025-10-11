import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

///The 4 Official Kofi Button Colors
enum KofiColor { blue, black, orange, red, grey }

///A button to use if you link to Ko-fi
class KofiButton extends StatelessWidget {
  ///Display this text on the button default: Support me on Ko-fi
  final String text;

  ///On of the 4 [KofiColor]s
  final KofiColor kofiColor;

  ///Name of your account on kofi in lowercase, you can get it if you visit your page.
  ///How does a name look like: flajt , how does the full url look like? https://ko-fi.com/flajt <- this part after the / is your account name
  final String kofiName;

  ///function to call after opening the url
  final VoidCallback? onDonation;

  ///Optional custom styling
  final ButtonStyle? style;

  ///function to call when launch url
  final Future<bool> Function(String urlString)? onLaunchURL;

  ///If [isEnabled] == false, onPressed will not work and background color will be grey (BuyMeACoffeeColor.Grey)
  final bool isEnabled;

  const KofiButton({
    Key? key,
    this.text = "Support me on Ko-fi",
    required this.kofiName,
    this.kofiColor = KofiColor.blue,
    this.onDonation,
    this.style,
    this.onLaunchURL,
    this.isEnabled = true,
  }) : super(key: key);
  
  final String baseUrl = "https://ko-fi.com/";

  @override
  Widget build(BuildContext context) {
    assert(kofiName.isNotEmpty);
    return ElevatedButton.icon(
      onPressed: !isEnabled
          ? null
          : () async {
              try {
                final url = baseUrl + kofiName;
                await (onLaunchURL != null
                    ? onLaunchURL!(url)
                    : launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                        webOnlyWindowName: '_blank',
                      ));
              } catch (e) {
                debugPrint("Error: $e");
              }
              if (onDonation != null) {
                onDonation!();
              }
            },
      icon: const Icon(SimpleIcons.kofi),
      label: Text(text),
    );
  }
}