 String getFlagEmoji(String countryCode) {
    Map<String, String> flags = {
      'DE': '🇩🇪',
      'US': '🇺🇸',
      'GB': '🇬🇧',
    };
    return flags[countryCode] ?? '🏳️';
  }