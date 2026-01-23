import 'package:flutter/material.dart';

IconData getIconDataFromName(String iconName) {
  // Маппинг названий иконок на IconData
  final Map<String, IconData> iconMap = {
    // Основные
    'home': Icons.home,
    'star': Icons.star,
    'star_border': Icons.star_border,
    'star_outline': Icons.star_outline,
    'star_filled': Icons.star,

    // Навигация
    'arrow_back': Icons.arrow_back,
    'arrow_forward': Icons.arrow_forward,
    'arrow_back_ios': Icons.arrow_back_ios,
    'arrow_forward_ios': Icons.arrow_forward_ios,
    'chevron_left': Icons.chevron_left,
    'chevron_right': Icons.chevron_right,
    'menu': Icons.menu,
    'more_vert': Icons.more_vert,
    'more_horiz': Icons.more_horiz,

    // Действия
    'add': Icons.add,
    'remove': Icons.remove,
    'close': Icons.close,
    'cancel': Icons.cancel,
    'delete': Icons.delete,
    'edit': Icons.edit,
    'create': Icons.create,
    'save': Icons.save,
    'check': Icons.check,
    'check_circle': Icons.check_circle,

    // Контент
    'copy': Icons.copy,
    'content_copy': Icons.content_copy,
    'cut': Icons.cut,
    'paste': Icons.paste,
    'filter_list': Icons.filter_list,
    'sort': Icons.sort,

    // Социальные
    'person': Icons.person,
    'person_outline': Icons.person_outline,
    'people': Icons.people,
    'group': Icons.group,
    'account_circle': Icons.account_circle,
    'share': Icons.share,

    // Уведомления
    'notifications': Icons.notifications,
    'notifications_none': Icons.notifications_none,
    'notification_important': Icons.notification_important,

    // Для вашего случая (достижения)
    'flag': Icons.flag,
    'flag_rounded': Icons.flag_rounded,
    'trophy': Icons.emoji_events,
    'award': Icons.military_tech,
    'medal': Icons.workspace_premium,
    'crown': Icons.king_bed,
    'shield': Icons.security,
    'badge': Icons.workspace_premium,
    'cup': Icons.emoji_events,

    // Разное
    'settings': Icons.settings,
    'info': Icons.info,
    'help': Icons.help,
    'warning': Icons.warning,
    'error': Icons.error,
    'visibility': Icons.visibility,
    'visibility_off': Icons.visibility_off,
    'lock': Icons.lock,
    'lock_open': Icons.lock_open,
    'search': Icons.search,
    'download': Icons.download,
    'upload': Icons.upload,
    'refresh': Icons.refresh,
    'favorite': Icons.favorite,
    'favorite_border': Icons.favorite_border,
    'bookmark': Icons.bookmark,
    'bookmark_border': Icons.bookmark_border,
    'thumb_up': Icons.thumb_up,
    'thumb_down': Icons.thumb_down,

    // Флаги/метки (альтернативы)
    'place': Icons.place,
    'location_on': Icons.location_on,
    'location_pin': Icons.location_pin,
    'pin_drop': Icons.pin_drop,
    'where_to_vote': Icons.where_to_vote,
  };

  // Приводим к нижнему регистру и убираем пробелы
  final normalizedName = iconName.toLowerCase().trim();

  // Ищем иконку в мапе
  return iconMap[normalizedName] ?? Icons.help_outline;
}
