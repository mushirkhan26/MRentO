import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchUrlString(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!success) {
          // fallback to in-app
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
        }
      } else {
        // fallback if no external app found
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch (e) {
      debugPrint("UrlLauncher error: $e");
      rethrow;
    }
  }

  static Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  static Future<void> launchWhatsApp(String phoneNumber, {String message = ""}) async {
    // Standard WhatsApp link format: https://wa.me/number?text=message
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final String encodedMessage = Uri.encodeComponent(message);
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber?text=$encodedMessage");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}
