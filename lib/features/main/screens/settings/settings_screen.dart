import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/main/screens/settings/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем провайдер настроек
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          // Категория: Приложение
          _buildSectionHeader(context, 'Приложение'),

          _buildSettingTile(
            context: context,
            title: 'О приложении',
            subtitle: 'Информация о приложении и разработчиках',
            icon: Icons.info_outline,
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          _buildSettingTile(
            context: context,
            title: 'Язык',
            subtitle: 'Русский',
            icon: Icons.language,
            onTap: () {
              // Будущая функциональность
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Функция находится в разработке')),
              );
            },
          ),

          // Категория: Контент
          _buildSectionHeader(context, 'Контент'),

          _buildSettingTile(
            context: context,
            title: 'Загрузить дополнительные материалы',
            subtitle: 'Расширить базу знаний приложения',
            icon: Icons.download,
            onTap: () {
              // Будущая функциональность
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Функция находится в разработке')),
              );
            },
          ),

          _buildSettingTile(
            context: context,
            title: 'Очистить кэш',
            subtitle: 'Освободить место на устройстве',
            icon: Icons.cleaning_services,
            onTap: () {
              _showClearCacheDialog(context, settingsProvider);
            },
          ),

          // Категория: Карта
          _buildSectionHeader(context, 'Карта'),

          Consumer<SettingsProvider>(builder: (context, provider, child) {
            return SwitchListTile(
              title: const Text('Использовать геолокацию'),
              subtitle: const Text('Показывать ваше местоположение на карте'),
              secondary: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              value: provider.useGeolocation,
              onChanged: (value) {
                provider.setUseGeolocation(value);
              },
            );
          }),

          Consumer<SettingsProvider>(builder: (context, provider, child) {
            return SwitchListTile(
              title: const Text('Загружать карты офлайн'),
              subtitle: const Text('Доступ к картам без интернета'),
              secondary: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.map,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              value: provider.offlineMaps,
              onChanged: (value) {
                provider.setOfflineMaps(value);
              },
            );
          }),

          // Категория: Уведомления
          _buildSectionHeader(context, 'Уведомления'),

          Consumer<SettingsProvider>(builder: (context, provider, child) {
            return SwitchListTile(
              title: const Text('Уведомления о новых событиях'),
              subtitle: const Text(
                  'Получать информацию о новых культурных мероприятиях'),
              secondary: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              value: provider.notifications,
              onChanged: (value) {
                provider.setNotifications(value);
              },
            );
          }),

          // Кнопка выхода из аккаунта в будущем
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Будущая функциональность
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Функция находится в разработке')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red,
              ),
              child: const Text('Выйти из аккаунта'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Создание заголовка секции настроек
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // Создание элемента настройки
  Widget _buildSettingTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Диалог с информацией о приложении
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Чеченские традиции'),
            SizedBox(height: 8),
            Text('Версия: 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Приложение для ознакомления с культурой, традициями и историческими местами Чеченской Республики.',
            ),
            SizedBox(height: 16),
            Text('© 2023 Все права защищены'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  // Диалог очистки кэша
  void _showClearCacheDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистка кэша'),
        content: const Text(
          'Вы действительно хотите очистить кэш приложения? Это может привести к удалению некоторых сохраненных данных.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Логика очистки кэша через провайдер
              provider.clearCache().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Кэш успешно очищен')),
                );
              });
            },
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }
}
